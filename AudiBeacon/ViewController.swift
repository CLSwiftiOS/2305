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

    let shapeLayer1 = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let shapeLayer3 = CAShapeLayer()
    let shapeLayer4 = CAShapeLayer()
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "WEB-EDV")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunc)))
        
        let center1 = view.center
        let circularPath1 = UIBezierPath(arcCenter: center1, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer1.path = circularPath1.cgPath
        shapeLayer1.strokeColor = UIColor.red.cgColor
        shapeLayer1.lineWidth = 10
        shapeLayer1.strokeEnd = 0
        view.layer.addSublayer(shapeLayer1)
        let circularPath2 = UIBezierPath(arcCenter: center1, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer2.path = circularPath2.cgPath
        shapeLayer2.strokeColor = UIColor.green.cgColor
        shapeLayer2.lineWidth = 10
        shapeLayer2.strokeEnd = 0
        view.layer.addSublayer(shapeLayer2)
        let circularPath3 = UIBezierPath(arcCenter: center1, radius: 100, startAngle: -CGFloat.pi * 1.5, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer3.path = circularPath3.cgPath
        shapeLayer3.strokeColor = UIColor.yellow.cgColor
        shapeLayer3.lineWidth = 10
        shapeLayer3.strokeEnd = 0
        view.layer.addSublayer(shapeLayer3)
        let circularPath4 = UIBezierPath(arcCenter: center1, radius: 100, startAngle: -CGFloat.pi, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer4.path = circularPath4.cgPath
        shapeLayer4.strokeColor = UIColor.blue.cgColor
        shapeLayer4.lineWidth = 10
        shapeLayer4.strokeEnd = 0
        view.layer.addSublayer(shapeLayer4)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knowBeacons = beacons.filter{ $0.proximity == CLProximity.immediate}
        if knowBeacons.count > 0 {
            let iBeacon = knowBeacons[0] as CLBeacon
            let whichBeacon = iBeacon.minor.intValue
            switch whichBeacon {
            case 24984: print("iBeacon \(whichBeacon)")
                tapFunc()
            default: print("kein Beacon gefunden")
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func tapFunc() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer1.add(basicAnimation, forKey: "urSoBasic1")
        shapeLayer2.add(basicAnimation, forKey: "urSoBasic2")
        shapeLayer3.add(basicAnimation, forKey: "urSoBasic3")
        shapeLayer4.add(basicAnimation, forKey: "urSoBasic4")
    }


}

