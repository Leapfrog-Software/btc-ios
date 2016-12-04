//
//  PointAnnotationView.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotationView: MKAnnotationView {

    var pinImageView: UIImageView?
    var starImageView: UIImageView?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.image = nil
        self.backgroundColor = UIColor.clear
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
        
        if self.pinImageView == nil {
            self.pinImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: 30, height: 30))
            self.pinImageView!.image = UIImage(named: "point_pin")
            self.addSubview(self.pinImageView!)
        }
        
        if self.starImageView == nil {
            self.starImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
            self.starImageView!.image = UIImage(named: "point_star")
            self.addSubview(self.starImageView!)
            self.starImageView?.isHidden = true
            
            
        }
    }
    
    private func startRotate(){
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = NSNumber(value: (M_PI / 180 * 360))
        rotate.duration = 2.0
        rotate.repeatCount = 99
        self.starImageView?.layer.add(rotate, forKey: "star_rotate")
    }
    
    func showStar(){
        self.startRotate()
        self.starImageView?.isHidden = false
    }
    
    func hideStar(){
        self.starImageView?.isHidden = true
    }
    
}
