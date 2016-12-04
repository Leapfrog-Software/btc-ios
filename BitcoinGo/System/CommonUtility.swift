//
//  CommonUtility.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

class CommonUtility {
    
    static func dateToString(date:Date) -> String! {
        
        let ret = CommonUtility.createDateFormatter().string(from: date)
        if ret != nil {
            return ret
        }else{
            return ""
        }
    }
    
    static func stringToDate(string: String) -> Date? {
        
        return CommonUtility.createDateFormatter().date(from: string)
    }
    
    static func createDateFormatter() -> DateFormatter {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter
    }
    
    static func addComma(value: Int) -> String {
        
        let numberVal = NSNumber(value: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result = formatter.string(from: numberVal)
        return result!
    }
    
}
