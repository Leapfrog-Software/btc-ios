//
//  VCSendMoney.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCSendMoney: VCMaster {

    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var amountUnitLabel: UILabel!
    
    weak var vcWallet: VCWallet?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let amount = SystemSaveData.getInstance().amount
        
        self.amountLabel.text = String(format: "%d", amount)
        self.amountLabel.sizeToFit()
        
        self.amountUnitLabel.sizeToFit()
        self.amountUnitLabel.setLeft(left: self.amountLabel.frame.origin.x + self.amountLabel.frame.size.width + 5)
        self.amountUnitLabel.setTop(top: self.amountLabel.frame.origin.y + self.amountLabel.frame.size.height - self.amountUnitLabel.frame.size.height - 10)
        
        if amount < 10000 {
            self.sendButton.isEnabled = false
            self.sendButton.alpha = 0.3
            self.alertLabel.text = "Required 10,000 satoshi at least."
            self.alertLabel.isHidden = false
        }else{
            self.alertLabel.isHidden = true
        }
        
        self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height / 2
        self.sendButton.clipsToBounds = true
        
    }
    
    func setReadQrCode(qrCode: String) {
        
        self.addressTextField.text = qrCode
    }
    
    
    @IBAction func onTapCamera(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let vcCapture = VCCapture()
        vcCapture.vcSendMoney = self
        self.stackViewControler(vc: vcCapture, animationType: SceneAnimationType.StackFromRight)
    }
    
    @IBAction func onTapSend(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let address = self.addressTextField.text
        if address?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            return
        }
        
        let saveData = SystemSaveData.getInstance()
        
        HttpClient.sendMoney(amount: saveData.amount,
                             address: address!,
                             completion: { (result, status) in
                                if result {
                                    if status {
                                        let currentDate = CurrentTimeContainer.getInstance().currentDate!
                                        let messageBody = String(format: "Send %@ satoshi for wallet:%@", CommonUtility.addComma(value: saveData.amount), address!)
                                        let messageData = MessageData(date: currentDate,
                                                                      type: MessageData.MessageType.SendMoney,
                                                                      title: "Send money",
                                                                      message: messageBody,
                                                                      read: false)
                                        saveData.messageList.append(messageData)
                                        saveData.amount = 0
                                        saveData.save()
                                        
                                        self.vcWallet?.refreshDisplay()
                                        
                                        self.showAlert(title: "The request was completed.", message: "", buttonTitle: "OK", callback: {
                                            self.closeViewController(animationType: .CloseForRight)
                                        })
                                    }else{
                                        self.showAlert(title: "Error", message: "System error", buttonTitle: "OK", callback: {
                                            
                                        })
                                    }
                                }else{
                                    self.showAlert(title: "Error", message: "Communication error", buttonTitle: "OK", callback: {
                                        
                                    })
                                }
        })
    }

    @IBAction func onTapBack(_ sender: Any) {
        
        self.closeViewController(animationType: .CloseForRight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }

}
