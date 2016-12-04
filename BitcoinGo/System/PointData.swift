//
//  PointData.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

struct PointData {
    
    internal var latitude: String
    internal var longitude: String
    internal var amount: Int
    internal var publishDate: Date?
    
    init(latitude: String, longitude: String, amount: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.amount = amount
    }
    
    static func stringToEntity(string: String) -> PointData? {
        
        let contentsAry = string.components(separatedBy: "/")
        if contentsAry.count == 4 {
            let latitude = contentsAry[0]
            let longitude = contentsAry[1]
            let amount = Int(contentsAry[2])!
            var publishDate: Date? = nil
            if contentsAry[3].lengthOfBytes(using: String.Encoding.utf8) > 0 {
                publishDate = CommonUtility.stringToDate(string: contentsAry[3])
            }
            var entity = PointData(latitude: latitude, longitude: longitude, amount: amount)
            entity.publishDate = publishDate
            
            return entity
        }
        return nil
    }
    
    static func entityToString(entity: PointData) -> String {
        
        let latitudeStr = entity.latitude
        let longitudeStr = entity.longitude
        let amounStr = String(format: "%d", entity.amount)
        var publishDateStr: String?
        if entity.publishDate != nil {
            publishDateStr = CommonUtility.dateToString(date: entity.publishDate!)
        }
        if publishDateStr == nil {
            publishDateStr = ""
        }
        return latitudeStr + "/" + longitudeStr + "/" + amounStr + "/" + publishDateStr!
    }
}
