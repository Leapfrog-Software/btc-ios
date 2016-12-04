//
//  EncryptUtility.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

class EncryptUtility {
    
    private static let SOURCE_STRING        = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890"
    private static let DESTINATION_STRING   = "nJaKo3OpMGczBtvxefFj080LS9uYZNQDIgy2E57h4bHRq1Pr6sCWXTUwVdiklAm"
    
    static func encrypt(string: String) -> String {
        
        let data = string.data(using: String.Encoding.utf8)
        let base64Encoded = data?.base64EncodedString()
        var encryptedString = ""
        if base64Encoded != nil {
            let base64Len = base64Encoded?.lengthOfBytes(using: String.Encoding.utf8)
            for i in 0..<base64Len! {
                let startIndex = base64Encoded!.index(base64Encoded!.startIndex, offsetBy: i)
                let endIndex = base64Encoded!.index(startIndex, offsetBy: 1)
                let c: String = base64Encoded!.substring(with: startIndex..<endIndex)
//                let encC: String = convert(c: c, sourceString: SOURCE_STRING, destinationString: DESTINATION_STRING)
                let encC: String = convert(c: c, enc: true)
                encryptedString += encC
            }
        }
        return encryptedString
    }
    
    
    static func decrypt(string: String) -> String {
        
        var decryptedString = ""
        let strLen = string.lengthOfBytes(using: String.Encoding.utf8)
        for i in 0..<strLen {
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(startIndex, offsetBy: 1)
            let c: String = string.substring(with: startIndex..<endIndex)
//            let encC: String = convert(c: c, sourceString: DESTINATION_STRING, destinationString: SOURCE_STRING)
            let encC: String = convert(c: c, enc: false)
            decryptedString += encC
        }
        let base64Decoded = Data(base64Encoded: decryptedString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if base64Decoded != nil {
            let decryptedString = String(data: base64Decoded!, encoding: String.Encoding.utf8)
            if decryptedString != nil {
                return decryptedString!
            }
        }
        return ""
    }
    
//    private static func convert(c: String, sourceString: String, destinationString: String, enc: Bool) -> String {
    private static func convert(c: String, enc: Bool) -> String {
        /*
        var index: Int = -1
        let dstLen = sourceString.lengthOfBytes(using: String.Encoding.utf8)
        for i in 0..<dstLen {
            let startIndex = sourceString.index(sourceString.startIndex, offsetBy: i)
            let endIndex = sourceString.index(startIndex, offsetBy: 1)
            let srcC: String = sourceString.substring(with: startIndex..<endIndex)
            if srcC == c {
                index = i
                break
            }
        }
        if index != -1 {
            let startIndex = destinationString.index(destinationString.startIndex, offsetBy: index)
            let endIndex = destinationString.index(startIndex, offsetBy: 1)
            let dstC: String = destinationString.substring(with: startIndex..<endIndex)
            return dstC
        }
        return c
 */
        
        var index: Int = -1
        let dstLen = DESTINATION_STRING.lengthOfBytes(using: String.Encoding.utf8)
        for i in 0..<dstLen {
            let startIndex = DESTINATION_STRING.index(DESTINATION_STRING.startIndex, offsetBy: i)
            let endIndex = DESTINATION_STRING.index(startIndex, offsetBy: 1)
            let srcC: String = DESTINATION_STRING.substring(with: startIndex..<endIndex)
            if srcC == c {
                index = i
                break
            }
        }
        if index != -1 {
            var targetIndex: Int = 0
            if enc {
                targetIndex = index + 13
                if targetIndex >= DESTINATION_STRING.lengthOfBytes(using: String.Encoding.utf8) {
                    targetIndex -= DESTINATION_STRING.lengthOfBytes(using: String.Encoding.utf8)
                }
            } else {
                targetIndex = index - 13
                if targetIndex < 0 {
                    targetIndex += DESTINATION_STRING.lengthOfBytes(using: String.Encoding.utf8)
                }
            }
            
            
            let startIndex = DESTINATION_STRING.index(DESTINATION_STRING.startIndex, offsetBy: index)
            let endIndex = DESTINATION_STRING.index(startIndex, offsetBy: 1)
            let dstC: String = DESTINATION_STRING.substring(with: startIndex..<endIndex)
            return dstC
        }
        return c
    }
}
