//
//  VCMessage.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCMessage: VCMaster {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    
    weak var vcWallet: VCWallet?
    var messageIndex: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layer.cornerRadius = 10.0
        self.view.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        self.view.layer.borderWidth = 1.0
        
        self.okButton.layer.borderWidth = 1.0
        self.okButton.layer.borderColor = UIColor(red: 36/255.0, green: 169/255.0, blue: 225/255.0, alpha: 1.0).cgColor
    }
    
    func setMessage(messageData: MessageData, messageIndex: Int) {
        
        self.titleLabel.text = messageData.title
        self.messageLabel.text = messageData.message
        
        let dateStr = CommonUtility.dateToString(date: messageData.date)
        if (dateStr?.lengthOfBytes(using: String.Encoding.utf8))! >= 8 {
//            let year = dateStr!.substring(to: dateStr!.index(dateStr!.startIndex, offsetBy: 4))
            
            let startIndexYear = dateStr!.index(dateStr!.startIndex, offsetBy: 0)
            let endIndexYear = dateStr!.index(startIndexYear, offsetBy: 4)
            let year = dateStr!.substring(with: startIndexYear..<endIndexYear)
            
            let startIndexMonth = dateStr!.index(dateStr!.startIndex, offsetBy: 4)
            let endIndexMonth = dateStr!.index(startIndexMonth, offsetBy: 2)
            let month = dateStr!.substring(with: startIndexMonth..<endIndexMonth)
            
            let startIndexData = dateStr!.index(dateStr!.startIndex, offsetBy: 6)
            let endIndexData = dateStr!.index(startIndexData, offsetBy: 2)
            let day = dateStr!.substring(with: startIndexData..<endIndexData)
            
            self.dateLabel.text = String(format: "%@/%@/%@", year, month, day)
            
            
        }else{
            self.dateLabel.text = "----"
        }

        
        self.messageIndex = messageIndex
    }
    
    @IBAction func onTapOk(_ sender: Any) {
        
        self.vcWallet?.didTapOk(messageIndex: self.messageIndex!)
    }

}
