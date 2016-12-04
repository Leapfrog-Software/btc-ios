//
//  VCPoint.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit
import MapKit

class VCPoint: VCMaster {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var latiLongiLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var starImageView: UIImageView!
    
    weak var vcMap: VCMap?
    weak var vcTabbar: VCTabbar?
    
    
    private var pointData: PointData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseView.layer.cornerRadius = 10.0
        self.baseView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        self.baseView.layer.borderWidth = 1.0
        self.baseView.clipsToBounds = true
        
        self.publishButton.layer.cornerRadius = self.publishButton.frame.size.height / 2
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height / 2
        
        
        let latiStr = self.pointData!.latitude
        var latiStrDisp = ""
        if latiStr.lengthOfBytes(using: String.Encoding.utf8) > 10 {
            latiStrDisp = latiStr.substring(to: latiStr.index(latiStr.startIndex, offsetBy: 10))
        }else{
            latiStrDisp = latiStr
        }
        let longiStr = self.pointData!.longitude
        var longiStrDisp = ""
        if longiStr.lengthOfBytes(using: String.Encoding.utf8) > 10 {
            longiStrDisp = longiStr.substring(to: longiStr.index(longiStr.startIndex, offsetBy: 10))
        }else{
            longiStrDisp = longiStr
        }

        let latiLongiStr = String(format: "%@ / %@", latiStrDisp, longiStrDisp)
        self.latiLongiLabel.text = latiLongiStr

        self.amountLabel.text = String(format:"%d", (self.pointData?.amount)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let currentLocation = LocationManager.getInstance().currentLocation else {
            self.setButtonEnabled(state: false, errorMessage: "Location error")
            return
        }
        let location = CLLocation(latitude: CLLocationDegrees(self.pointData!.latitude)!, longitude: CLLocationDegrees(self.pointData!.longitude)!)
        let distance = currentLocation.distance(from: location)
        
        if distance > PUBLISHABLE_DISTANCE * MKMapPointsPerMeterAtLatitude(currentLocation.coordinate.latitude) {
            self.setButtonEnabled(state: false, errorMessage: "Approach more.")
        }else if self.pointData!.publishDate != nil {
            self.setButtonEnabled(state: false, errorMessage: "Try at a time.")
        }else{
            self.setButtonEnabled(state: true, errorMessage: "")
        }
    }
    
    private func setButtonEnabled(state: Bool, errorMessage: String) {
        
        if state {
            self.publishButton.isEnabled = true
            self.publishButton.setTitle("Publish", for: UIControlState.normal)
        } else {
            self.publishButton.isEnabled = false
            self.publishButton.setTitle(errorMessage, for: UIControlState.normal)
            self.publishButton.alpha = 0.3
            self.publishButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        }
    }
    
    func setPointData(pointData: PointData) {
        
        self.pointData = pointData
        

    }
    @IBAction func onTapPublish(_ sender: Any) {
        
        //保存
        let saveData = SystemSaveData.getInstance()
        
        for i in 0..<saveData.pointDataList.count {
            var pointData = saveData.pointDataList[i]
            if pointData.latitude == self.pointData?.latitude {
                if pointData.longitude == self.pointData?.longitude {
                    pointData.publishDate = CurrentTimeContainer.getInstance().currentDate!
                    saveData.pointDataList[i] = pointData
                    saveData.amount += self.pointData!.amount
                    saveData.save()
                    break
                }
            }
        }
        
        self.vcTabbar!.refreshWalletAmount();
        
        self.setUserInteraction(enable: false)
        
        //回転
        self.starImageView.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = NSNumber(value: (M_PI / 180 * 360))
        rotate.duration = 1.2
        rotate.repeatCount = 0
        self.starImageView?.layer.add(rotate, forKey: "star_rotate")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            
            self.publishButton.setTitle("Complete!", for: UIControlState.normal)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //閉じる
                self.vcMap?.closePointDetail()
                self.setUserInteraction(enable: true)
            }

        }
    }

    @IBAction func onTapCancel(_ sender: Any) {
        self.vcMap?.closePointDetail()
    }
    


}
