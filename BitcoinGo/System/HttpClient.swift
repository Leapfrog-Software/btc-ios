//
//  HttpClient.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

class HttpClient {
    
    static func request(urlStr: String, method: String, params: Dictionary<String, String>?, completion: @escaping ((Bool, Data?) -> Void)) {
        
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method
        
        if params != nil {
            var paramsStr = ""
            for (key, value) in params! {
                if paramsStr.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                    paramsStr += "&"
                }
                paramsStr += key
                paramsStr += "="
                paramsStr += value
            }
            request.httpBody = paramsStr.data(using: String.Encoding.utf8)
        }
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: OperationQueue.main,
                                                completionHandler: { (response, data, error) -> Void in
                                                    if error == nil {
                                                        completion(true, data)
                                                    } else {
                                                        completion(false, data)
                                                    }
        })
    }
    
    enum VersionCheckResult {
        case Ok
        case VersionError
        case OutOfService
        case SystemError
    }
    
    static func versionCheck(version: String, completion: @escaping (Bool, VersionCheckResult) -> Void) {
        
        let params: Dictionary = ["command": "versioncheck",
                                  "platform": "ios",
                                  "version": version]
        HttpClient.request(urlStr: "https://lfrogs.sakura.ne.jp/bitcoingo/srv.php", method: "POST", params: params, completion: {(result, data) in

            if result {
                let string = String(data: data!, encoding: String.Encoding.utf8)
                if string == "0" {
                    completion(true, VersionCheckResult.Ok)
                } else if string == "1" {
                    completion(true, VersionCheckResult.VersionError)
                } else if string == "2" {
                    completion(true, VersionCheckResult.OutOfService)
                } else {
                    completion(true, VersionCheckResult.SystemError)
                }
            }else{
                completion(false, VersionCheckResult.SystemError)
            }
        })
    }
    
    static func getCurrentTime(completion: @escaping (Bool, String) -> Void) {
        
        let params: Dictionary = ["command": "getcurrenttime"]
        HttpClient.request(urlStr: "https://lfrogs.sakura.ne.jp/bitcoingo/srv.php", method: "POST", params: params, completion: {(result, data) in
            if result {
                let string = String(data: data!, encoding: String.Encoding.utf8)
                if string != nil {
                    if string!.lengthOfBytes(using: String.Encoding.utf8) == 14 {
                        completion(true, string!)
                        return
                    }
                }
                completion(false, "")
            }
        })
    }
    
    static func sendMoney(amount: Int, address: String, completion: @escaping (Bool, Bool) -> Void) {
        
        var hash = 0
        var tmpAmount = amount
        while true {
            if tmpAmount > 0 {
                hash += (tmpAmount % 10)
                tmpAmount /= 10
            } else {
                break
            }
        }
        hash %= 10
        
        let amountParamStr = getRandomString(length: 89) + String(format: "%d", amount) + getRandomString(length: 26) + String(format: "%d", hash)
        
        let params: Dictionary = ["command": "sendmoney",
                                  "param": amountParamStr,
                                  "address": address]
        HttpClient.request(urlStr: "https://lfrogs.sakura.ne.jp/bitcoingo/srv.php", method: "POST", params: params, completion: {(result, data) in
            if result {
                if data != nil {
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    if dataString == "0" {
                        completion(true, true)
                    } else {
                        completion(false, false)
                    }
                    return
                }
            }
            completion(false, false)
        })
    }
    
    static func getRandomString(length: Int) -> String {
        
        let alphabet = "12345678901234567890123456789012345678901234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let upperBound = UInt32(alphabet.characters.count)
        
        return String((0..<length).map { _ -> Character in
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
    
}
