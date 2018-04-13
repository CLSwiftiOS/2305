//
//  Notizen.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 14.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit

class Notizen: UIViewController {
    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOff {
//            let alert = UIAlertController(title: "Bluetooth Alarm", message: "Bitte Bluetooth einschalten", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        } else {
//            print("BT is On")
//        }
//    }
    
    
    /*
     let screenSize = UIScreen.main.bounds
     let screenWidth = screenSize.width
     let screenHeight = screenSize.height
     */
    /*
    moveAnimation.duration = 2
    vPoition = pointShapeLayer1.position
    pointShapeLayer1.position = view11.center
    moveAnimation.toValue = view11.center
    pointShapeLayer1.add(moveAnimation, forKey: "move")
    vPoition = pointShapeLayer2.position
    pointShapeLayer2.position = view12.center
    moveAnimation.toValue = view12.center
    pointShapeLayer2.add(moveAnimation, forKey: "move")
    vPoition = pointShapeLayer3.position
    pointShapeLayer3.position = view13.center
    moveAnimation.toValue = view13.center
    pointShapeLayer3.add(moveAnimation, forKey: "move")
    vPoition = pointShapeLayer4.position
    pointShapeLayer4.position = view14.center
    moveAnimation.toValue = view14.center
    pointShapeLayer4.add(moveAnimation, forKey: "move")
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.animateCircle)))
    //    let imageName1 = "point.png"
    //    let imageName2 = "point.png"
    //    let imageName3 = "point.png"
    //    let imageName4 = "point.png"
    //    let image1 = UIImage(named: imageName1)
    //    let image2 = UIImage(named: imageName2)
    //    let image3 = UIImage(named: imageName3)
    //    let image4 = UIImage(named: imageName4)
    //    let imageView1 = UIImageView(image: image1!)
    //    let imageView2 = UIImageView(image: image2!)
    //    let imageView3 = UIImageView(image: image3!)
    //    let imageView4 = UIImageView(image: image4!)
    
    //TimerPoints = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(ViewController.movePoints), userInfo: nil, repeats: true)
    //            imageView1.frame = CGRect(x: view3.center.x - widthPoint/2, y: view3.center.y - heightPoint/2, width: widthPoint, height: heightPoint)
    //            view.addSubview(imageView1)
    //            UIView.animate(withDuration: 3, animations: {imageView1.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 30, width: 30, height: 30)})
    
    
    
    /*
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
     */
    /*
     
     switch whichBeacon {
     case 24984:
     
     var tempBeacon = CLLocationAccuracy()
     print(tempBeacon)
     tempRange = 1 - tempBeacon
     print(tempRange)
     if tempBeacon < 0.2 {
     basicAnimation3.toValue = 1
     } else if tempBeacon < 0.4 && tempBeacon > 0.2 {
     basicAnimation3.toValue = 0.9
     } else if tempBeacon > 0.4 && tempBeacon < 0.6 {
     basicAnimation3.toValue = 0.8
     } else if tempBeacon > 0.6 && tempBeacon < 0.8 {
     basicAnimation3.toValue = 0.7
     } else if tempBeacon > 0.8 && tempBeacon < 1.0 {
     basicAnimation3.toValue = 0.6
     } else if tempBeacon > 1.0 && tempBeacon < 1.2 {
     basicAnimation3.toValue = 0.5
     } else if tempBeacon > 1.2 && tempBeacon < 1.4 {
     basicAnimation3.toValue = 0.4
     } else if tempBeacon > 1.4 && tempBeacon < 2.0 {
     basicAnimation3.toValue = 0.3
     } else { //hier könnten wir noch genauere Filter einsetzen. Gute Werte zu finden ist jedoch schwer
     basicAnimation3.toValue = 0.0
     }
     default:
     print("XAyT wurde nicht gefunden")
     }
     */
    
}
