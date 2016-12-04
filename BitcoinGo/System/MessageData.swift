//
//  MessageData.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

struct MessageData {
    
    enum MessageType {
        case Periodic
        case SendMoney
    }
    
    internal var date: Date
    internal var type: MessageType
    internal var title: String
    internal var message: String
    internal var read: Bool
    
    init(date: Date, type: MessageType, title: String, message: String, read: Bool) {
        
        self.date = date
        self.type = type
        self.title = title
        self.message = message
        self.read = read
    }
    
    static func stringToEntity(string: String) -> MessageData? {
        
        let contentsAry = string.components(separatedBy: "/")
        if contentsAry.count == 5 {
            let date = CommonUtility.stringToDate(string: contentsAry[0])!
            var type = MessageType.Periodic
            if contentsAry[1] == "1" {
                type = MessageType.SendMoney
            }
            let title = contentsAry[2]
            let message = contentsAry[3]
            var read = false
            if contentsAry[4] == "1" {
                read = true
            }
            let entity = MessageData(date: date, type: type, title: title, message: message, read: read)
            return entity
        }
        return nil
    }
    
    static func entityToString(entity: MessageData) -> String {
        
        let dateStr = CommonUtility.dateToString(date: entity.date)!
        var typeStr = "0"
        if entity.type == MessageType.SendMoney {
            typeStr = "1"
        }
        let titleStr = entity.title
        let messageStr = entity.message
        var readStr = "0"
        if entity.read {
            readStr = "1"
        }
        return dateStr + "/" + typeStr + "/" + titleStr + "/" + messageStr + "/" + readStr
    }
    
}

