//
//  VCSplash.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCSplash: VCMaster {

    private var vcTabbar: VCTabbar? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //位置情報取得
        LocationManager.getInstance().initialize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.versionCheck()
        }
    }
    
    private func versionCheck() {
        
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        HttpClient.versionCheck(version: version, completion: { [weak self] (result, check) -> Void in
            if result {
                if check == HttpClient.VersionCheckResult.Ok {
                    self?.stackTabbar()
                } else if check == HttpClient.VersionCheckResult.VersionError {
                    self?.showError(message: "Update to the latest version.")
                } else if check == HttpClient.VersionCheckResult.OutOfService {
                    self?.showError(message: "System stopped currently.")
                } else if check == HttpClient.VersionCheckResult.SystemError {
                    self?.showError(message: "System error!")
                }
            } else{
                self?.showError(message: "Communication error.")
            }
            
        })
    }
    
    private func stackTabbar() {
        
        if LocationManager.getInstance().currentLocation == nil {
            self.showError(message: "Cannot obtain location.")
            return
        }
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0.0
        blackView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(blackView)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        blackView.alpha = 1.0
        }, completion: { [weak self] finished in
            
            self?.stackViewControler(vc: VCTabbar(), animationType: .None)
            self?.view.bringSubview(toFront: blackView)
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: {
                            blackView.alpha = 0.0
            }, completion: { finished in
                blackView.removeFromSuperview()
            })
        })
    }
    
    private func showError(message: String) {
        
        self.showAlert(title: "Error", message: message, buttonTitle: "Retry", callback: {
            self.versionCheck()
        })
    }


}
