//
//  VCWallet.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCWallet: VCMaster {

    let MESSAGE_LIST_HEIGHT = CGFloat(80)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountUnitLabel: UILabel!
    @IBOutlet weak var messageSeparatorBar: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var noMessageLabel: UILabel!
    
    weak var vcTabbar: VCTabbar?
    var messageVcList = Array<VCMessage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noMessageLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height / 2
        
        self.refreshDisplay()
    }
    
    func refreshDisplay() {
        
        let amount = CommonUtility.addComma(value: SystemSaveData.getInstance().amount)
        self.amountLabel.text = amount
        self.amountLabel.sizeToFit()
        self.amountLabel.setLeft(left: self.view.frame.size.width / 2 - self.amountLabel.frame.size.width / 2)
        self.amountUnitLabel.sizeToFit()
        self.amountUnitLabel.setLeft(left: self.amountLabel.frame.origin.x + self.amountLabel.frame.size.width + 5)
        self.amountUnitLabel.setTop(top: self.amountLabel.frame.origin.y + self.amountLabel.frame.size.height - self.amountUnitLabel.frame.size.height - 10)
        
        
        for value in self.messageVcList {
            value.view.removeFromSuperview()
        }
        self.messageVcList.removeAll()
        
        let saveData = SystemSaveData.getInstance()
        
        var offset = self.messageSeparatorBar.frame.origin.y + self.messageSeparatorBar.frame.size.height + 20
        for (index, value) in saveData.messageList.enumerated() {
            let vcMessage = VCMessage()
            vcMessage.view.frame = CGRect(x: CGFloat(20), y: offset,
                                          width: self.view.frame.size.width - CGFloat(40),
                                          height: MESSAGE_LIST_HEIGHT)
            self.scrollView.addSubview(vcMessage.view)
            vcMessage.setMessage(messageData: value, messageIndex: index)
            vcMessage.vcWallet = self
            
            self.messageVcList.append(vcMessage)
            
            offset += MESSAGE_LIST_HEIGHT
            offset += 10
        }
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: offset + CGFloat(20))
        
        if saveData.messageList.count == 0 {
            self.noMessageLabel.isHidden = false
        }else{
            self.noMessageLabel.isHidden = true
        }
    }
    
    @IBAction func onTapSend(_ sender: Any) {

        let vcSendMoney = VCSendMoney()
        vcSendMoney.vcWallet = self
        self.stackViewControler(vc: vcSendMoney, animationType: SceneAnimationType.StackFromRight)
    }
    
    func didTapOk(messageIndex: Int) {
        
        if self.messageVcList.count <= messageIndex {
            return
        }
        
        self.setUserInteraction(enable: false)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        
                        for (index, value) in (self?.messageVcList.enumerated())! {
                            if index < messageIndex {
                                
                            } else if index == messageIndex {
                                value.view.setLeft(left: (self?.view.frame.size.width)!)
                            } else {
                                value.view.setTop(top: value.view.frame.origin.y - (self?.MESSAGE_LIST_HEIGHT)! - 10)
                            }
                        }
                        
            }, completion: { [weak self] _ in
                self?.setUserInteraction(enable: true)
                let vcMessage = self?.messageVcList[messageIndex]
                vcMessage?.view.removeFromSuperview()
                self?.messageVcList.remove(at: messageIndex)
                
                var scrollSize = self?.scrollView.contentSize
                scrollSize?.height -= (self?.MESSAGE_LIST_HEIGHT)!
                self?.scrollView.contentSize = scrollSize!
                
                let saveData = SystemSaveData.getInstance()
                saveData.messageList.remove(at: messageIndex)
                saveData.save()
                self?.refreshDisplay()
                
                self?.vcTabbar?.refreshMessageBadge(num: saveData.messageList.count)
        })
        
    }


}
