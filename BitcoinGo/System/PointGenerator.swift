//
//  PointGenerator.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation
import MapKit

private let shared = PointGenerator()

class PointGenerator {
    
//    internal var pointDataList = Array<PointData>()
    
    init() {}
    
    internal static func getInstance() -> PointGenerator {
        return shared
    }
    
    internal func generate(location: CLLocation) -> Bool{
        
        var pointDataList = Array<PointData>()

        
        
        
        //保存データから読み込み
        let saveData = SystemSaveData.getInstance()
        let savedPointDataList = saveData.pointDataList
        for pointData in savedPointDataList {
            let savedLocation = CLLocation(latitude: CLLocationDegrees(pointData.latitude)!, longitude: CLLocationDegrees(pointData.longitude)!)
            let distance = location.distance(from: savedLocation)
            if distance < EFFECTIVE_DISTANCE {
                pointDataList.append(pointData)
            }
        }
        
        
        if pointDataList.count >= EFFECTIVE_NUMBER {
            return false
        }
        
        //追加
        for _ in 0..<(5 * EFFECTIVE_NUMBER) {
            if pointDataList.count >= EFFECTIVE_NUMBER {
                break
            }
            
            let randomLati = 2 * Double(arc4random_uniform(UInt32(EFFECTIVE_DISTANCE))) / Double(111111)
            let tmpLati = location.coordinate.latitude - (Double(EFFECTIVE_DISTANCE) / Double(111111)) / 2 + randomLati
            let randomLongi = 2 * Double(arc4random_uniform(UInt32(EFFECTIVE_DISTANCE))) / Double(111111)
            let tmpLongi = location.coordinate.longitude - (Double(EFFECTIVE_DISTANCE) / Double(111111)) / 2 + randomLongi
            let tmpPoint = CLLocation(latitude: tmpLati, longitude: tmpLongi)
            let distance = tmpPoint.distance(from: location)
            if distance <= EFFECTIVE_DISTANCE {
                let lati = String(format: "%f", tmpPoint.coordinate.latitude)
                let longi = String(format: "%f", tmpPoint.coordinate.longitude)
                let amount = Int(8 + arc4random_uniform(70))
                let pointData = PointData(latitude: lati, longitude: longi, amount: amount)
                pointDataList.append(pointData)
            }
        }
        
        //保存
        saveData.pointDataList = pointDataList
        saveData.save()
        return true
    }
}



