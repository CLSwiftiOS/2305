//
//  ViewController.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 12.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lblAusgabe: UILabel!
    
    var pulsatingLayer: CAShapeLayer!
    
    var oldBuffer3 = CGFloat(0)
    let basicAnimation3 = CABasicAnimation(keyPath: "strokeEnd")
    let shapeLayer3 = CAShapeLayer()
    let animationDuration: CFTimeInterval = 1.5
    var timer = Timer()
    var beacon: CLBeacon?
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "WEB-EDV")
    let animation = CABasicAnimation(keyPath: "transform.scale")
    override func viewDidLoad() {
        animation.duration = 1
        
        lblAusgabe.textColor = .white
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
        super.viewDidLoad()
        basicAnimation3.toValue = 0
        locationManager.delegate = self
        view.backgroundColor = UIColor.backgroundColor
        view1.backgroundColor = UIColor.clear
        view2.backgroundColor = UIColor.clear
        view3.backgroundColor = UIColor.clear
        view4.backgroundColor = UIColor.clear
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        let radius: CGFloat = 80
        let shaperLineWidth: CGFloat = 20
        let circularPath3 = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath3.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view3.center
        view.layer.addSublayer(pulsatingLayer)
        
        
        let trackLayer3 = CAShapeLayer()
        trackLayer3.path = circularPath3.cgPath
        trackLayer3.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer3.fillColor = UIColor.backgroundColor.cgColor
        trackLayer3.lineWidth = shaperLineWidth
        trackLayer3.lineCap = kCALineCapRound
        trackLayer3.position = view3.center
        view.layer.addSublayer(trackLayer3)
        
        shapeLayer3.position = view3.center
        shapeLayer3.path = circularPath3.cgPath
        shapeLayer3.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer3.lineWidth = shaperLineWidth
        shapeLayer3.lineCap = kCALineCapRound
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeEnd = 0
        view.layer.addSublayer(shapeLayer3)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.animateCircle)))
    }
    
    private func animatePulsatingLayer() {
        animation.toValue = 1.4
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    @objc func timerFunc() {
        animateCircle()
        animatePulsatingLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knowBeacons = beacons.filter{ $0.proximity == CLProximity.immediate || $0.proximity == CLProximity.near || $0.proximity == CLProximity.far}
        if knowBeacons.count > 0 {
            //            let date = Date()
            //            print(date)
            
            let iBeacon = knowBeacons.first!
            let whichBeacon = iBeacon.minor.intValue
            let tempBeacon = iBeacon.accuracy
            lblAusgabe.text = String(tempBeacon)
            if tempBeacon < 0.5 {
                animation.duration = 1
                basicAnimation3.toValue = 1
            } else if tempBeacon > 0.5 && tempBeacon < 0.8 {
                basicAnimation3.toValue = 0.9
            } else if tempBeacon > 0.8 && tempBeacon < 1.1 {
                basicAnimation3.toValue = 0.8
            } else if tempBeacon > 1.1 && tempBeacon < 1.4 {
                basicAnimation3.toValue = 0.7
            } else if tempBeacon > 1.4 && tempBeacon < 1.7 {
                basicAnimation3.toValue = 0.6
            } else if tempBeacon > 1.7 && tempBeacon < 2.0 {
                basicAnimation3.toValue = 0.5
            } else if tempBeacon > 2.0 && tempBeacon < 2.3 {
                basicAnimation3.toValue = 0.4
            } else if tempBeacon > 2.3 && tempBeacon < 2.9 {
                basicAnimation3.toValue = 0.3
            } else { //hier könnten wir noch genauere Filter einsetzen.
                basicAnimation3.toValue = 0.0
            }
            
            
            
            //            switch whichBeacon {
            //            case 24984:
            //
            ////                var tempBeacon = CLLocationAccuracy()
            //                print(tempBeacon)
            ////                tempRange = 1 - tempBeacon
            ////                print(tempRange)
            ////                if tempBeacon < 0.2 {
            ////                    basicAnimation3.toValue = 1
            ////                } else if tempBeacon < 0.4 && tempBeacon > 0.2 {
            ////                    basicAnimation3.toValue = 0.9
            ////                } else if tempBeacon > 0.4 && tempBeacon < 0.6 {
            ////                    basicAnimation3.toValue = 0.8
            ////                } else if tempBeacon > 0.6 && tempBeacon < 0.8 {
            ////                    basicAnimation3.toValue = 0.7
            ////                } else if tempBeacon > 0.8 && tempBeacon < 1.0 {
            ////                    basicAnimation3.toValue = 0.6
            ////                } else if tempBeacon > 1.0 && tempBeacon < 1.2 {
            ////                    basicAnimation3.toValue = 0.5
            ////                } else if tempBeacon > 1.2 && tempBeacon < 1.4 {
            ////                    basicAnimation3.toValue = 0.4
            ////                } else if tempBeacon > 1.4 && tempBeacon < 2.0 {
            ////                    basicAnimation3.toValue = 0.3
            ////                } else { //hier könnten wir noch genauere Filter einsetzen. Gute Werte zu finden ist jedoch schwer
            ////                    basicAnimation3.toValue = 0.0
            ////            }
            //            default:
            //            print("XAyT wurde nicht gefunden")
            //        }
        }
    }
    
    @objc private func animateCircle() {
        
        basicAnimation3.duration = animationDuration
        basicAnimation3.fromValue = oldBuffer3
        oldBuffer3 = basicAnimation3.toValue as! CGFloat
        basicAnimation3.fillMode = kCAFillModeForwards
        basicAnimation3.isRemovedOnCompletion = false
        shapeLayer3.add(basicAnimation3, forKey: "urSoBasic3")
        animatePulsatingLayer()
        
        
        
    }
}

