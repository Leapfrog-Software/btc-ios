//
//  VCCapture.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit
import AVFoundation

class VCCapture: VCMaster, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    let session = AVCaptureSession()
    var captureLayer: AVCaptureVideoPreviewLayer?
    
    weak var vcSendMoney: VCSendMoney?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height / 2
        self.closeButton.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).cgColor
        self.closeButton.layer.borderWidth = 1.0

        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input = try? AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        self.captureLayer = AVCaptureVideoPreviewLayer(session: session)
        self.captureLayer?.frame = self.captureView.frame
        self.captureLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(self.captureLayer!)
        
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        
        guard let objects = metadataObjects as? [AVMetadataObject] else {
            return
        }
        for object in objects {
            if object.type == AVMetadataObjectTypeQRCode {
                if let readableCodeObject = object as? AVMetadataMachineReadableCodeObject {
                    let detectionString = readableCodeObject.stringValue
                    if detectionString != nil {
                        self.didDetectQr(qrCode: detectionString!)
                        self.session.stopRunning()
                    }
                }
            }
        }
    }
    
    private func didDetectQr(qrCode: String){
        
        self.resultView.isHidden = false
        self.resultLabel.text = qrCode
        self.view.bringSubview(toFront: self.resultView)
        self.captureLayer!.isHidden = true

        
        self.setUserInteraction(enable: false)
        
        self.vcSendMoney?.setReadQrCode(qrCode: qrCode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.closeViewController(animationType: SceneAnimationType.CloseForRight)
            self?.setUserInteraction(enable: true)
        }
    }
    
    
    @IBAction func onTapClose(_ sender: Any) {
        self.closeViewController(animationType: SceneAnimationType.CloseForRight)
    }

}
