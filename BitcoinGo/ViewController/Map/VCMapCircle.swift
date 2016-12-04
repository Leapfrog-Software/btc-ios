//
//  VCMapCircle.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/03.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit

class VCMapCircle: UIViewController {

    @IBOutlet private weak var circleView: UIView!
    private var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.timerProc(timer:)), userInfo: nil, repeats: true).fire()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.circleView.layer.borderWidth = 2.0
//        self.circleView.layer.borderColor = UIColor(red: 0.443, green: 0.749, blue: 0.572, alpha: 1.0).cgColor
        self.circleView.layer.borderColor = UIColor(red: 0.643, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
    }
    
    func resize(rect: CGRect) {


        
        self.view.frame = rect
        self.circleView.layer.cornerRadius = rect.size.width / 2        
    }
    
    func timerProc(timer: Timer) {
        
        if self.timerCount == -1 {
            return
        }
        if self.timerCount == 0 {
            self.circleView.alpha = 1.0
        }
        
        if self.timerCount <= 100 {
            let step = self.view.frame.size.width / 100
            let width = step * CGFloat(self.timerCount)
            self.circleView.frame = CGRect(x: self.view.frame.size.width / 2 - width / 2,
                                           y: self.view.frame.size.height / 2 - width / 2,
                                           width: width, height: width)
            self.circleView.layer.cornerRadius = width / 2
        }else if (self.timerCount >= 160){
            self.timerCount = -1
            UIView.animate(withDuration: 1.2,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: { [weak self] in
                            self?.circleView.alpha = 0.0
            }, completion: { [weak self] _ in
                
                self?.timerCount = 0
            })
            return
        }
        
        self.timerCount += 1

    }
}
