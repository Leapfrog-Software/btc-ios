//
//  VCTabbar.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCTabbar: VCMaster {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageBadgeLabel: UILabel!
    @IBOutlet weak var tab1BaseView: UIView!
    @IBOutlet weak var tab1ImageView: UIImageView!
    @IBOutlet weak var tab1Label: UILabel!
    @IBOutlet weak var tab2BaseView: UIView!
    @IBOutlet weak var tab2ImageView: UIImageView!
    @IBOutlet weak var tab2Label: UILabel!
    
    var vcMap: VCMap? = nil
    var vcWallt: VCWallet? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.vcMap == nil {
            self.vcMap = VCMap()
            self.vcMap?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.containerView.addSubview((self.vcMap?.view)!)
            self.vcMap?.vcTabbar = self
        }
        if self.vcWallt == nil {
            self.vcWallt = VCWallet()
            self.vcWallt?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.containerView.addSubview((self.vcWallt?.view)!)
        }
        self.changeTab(index: 0)
        
        self.messageBadgeLabel.layer.cornerRadius = self.messageBadgeLabel.frame.size.height / 2
        self.messageBadgeLabel.clipsToBounds = true
        
        self.refreshMessageBadge(num: SystemSaveData.getInstance().messageList.count)
    }
    
    @IBAction func onTapTab1(_ sender: UIButton) {
        self.changeTab(index: 0)
    }
    
    @IBAction func onTapTab2(_ sender: UIButton) {
        self.changeTab(index: 1)
    }
    
    private func changeTab(index: Int) {
        
        if index == 0 {
            self.vcMap?.view.isHidden = false
            self.tab1ImageView.image = UIImage(named: "tab1_on")
            self.tab1Label.textColor = UIColor(red: 252/255.0, green: 147/255.0, blue: 58/255.0, alpha: 1.0)
            
        } else {
            self.vcMap?.view.isHidden = true
            self.tab1ImageView.image = UIImage(named: "tab1_off")
            self.tab1Label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        }

        if index == 1 {
            self.vcWallt?.view.isHidden = false
            self.tab2ImageView.image = UIImage(named: "tab2_on")
            self.tab2Label.textColor = UIColor(red: 252/255.0, green: 147/255.0, blue: 58/255.0, alpha: 1.0)
        } else {
            self.vcWallt?.view.isHidden = true
            self.tab2ImageView.image = UIImage(named: "tab2_off")
            self.tab2Label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        }
    }
    
    func refreshMessageBadge(num: Int) {
        
        if num == 0 {
            self.messageBadgeLabel.isHidden = true
        } else if num <= 99 {
            self.messageBadgeLabel.isHidden = false
            self.messageBadgeLabel.text = String(format: "%d", num)
        } else {
            self.messageBadgeLabel.isHidden = true
            self.messageBadgeLabel.text = String(format: "99", num)
        }
        
        self.vcWallt?.refreshDisplay()
    }

    func refreshWalletAmount() {
        
        self.vcWallt?.refreshDisplay()
    }
}
