//
//  PositionAnnotationView.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit
import MapKit

class PositionAnnotationView: MKAnnotationView {
    
    var imageView: UIImageView?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.image = nil
        self.backgroundColor = UIColor.clear
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.centerOffset = CGPoint(x: 0, y: -25)
        
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.imageView!.image = UIImage(named: "position_pin")
            self.addSubview(self.imageView!)
        }
    }
    
}
