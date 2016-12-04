//
//  VCMaster.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCMaster: UIViewController {

    var nextViewController: VCMaster?
    
    enum SceneAnimationType {
        case StackFromRight
        case CloseForRight
        case None
    }
    
    func stackViewControler(vc: VCMaster, animationType: SceneAnimationType) {
        
        self.nextViewController = vc
        self.view.addSubview(vc.view)
        
        if animationType == SceneAnimationType.StackFromRight {
            vc.view.frame = CGRect(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        } else if animationType == SceneAnimationType.None {
            vc.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        
        if animationType == SceneAnimationType.StackFromRight {
            
            self.setUserInteraction(enable: false)
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: { [weak self] in
                            vc.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.size.width)!, height: (self?.view.frame.size.height)!)
                }, completion: { [weak self] _ in
                    self?.setUserInteraction(enable: true)
            })
        }
    }
    
    func closeViewController(animationType: SceneAnimationType) {
        
        if animationType == SceneAnimationType.CloseForRight {
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: { [weak self] in
                            self?.view.frame = CGRect(x: (self?.view.frame.size.width)!, y: 0, width: (self?.view.frame.size.width)!, height: (self?.view.frame.size.height)!)
                }, completion: { [weak self] _ in
                    self?.setUserInteraction(enable: true)
                    self?.view.removeFromSuperview()
            })
            
        } else if animationType == SceneAnimationType.None {
            self.view.removeFromSuperview()
        }
    }
    
    func setUserInteraction(enable: Bool) {
        
        let appDelegate = UIApplication.shared.delegate!
        let window = appDelegate.window!
        let root = window?.rootViewController
        root?.view.isUserInteractionEnabled = enable
    }
    
    func showAlert(title: String, message: String, buttonTitle: String, callback: @escaping () -> Void) {
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            callback()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


}
