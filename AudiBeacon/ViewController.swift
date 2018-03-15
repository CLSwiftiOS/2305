//
//  ViewController.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 12.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lblAusgabe: UILabel!
    
    var oldBuffer1 = CGFloat(0)
    var oldBuffer2 = CGFloat(0)
    var oldBuffer3 = CGFloat(0)
    var oldBuffer4 = CGFloat(0)
    
    let basicAnimation1 = CABasicAnimation(keyPath: "strokeEnd")
    let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
    let basicAnimation3 = CABasicAnimation(keyPath: "strokeEnd")
    let basicAnimation4 = CABasicAnimation(keyPath: "strokeEnd")
    
    let shapeLayer2 = CAShapeLayer()
    let shapeLayer3 = CAShapeLayer()
    let shapeLayer1 = CAShapeLayer()
    let shapeLayer4 = CAShapeLayer()
    
    let animationDuration: CFTimeInterval = 0.5
    var timer = Timer()
    var beacon: CLBeacon?
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "WEB-EDV")
    
    override func viewDidLoad() {

        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
        super.viewDidLoad()
        basicAnimation1.toValue = 0
        basicAnimation3.toValue = 0
        basicAnimation2.toValue = 0
        basicAnimation4.toValue = 0
        locationManager.delegate = self
        view.backgroundColor = UIColor.white
        view1.backgroundColor = UIColor.clear
        view2.backgroundColor = UIColor.clear
        view3.backgroundColor = UIColor.clear
        view4.backgroundColor = UIColor.clear
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        let radius: CGFloat = 60
        let shaperLineWidth: CGFloat = 5
        let circularPath3 = UIBezierPath(arcCenter: view3.center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath2 = UIBezierPath(arcCenter: view2.center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath1 = UIBezierPath(arcCenter: view1.center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath4 = UIBezierPath(arcCenter: view4.center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer1 = CAShapeLayer()
        trackLayer1.path = circularPath1.cgPath
        trackLayer1.fillColor = UIColor.clear.cgColor
        trackLayer1.strokeColor = UIColor.lightGray.cgColor
        trackLayer1.lineWidth = shaperLineWidth
        trackLayer1.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer1)
        
        shapeLayer1.path = circularPath1.cgPath
        shapeLayer1.strokeColor = UIColor.red.cgColor
        shapeLayer1.lineWidth = shaperLineWidth
        shapeLayer1.lineCap = kCALineCapRound
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeEnd = 0
        view.layer.addSublayer(shapeLayer1)
        
        let trackLayer2 = CAShapeLayer()
        trackLayer2.path = circularPath2.cgPath
        trackLayer2.fillColor = UIColor.clear.cgColor
        trackLayer2.strokeColor = UIColor.lightGray.cgColor
        trackLayer2.lineWidth = shaperLineWidth
        trackLayer2.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer2)
        
        shapeLayer2.path = circularPath2.cgPath
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineCap = kCALineCapRound
        shapeLayer2.lineWidth = shaperLineWidth
        shapeLayer2.strokeColor = UIColor.red.cgColor
        shapeLayer2.strokeEnd = 0
        view.layer.addSublayer(shapeLayer2)
        
        
        let trackLayer3 = CAShapeLayer()
        trackLayer3.path = circularPath3.cgPath
        trackLayer3.strokeColor = UIColor.lightGray.cgColor
        trackLayer3.fillColor = UIColor.clear.cgColor
        trackLayer3.lineWidth = shaperLineWidth
        trackLayer3.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer3)
        
        shapeLayer3.path = circularPath3.cgPath
        shapeLayer3.strokeColor = UIColor.red.cgColor
        shapeLayer3.lineWidth = shaperLineWidth
        shapeLayer3.lineCap = kCALineCapRound
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeEnd = 0
        view.layer.addSublayer(shapeLayer3)
        
        let trackLayer4 = CAShapeLayer()
        trackLayer4.path = circularPath4.cgPath
        trackLayer4.strokeColor = UIColor.lightGray.cgColor
        trackLayer4.fillColor = UIColor.clear.cgColor
        trackLayer4.lineWidth = shaperLineWidth
        trackLayer4.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer4)
        
        shapeLayer4.path = circularPath4.cgPath
        shapeLayer4.strokeColor = UIColor.red.cgColor
        shapeLayer4.lineWidth = shaperLineWidth
        shapeLayer4.lineCap = kCALineCapRound
        shapeLayer4.fillColor = UIColor.clear.cgColor
        shapeLayer4.strokeEnd = 0
        view.layer.addSublayer(shapeLayer4)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.animateCircle)))
    }
    
    @objc func timerFunc() {
        animateCircle()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for i in 0...5 {
            let testBeacon = beacons[i].minor.intValue
            switch testBeacon {
            case 42263:
                let tempBeacon = beacons[i].accuracy
                basicAnimation2.toValue = 1 - tempBeacon
                print("case 1")
            case 58690:
                let tempBeacon = beacons[i].accuracy
                basicAnimation4.toValue = 1 - tempBeacon
                print("case 2")
            case 24984:
                let tempBeacon = beacons[i].accuracy
                basicAnimation1.toValue = 1 - tempBeacon
                print("case 3")
            case 16713:
                let tempBeacon = beacons[i].accuracy
                basicAnimation3.toValue = 1 - tempBeacon
                print("case 4")
            default:
                print("kein Case gefunden")
            }
        }
        
        let knowBeacons = beacons.filter{ $0.proximity == CLProximity.immediate || $0.proximity == CLProximity.near || $0.proximity == CLProximity.far}
        if knowBeacons.count > 0 {
            
        
            //let iBeacon = knowBeacons.first!
            //let whichBeacon = iBeacon.minor.intValue
           
            /*switch whichBeacon {
            case 42263:
                lblAusgabe.text = String(accuracy3)
            case 22438:
                lblAusgabe.text = String(accuracy3)
            case 24984:
                lblAusgabe.text = String(accuracy3)
            case 16713:
                lblAusgabe.text = String(accuracy3)
            default:
                print("XAyT wurde nicht gefunden")
                print(accuracy3)
                lblAusgabe.text = String(accuracy3)
            }*/
        }
    }
    
    @objc private func animateCircle() {
        basicAnimation1.duration = animationDuration
        basicAnimation2.duration = animationDuration
        basicAnimation3.duration = animationDuration
        basicAnimation4.duration = animationDuration
        basicAnimation1.fromValue = oldBuffer1
        basicAnimation2.fromValue = oldBuffer2
        basicAnimation3.fromValue = oldBuffer3
        basicAnimation4.fromValue = oldBuffer4
        oldBuffer1 = basicAnimation1.toValue as! CGFloat
        oldBuffer2 = basicAnimation2.toValue as! CGFloat
        oldBuffer3 = basicAnimation3.toValue as! CGFloat
        oldBuffer4 = basicAnimation4.toValue as! CGFloat
        basicAnimation1.fillMode = kCAFillModeForwards
        basicAnimation2.fillMode = kCAFillModeForwards
        basicAnimation3.fillMode = kCAFillModeForwards
        basicAnimation4.fillMode = kCAFillModeForwards
        basicAnimation1.isRemovedOnCompletion = false
        basicAnimation2.isRemovedOnCompletion = false
        basicAnimation3.isRemovedOnCompletion = false
        basicAnimation4.isRemovedOnCompletion = false
        shapeLayer2.add(basicAnimation2, forKey: "urSoBasic2")
        shapeLayer3.add(basicAnimation3, forKey: "urSoBasic3")
        shapeLayer1.add(basicAnimation1, forKey: "urSoBasic1")
        shapeLayer4.add(basicAnimation4, forKey: "urSoBasic4")
        
        
    }
}

