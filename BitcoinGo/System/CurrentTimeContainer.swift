//
//  CurrentTimeContainer.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

private let shared = CurrentTimeContainer()

class CurrentTimeContainer {
    
    var currentDate: Date?
    var isLoading = false
    
    static func getInstance() -> CurrentTimeContainer {
        return shared
    }
    
    func refresh(vcTabbar: VCTabbar) {
        
        if self.isLoading {
            return
        }
        self.isLoading = true
        
        HttpClient.getCurrentTime(completion: { [weak self] (result, time) in
            self?.isLoading = false
            
            if result {
                self?.currentDate = CommonUtility.stringToDate(string: time)
                
                let saveData = SystemSaveData.getInstance()
                
                //1時間でポイント復帰
                saveData.refreshPublishList()
                
                //1日に1回ポイント発行
                
                var lastPresentDate: String?
                if saveData.lastPresentDate != nil {
                    lastPresentDate = CommonUtility.dateToString(date: saveData.lastPresentDate!)
                }
                if lastPresentDate == nil {
                    lastPresentDate = ""
                }
                if lastPresentDate!.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                    self?.publishPresent(vcTabbar: vcTabbar)
                    return
                }
                let lastPresentDateStr = lastPresentDate!.substring(to: lastPresentDate!.index(lastPresentDate!.startIndex, offsetBy: 8))
                let currentDateStr = time.substring(to: time.index(time.startIndex, offsetBy: 8))
                if lastPresentDateStr != currentDateStr {
                    self?.publishPresent(vcTabbar: vcTabbar)
                    return
                }
                
            }
        })
    }
    
    private func publishPresent(vcTabbar: VCTabbar) {
        
        let saveData = SystemSaveData.getInstance()
        saveData.amount += 100
        
        let messageData = MessageData(date: self.currentDate!,
                                      type: MessageData.MessageType.Periodic,
                                      title: "Daily bonus!",
                                      message: "Received 100 satoshi!",
                                      read: false)
        saveData.messageList.append(messageData)
        saveData.lastPresentDate = self.currentDate!
        
        saveData.save()
        
        vcTabbar.refreshMessageBadge(num: saveData.messageList.count)
        
    }
}

