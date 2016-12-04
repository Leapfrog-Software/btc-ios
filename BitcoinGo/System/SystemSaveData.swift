//
//  SystemSaveData.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

private let shared = SystemSaveData()

class SystemSaveData {
    
    private let USERDEFAULTS_KEY_POINTLIST = "UserDefaultKeyPointList"
    private let USERDEFAULTS_KEY_AMOUNT = "UserDefaultKeyAmount"
    private let USERDEFAULTS_KEY_MESSAGELIST = "UserDefaultKeyMessageList"
    private let USERDEFAULTS_KEY_LASTPRESENTDATE = "UserDefaultKeyLastPresentDate"
    
    internal var pointDataList: Array<PointData> = Array<PointData>()
    internal var amount: Int = 0
    internal var messageList: Array<MessageData> = Array<MessageData>()
    internal var lastPresentDate: Date?
    
    init() {
        
        let userDefaults = UserDefaults()
        
        //ポイントリスト
        let pointList = userDefaults.array(forKey: USERDEFAULTS_KEY_POINTLIST) as? Array<String>
        if pointList != nil {
            for point in pointList! {
                let pointData = PointData.stringToEntity(string: point)
                if pointData != nil {
                    self.pointDataList.append(pointData!)
                }
            }
        }
        
        //残高
        let amountDecrypted = userDefaults.string(forKey: USERDEFAULTS_KEY_AMOUNT)
        if amountDecrypted != nil {
            let amount = EncryptUtility.decrypt(string: amountDecrypted!)
            let amountInt = Int(amount)
            if amountInt != nil {
                self.amount = amountInt!
            }
        }
        
        //メッセージリスト
        let messageList = userDefaults.array(forKey: USERDEFAULTS_KEY_MESSAGELIST) as? Array<String>
        if messageList != nil {
            for message in messageList! {
                let messageData = MessageData.stringToEntity(string: message)
                if messageData != nil {
                    self.messageList.append(messageData!)
                }
            }
        }
        
        //最終プレゼント日
        let lastPresentDateDecrypted = userDefaults.string(forKey: USERDEFAULTS_KEY_LASTPRESENTDATE)
        if lastPresentDateDecrypted != nil {
            let lastPresentDateStr = EncryptUtility.decrypt(string: lastPresentDateDecrypted!)
            let lastPresentDate = CommonUtility.stringToDate(string: lastPresentDateStr)
            if lastPresentDate != nil {
                self.lastPresentDate = lastPresentDate!
            }
        }
        
 
    }
    
    static func getInstance() -> SystemSaveData {
        return shared
    }
    
    func save() {
        
        let userDefaults = UserDefaults()
        
        //ポイントリスト
        var savePointList = Array<String>()
        for value in self.pointDataList {
            savePointList.append(PointData.entityToString(entity: value))
        }
        userDefaults.set(savePointList, forKey: USERDEFAULTS_KEY_POINTLIST)

        //残高
        let saveAmount = EncryptUtility.encrypt(string: String(format: "%d", self.amount))
        userDefaults.set(saveAmount, forKey: USERDEFAULTS_KEY_AMOUNT)
        
        //メッセージリスト
        var saveMessageList = Array<String>()
        for value in self.messageList {
            saveMessageList.append(MessageData.entityToString(entity: value))
        }
        userDefaults.set(saveMessageList, forKey: USERDEFAULTS_KEY_MESSAGELIST)
        
        //最終プレゼント日
        var lastPresentDateStr: String?
        if self.lastPresentDate != nil{
            lastPresentDateStr = CommonUtility.dateToString(date: self.lastPresentDate!)
        }
        if lastPresentDateStr == nil {
            lastPresentDateStr = ""
        }
        let saveLastPresentDate = EncryptUtility.encrypt(string: lastPresentDateStr!)
        userDefaults.set(saveLastPresentDate, forKey: USERDEFAULTS_KEY_LASTPRESENTDATE)
        
        //保存
        userDefaults.synchronize()
    }

    
    //1時間で再発行可能
    func refreshPublishList() {
        
        let currentDate = CurrentTimeContainer.getInstance().currentDate!
        
        for i in 0..<self.pointDataList.count {
            var pointData = self.pointDataList[i]
            let publishDate: Date? = pointData.publishDate
            guard  let cpPublishDate = publishDate else {
                continue
            }
            let diff = currentDate.timeIntervalSince(cpPublishDate)
            if diff > 1 * 60 * 60 {
                pointData.publishDate = nil
                self.pointDataList[i] = pointData
            }
        }
        self.save()
    }
    

    
}

