//
//  VCMap.swift
//  BitcoinGo
//
//  Created by Leapfrog-Software on 2016/12/01.
//  Copyright © 2016年 Leapfrog-Software. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VCMap: VCMaster, MKMapViewDelegate {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var messageBaseView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var zoomInButton: UIButton!
    @IBOutlet private weak var zoomOutButton: UIButton!
    

    private var currentZoomLebel = 0.01
    
    weak var vcTabbar: VCTabbar?
    var annotationList: Array<MKPointAnnotation> = Array<MKPointAnnotation>()
    var vcPoint: VCPoint?
    var vcMapCircle: VCMapCircle?
    var timerCount = 0
    var didInitAnnotation = false
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageBaseView.layer.cornerRadius = 8.0
        self.messageBaseView.clipsToBounds = true
        self.messageBaseView.alpha = 0.0
        
        
        self.zoomInButton.layer.masksToBounds = false
        self.zoomInButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.zoomInButton.layer.shadowRadius = 3
        self.zoomInButton.layer.shadowOpacity = 0.4
        self.zoomOutButton.layer.masksToBounds = false
        self.zoomOutButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.zoomOutButton.layer.shadowRadius = 3
        self.zoomOutButton.layer.shadowOpacity = 0.4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //タイマー
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerProc(timer:)), userInfo: nil, repeats: true)
        timer.fire()
        
        //地図
        initMap()
    }
    
    private func initMap() {
        
        self.mapView.delegate = self
        self.mapView.isZoomEnabled = false
        self.mapView.isPitchEnabled = false
        self.mapView.isScrollEnabled = false
        self.mapView.showsUserLocation = true
        self.mapView.isRotateEnabled = false
        self.mapView.userTrackingMode = .followWithHeading
        
        self.vcMapCircle = VCMapCircle()
        self.view.addSubview(self.vcMapCircle!.view)
        
        if LocationManager.getInstance().currentLocation != nil {
            let span = MKCoordinateSpan(latitudeDelta: MAP_ZOOM_LEVEL3, longitudeDelta: MAP_ZOOM_LEVEL3)
            let region = MKCoordinateRegion(center: LocationManager.getInstance().currentLocation!.coordinate,
                               span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool){
    
        NSLog("")
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        guard let currentLocation = LocationManager.getInstance().currentLocation else {
            return
        }
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x: 1, y: 0)
        let coord1: CLLocationCoordinate2D = mapView.convert(p1, toCoordinateFrom: mapView)
        let coord2: CLLocationCoordinate2D = mapView.convert(p2, toCoordinateFrom: mapView)
        let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        let meterPerPoint = loc1.distance(from: loc2)
        let publishableDistance = PUBLISHABLE_DISTANCE * MKMapPointsPerMeterAtLatitude(currentLocation.coordinate.latitude)
        let publishableWidth = publishableDistance / meterPerPoint
        let rect = CGRect(x: self.mapView.frame.size.width / 2 - CGFloat(publishableWidth / 2),
                          y: self.mapView.frame.size.height / 2 - CGFloat(publishableWidth / 2),
                          width: CGFloat(publishableWidth),
                          height: CGFloat(publishableWidth))
        self.vcMapCircle!.resize(rect: rect)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation === mapView.userLocation {
            let identifier = "position_annotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                return annotationView
            } else {
                return PositionAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        } else {
            let identifier = "point_annotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                return annotationView
            } else {
                return PointAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let latitude: CLLocationDegrees = (view.annotation?.coordinate.latitude)!
        let longitude: CLLocationDegrees = (view.annotation?.coordinate.longitude)!
        var index = -1
        for (i, annotation) in self.annotationList.enumerated() {
            if annotation.coordinate.latitude == latitude {
                if annotation.coordinate.longitude == longitude {
                    index = i
                    break
                }
            }
        }
        if index != -1 {
            let pointData: PointData = SystemSaveData.getInstance().pointDataList[index]
            self.showPointDetail(pointData: pointData)
        }
        
        if view.isKind(of: PointAnnotationView.self){
            (view as! PointAnnotationView).showStar()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if view.isKind(of: PointAnnotationView.self){
            (view as! PointAnnotationView).hideStar()
        }
    }
    
    private func showPointDetail(pointData: PointData) {
        
        if self.vcPoint != nil {
            self.vcPoint?.view.removeFromSuperview()
            self.vcPoint = nil
        }
        self.vcPoint = VCPoint()
        self.vcPoint!.vcMap = self
        self.vcPoint!.vcTabbar = self.vcTabbar
        self.vcPoint?.setPointData(pointData: pointData)
        self.view.addSubview((self.vcPoint?.view)!)
        self.vcTabbar!.view.addSubview(self.vcPoint!.view)
        self.vcPoint?.view.frame = CGRect(x: 0, y: self.vcTabbar!.view.frame.size.height,
                                          width: self.vcTabbar!.view.frame.size.width,
                                          height: self.vcPoint!.view.frame.size.height)
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.vcPoint?.view.setTop(top: (self?.vcTabbar!.view.frame.size.height)! - (self?.vcPoint!.view.frame.size.height)!)
            }, completion: { _ in
                
        })
    }
    
    func closePointDetail(){
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.vcPoint?.view.setTop(top: (self?.vcTabbar!.view.frame.size.height)!)
            }, completion: { [weak self] _ in
                self?.vcPoint?.view.removeFromSuperview()
                self?.vcPoint = nil
        })
        
        for annotation in self.mapView.annotations {
            self.mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    func timerProc(timer: Timer) {
        
        //位置情報
        if self.timerCount % 5 == 0 {
            let location: CLLocation? = LocationManager.getInstance().currentLocation
            if location != nil {
                let generateResult = PointGenerator.getInstance().generate(location: location!)
                if generateResult {
                    setAnnotation()
                }else if self.didInitAnnotation == false {
                    setAnnotation()
                    self.didInitAnnotation = true
                }
                
                //位置が変わった
                if ((self.currentLocation?.coordinate.latitude != location!.coordinate.latitude)
                || (self.currentLocation?.coordinate.longitude != location!.coordinate.longitude)) {
                        self.zoomMap()
                        self.currentLocation = location!
                }
                
            } else {
                showMessage(message: "Cannot obtain player's location.")
            }
        }
        //現在時刻更新
        if (self.timerCount % 30 == 0) {
            CurrentTimeContainer.getInstance().refresh(vcTabbar: self.vcTabbar!)
        }
        
        self.timerCount += 1
        if self.timerCount >= 150 {
            self.timerCount = 0
        }
    }
    
    
    private func setAnnotation() {
        
        //取り除く
        for value in self.annotationList {
            self.mapView.removeAnnotation(value)
        }
        self.annotationList.removeAll()
        
        //追加
        let pointList: Array<PointData> = SystemSaveData.getInstance().pointDataList
        for value: PointData in pointList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(Double(value.latitude)!, Double(value.longitude)!)
            self.mapView.addAnnotation(annotation)
            self.annotationList.append(annotation)
        }
    }
    
    
    private func showMessage(message: String){
        
        self.messageLabel.text = message
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.messageBaseView.alpha = 1.0
            }, completion: nil)
    }
    
    private func hideMessage() {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.messageBaseView.alpha = 0.0
            }, completion: nil)
    }
    
    @IBAction func onTapZoomIn(_ sender: Any) {
        
        if self.currentZoomLebel == MAP_ZOOM_LEVEL1 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL2
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL2 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL3
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL3 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL4
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL4 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL5
        }
        self.zoomMap()
    }
    
    @IBAction func onTapZoomOut(_ sender: Any) {

        if self.currentZoomLebel == MAP_ZOOM_LEVEL5 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL4
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL4 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL3
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL3 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL2
        }else if self.currentZoomLebel == MAP_ZOOM_LEVEL2 {
            self.currentZoomLebel = MAP_ZOOM_LEVEL1
        }
        self.zoomMap()
    }
    
    private func zoomMap() {
        
        if LocationManager.getInstance().currentLocation != nil {
            let span = MKCoordinateSpan(latitudeDelta: self.currentZoomLebel, longitudeDelta: self.currentZoomLebel)
            let region = MKCoordinateRegion(center: LocationManager.getInstance().currentLocation!.coordinate,
                                            span: span)
            mapView.setRegion(region, animated: true)
            
            
        }
    }
}
