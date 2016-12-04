//
//  LayoutUtility.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setTop(top: CGFloat) {
        
        var frame = self.frame
        frame.origin.y = top
        self.frame = frame
    }
    
    func setLeft(left: CGFloat) {
        
        var frame = self.frame
        frame.origin.x = left
        self.frame = frame
    }
    
    func setWidth(width: CGFloat) {
        
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
}

