//
//  LocationManager.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation
import CoreLocation

private let shared = LocationManager()

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override init() {
        
        super.init()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
    }
    
    static func getInstance() -> LocationManager {
        return shared
    }
    
    func initialize() {
        
        trigger(status: CLLocationManager.authorizationStatus())
    }
    
    private func trigger(status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager!.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager!.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        trigger(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.currentLocation = CLLocation(latitude: 35.68944, longitude: 139.69167)
            return
        
        guard let newLocation = locations.last else {
            self.currentLocation = nil
            return
        }
        if newLocation.coordinate.latitude > 0 {
            self.currentLocation = newLocation
        }
    }
    
}
