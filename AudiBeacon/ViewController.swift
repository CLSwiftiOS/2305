//
//  ViewController.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 12.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view14: UIView!
    @IBOutlet weak var view31: UIView!
    @IBOutlet weak var view32: UIView!
    @IBOutlet weak var view33: UIView!
    @IBOutlet weak var view34: UIView!
    @IBOutlet weak var lblAudi: UILabel!
    @IBOutlet weak var lblAudi2: UILabel!
    @IBOutlet weak var lblAusgabe: UILabel!
    
    @IBOutlet weak var btnFire: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    
    
    var repeatBool : Bool = false
    var blueManager: CBCentralManager!
    var tempBeaconMinor = 0
    var gefundeneBeacon = [58690, 16713, 42263, 24984]
    var vPointZaehler = 0
    let shaperLineWidth: CGFloat = 20
    let finishPath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    let circularPath3 = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    let circularPuls = UIBezierPath(arcCenter: .zero, radius: 90, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    var pointPath = UIBezierPath(arcCenter: .zero, radius: 30, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    var isNear = false
    var finished = false
    let trackPoint1 = CAShapeLayer()
    let trackPoint2 = CAShapeLayer()
    let trackPoint3 = CAShapeLayer()
    let trackPoint4 = CAShapeLayer()
    var pulsatingLayerBeacon = CAShapeLayer()
    let shapeLayerBeaconRange = CAShapeLayer()
    let finishLayer = CAShapeLayer()
    let trackLayerBeacon = CAShapeLayer()
    let pointShapeLayer1 = CAShapeLayer()
    let pointShapeLayer2 = CAShapeLayer()
    let pointShapeLayer3 = CAShapeLayer()
    let pointShapeLayer4 = CAShapeLayer()
    let btnQuestionView = UIButton(type: .system)
    var oldBuffer3 = CGFloat(0)
    let rangeToBeaconAnimation = CABasicAnimation(keyPath: "strokeEnd")
    let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
    let pointIsRealAnimation = CABasicAnimation(keyPath: "strokeEnd")
    let pulseFinish = CABasicAnimation(keyPath: "transform.scale")
    var timer = Timer()
    var finishTimer = Timer()
    var timerPulse = Timer()
    var beacon: CLBeacon?
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "WEB-EDV")
    var timerFireWork = Timer()
    var timerCountFireWork = 0
    var isFireWork: Bool = false
    var repeatTimer = Timer()
    var tapCount = false
    
    @IBAction func btnFire(_ sender: Any) {
        timerCountFireWork = 0
        timerFireWork = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ViewController.addFire), userInfo: nil, repeats: true)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            //            let alert = UIAlertController(title: "Bluetooth Alarm", message: "Bitte Bluetooth einschalten", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            //            self.present(alert, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { //Bildschirm dreht sich nicht mit
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool { //Bildschirm dreht sich nicht mit
        return false
    }
   
    override func viewDidLoad() {
        btnFire.isUserInteractionEnabled = false
        //isNear = true wird nur für den Simulator benötigt, da kein Bluetooth
        btnRepeat.isHidden = true
        btnRepeat.isUserInteractionEnabled = false
        print(gefundeneBeacon)
        super.viewDidLoad()
        blueManager = CBCentralManager(delegate: self, queue: nil)
        lblAudi.isHidden = true
        lblAudi2.isHidden = true
        setBackGroundClear()
        setTrackPoints()
        setActionButton()
        loadAnimationPoints()
        lblAusgabe.textColor = .white
        if finished == true {
        } else {
            timerPulse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.animatePulsatingLayer), userInfo: nil, repeats: true)
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
        rangeToBeaconAnimation.toValue = 0
        locationManager.delegate = self
        view.backgroundColor = UIColor.backgroundColor
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go" {
            if let QuestionViewX  = segue.destination as? QuestionView {
                //tempBeaconMinor = 16713  wird nur beim Simulator benötigt da Minor für Frage übergeben werden muss
                QuestionViewX.vWelcheFrage = vPointZaehler
                QuestionViewX.gefundeneBeacon = gefundeneBeacon
                QuestionViewX.vMinorTemp = tempBeaconMinor
                print(btnQuestionView.tag)
            }
        }
    }
    
    @objc private func animateCircle() {
        rangeToBeaconAnimation.duration = 1
        rangeToBeaconAnimation.fromValue = oldBuffer3
        oldBuffer3 = rangeToBeaconAnimation.toValue as! CGFloat
        rangeToBeaconAnimation.fillMode = kCAFillModeForwards
        rangeToBeaconAnimation.isRemovedOnCompletion = false
        shapeLayerBeaconRange.add(rangeToBeaconAnimation, forKey: "urSoBasicBeacon")
    }
    
    @objc func animatePulsatingLayer() {
        pulseAnimation.duration = 1
        pulseAnimation.toValue = 1.6
        pulseAnimation.repeatCount = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pulseAnimation.autoreverses = false
        pulsatingLayerBeacon.add(pulseAnimation, forKey: "pulsing")
        
    }
    
    private func animateFinishLayer() {
        pulseFinish.duration = 1
        pulseFinish.toValue = 1.4
        pulseFinish.repeatCount = 1
        pulseFinish.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pulseFinish.autoreverses = true
        finishLayer.add(pulseFinish, forKey: "pulsing")
    }
    
    @objc func finishAnimationTimer() {
        
        var vPoition: CGPoint!
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.duration = 5
        moveAnimation.fromValue = vPoition
        
        if finished == true  {
            moveAnimation.duration = 0.3
            vPoition = pointShapeLayer1.position
            moveAnimation.fromValue = vPoition
            pointShapeLayer1.position = CGPoint(x: view.center.x - 64, y: view3.center.y)
            moveAnimation.toValue = CGPoint(x: view.center.x - 64, y: view3.center.y)
            pointShapeLayer1.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer2.position
            pointShapeLayer2.position = CGPoint(x: view.center.x - 22, y: view3.center.y)
            moveAnimation.toValue = CGPoint(x: view.center.x - 22, y: view3.center.y)
            pointShapeLayer2.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer3.position
            pointShapeLayer3.position = CGPoint(x: view.center.x + 22, y: view3.center.y)
            moveAnimation.toValue = CGPoint(x: view.center.x + 22, y: view3.center.y)
            pointShapeLayer3.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer4.position
            pointShapeLayer4.position = CGPoint(x: view.center.x + 64, y: view3.center.y)
            moveAnimation.toValue = CGPoint(x: view.center.x + 64, y: view3.center.y)
            pointShapeLayer4.add(moveAnimation, forKey: "move")
            showText()
        } else {
            moveAnimation.duration = 1.0
            vPoition = pointShapeLayer1.position
            moveAnimation.fromValue = vPoition
            pointShapeLayer1.position = view11.center
            moveAnimation.toValue = view11.center
            pointShapeLayer1.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer2.position
            moveAnimation.fromValue = vPoition
            pointShapeLayer2.position = view12.center
            moveAnimation.toValue = view12.center
            pointShapeLayer2.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer3.position
            moveAnimation.fromValue = vPoition
            pointShapeLayer3.position = view13.center
            moveAnimation.toValue = view13.center
            pointShapeLayer3.add(moveAnimation, forKey: "move")
            vPoition = pointShapeLayer4.position
            moveAnimation.fromValue = vPoition
            pointShapeLayer4.position = view14.center
            moveAnimation.toValue = view14.center
            pointShapeLayer4.add(moveAnimation, forKey: "move")
        }
    }
    
    @objc func showText() {
        if repeatBool == false {
        lblAudi.alpha = 0
        lblAudi2.alpha = 0
        lblAudi.isHidden = false
        lblAudi2.isHidden = false
        lblAudi.text = "Audi"
        lblAudi2.text = "Vorsprung durch Technik"
        lblAudi.font = UIFont(name: "AudiType-ExtendedBold", size: 30)!
        lblAudi2.font = UIFont(name: "AudiType-ExtendedNormal", size: 20)!
        lblAudi.textColor = UIColor.redAudi
        lblAudi2.textColor = UIColor.white
        UIView.animate(withDuration: 1.5, animations: {
            self.lblAudi.alpha = 1.0
            self.lblAudi2.alpha = 1.0
        })
        btnRepeat.isHidden = false
        btnRepeat.isUserInteractionEnabled = true
        } else {
            lblAudi.isHidden = true
            lblAudi2.isHidden = true
            btnRepeat.isHidden = true
            btnRepeat.isUserInteractionEnabled = false
        }
    }
    @IBAction func btnRepeat(_ sender: Any) {
        repeatBool = true
        showText()
        vPointZaehler = 0
        finished = false
        gefundeneBeacon = [58690, 16713, 42263, 24984]
        trackLayerBeacon.isHidden = false
        shapeLayerBeaconRange.isHidden = false
        trackPoint1.isHidden = false
        trackPoint2.isHidden = false
        trackPoint3.isHidden = false
        trackPoint4.isHidden = false
        pulsatingLayerBeacon.isHidden = false
        finishAnimationTimer()
        repeatTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.repeatTimerPoints), userInfo: nil, repeats: false)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
        print(vPointZaehler)
        print(gefundeneBeacon)
        
    }
    
    @objc func repeatTimerPoints() {
        pointIsRealAnimation.toValue = -0.1
        pointShapeLayer1.add(pointIsRealAnimation, forKey: "new")
        pointShapeLayer2.add(pointIsRealAnimation, forKey: "new")
        pointShapeLayer3.add(pointIsRealAnimation, forKey: "new")
        pointShapeLayer4.add(pointIsRealAnimation, forKey: "new")
        pointIsRealAnimation.toValue = 1
        timerPulse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.animatePulsatingLayer), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc() {
        if finished == true {
            pointShapeLayer1.position = CGPoint(x: view2.center.x, y: view3.center.y)
            pointShapeLayer2.position = CGPoint(x: view2.center.x, y: view3.center.y)
            pointShapeLayer3.position = CGPoint(x: view2.center.x, y: view3.center.y)
            pointShapeLayer4.position = CGPoint(x: view2.center.x, y: view3.center.y)
            trackPoint4.isHidden = true
            finishTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.finishAnimationTimer), userInfo: nil, repeats: false)
            timer.invalidate()
            //            animateFinishLayer()
        } else {
            animateCircle()
            if isNear == true {
                btnQuestionView.isHidden = false
                btnQuestionView.isUserInteractionEnabled = true
            } else {
                btnQuestionView.isHidden = true
                btnQuestionView.isUserInteractionEnabled = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knowBeacons = beacons.filter{ $0.proximity == CLProximity.immediate || $0.proximity == CLProximity.near || $0.proximity == CLProximity.far}
        if knowBeacons.count > 0 {
            var iBeacon = knowBeacons.first!
            tempBeaconMinor = iBeacon.minor as! Int
            if gefundeneBeacon.contains(tempBeaconMinor) {
                let tempBeacon = iBeacon.accuracy
                //lblAusgabe.text = String(tempBeacon)
                //let vToValue = 1 - iBeacon.accuracy
                if tempBeacon < 0.6 {
                    isNear = true
                } else {
                    isNear = false
                }
                if tempBeacon < 0.6 {
                    rangeToBeaconAnimation.toValue = 1
                }  else if tempBeacon >= 0.6 && tempBeacon < 0.8 {
                    rangeToBeaconAnimation.toValue = 0.7
                } else if tempBeacon >= 0.8 && tempBeacon < 1.1 {
                    rangeToBeaconAnimation.toValue = 0.5
                } else if tempBeacon >= 1.1 && tempBeacon < 1.5 {
                    rangeToBeaconAnimation.toValue = 0.4
                } else if tempBeacon >= 1.5 && tempBeacon < 2.0 {
                    rangeToBeaconAnimation.toValue = 0.2
                } else {
                    rangeToBeaconAnimation.toValue = 0.0
                }
            } else {
                iBeacon = knowBeacons[1]
                tempBeaconMinor = iBeacon.minor as! Int
                if gefundeneBeacon.contains(tempBeaconMinor) {
                    let tempBeacon = iBeacon.accuracy
                    //lblAusgabe.text = String(tempBeacon)
                    //let vToValue = 1 - iBeacon.accuracy
                    if tempBeacon < 0.6 {
                        isNear = true
                    } else {
                        isNear = false
                    }
                    if tempBeacon < 0.6 {
                        rangeToBeaconAnimation.toValue = 1
                    }  else if tempBeacon >= 0.6 && tempBeacon < 0.8 {
                        rangeToBeaconAnimation.toValue = 0.7
                    } else if tempBeacon >= 0.8 && tempBeacon < 1.1 {
                        rangeToBeaconAnimation.toValue = 0.5
                    } else if tempBeacon >= 1.1 && tempBeacon < 1.5 {
                        rangeToBeaconAnimation.toValue = 0.4
                    } else if tempBeacon >= 1.5 && tempBeacon < 2.0 {
                        rangeToBeaconAnimation.toValue = 0.2
                    } else {
                        rangeToBeaconAnimation.toValue = 0.0
                    }
                } else {
                    iBeacon = knowBeacons[2]
                    tempBeaconMinor = iBeacon.minor as! Int
                    if gefundeneBeacon.contains(tempBeaconMinor) {
                        let tempBeacon = iBeacon.accuracy
                        //lblAusgabe.text = String(tempBeacon)
                        //let vToValue = 1 - iBeacon.accuracy
                        if tempBeacon < 0.6 {
                            isNear = true
                        } else {
                            isNear = false
                        }
                        if tempBeacon < 0.6 {
                            rangeToBeaconAnimation.toValue = 1
                        }  else if tempBeacon >= 0.6 && tempBeacon < 0.8 {
                            rangeToBeaconAnimation.toValue = 0.7
                        } else if tempBeacon >= 0.8 && tempBeacon < 1.1 {
                            rangeToBeaconAnimation.toValue = 0.5
                        } else if tempBeacon >= 1.1 && tempBeacon < 1.5 {
                            rangeToBeaconAnimation.toValue = 0.4
                        } else if tempBeacon >= 1.5 && tempBeacon < 2.0 {
                            rangeToBeaconAnimation.toValue = 0.2
                        } else {
                            rangeToBeaconAnimation.toValue = 0.0
                        }
                    } else {
                        iBeacon = knowBeacons[3]
                        tempBeaconMinor = iBeacon.minor as! Int
                        if gefundeneBeacon.contains(tempBeaconMinor) {
                            let tempBeacon = iBeacon.accuracy
                            //lblAusgabe.text = String(tempBeacon)
                            if tempBeacon < 0.6 {
                                isNear = true
                            } else {
                                isNear = false
                            }
                            if tempBeacon < 0.6 {
                                rangeToBeaconAnimation.toValue = 1
                            }  else if tempBeacon >= 0.6 && tempBeacon < 0.8 {
                                rangeToBeaconAnimation.toValue = 0.7
                            } else if tempBeacon >= 0.8 && tempBeacon < 1.1 {
                                rangeToBeaconAnimation.toValue = 0.5
                            } else if tempBeacon >= 1.1 && tempBeacon < 1.5 {
                                rangeToBeaconAnimation.toValue = 0.4
                            } else if tempBeacon >= 1.5 && tempBeacon < 2.0 {
                                rangeToBeaconAnimation.toValue = 0.2
                            } else {
                                rangeToBeaconAnimation.toValue = 0.0
                            }
                            //let vToValue = 1 - iBeacon.accuracy
                            //                            if tempBeacon < 0.5 {
                            //                                isNear = true
                            //                                rangeToBeaconAnimation.toValue = 1
                            //                            }  else {
                            //                                isNear = false
                            //                                rangeToBeaconAnimation.toValue = vToValue
                            //                            }
                        } else {
                            lblAusgabe.text = String(tempBeaconMinor)
                        }
                    }
                }
            }
        }
    }
    
    @objc func goToQuestionView(sender: UIButton) {
        if let button: UIButton = sender as? UIButton {
            switch button.tag {
            case 89: performSegue(withIdentifier: "Go", sender: nil)
                repeatBool = false
            default: print("no Button :( ")
            }
        }
        // performSegue(withIdentifier: "Go", sender: nil)
    }
    
    private func loadAnimationPoints() {
        let TempObject = UserDefaults.standard.object(forKey: "Bestanden") //Daten laden
        var NummerTemp = TempObject as! Bool?
        if repeatBool == true {
            NummerTemp = false
        }
        
        switch vPointZaehler {
        case 1: if NummerTemp == true {
            pointShapeLayer1.add(pointIsRealAnimation, forKey: "point1Animation")
        } else {
            pointShapeLayer1.strokeEnd = 1}
        case 2:
            if NummerTemp == true {
                pointShapeLayer1.strokeEnd = 1
                pointShapeLayer2.add(pointIsRealAnimation, forKey: "point2Animation")
            } else {
                pointShapeLayer1.strokeEnd = 1
                pointShapeLayer2.strokeEnd = 1
            }
        case 3:
            if NummerTemp == true {
                pointShapeLayer1.strokeEnd = 1
                pointShapeLayer2.strokeEnd = 1
                pointShapeLayer3.add(pointIsRealAnimation, forKey: "point3Animation")
            } else {
                pointShapeLayer1.strokeEnd = 1
                pointShapeLayer2.strokeEnd = 1
                pointShapeLayer3.strokeEnd = 1
            }
        case 4:
            if NummerTemp == true {
                btnFire.isUserInteractionEnabled = true
                pointShapeLayer1.strokeEnd = 1
                pointShapeLayer2.strokeEnd = 1
                pointShapeLayer3.strokeEnd = 1
                finished = true
                pointShapeLayer4.add(pointIsRealAnimation, forKey: "point4Animation")
                btnQuestionView.isHidden = true
                btnQuestionView.isUserInteractionEnabled = false
                trackLayerBeacon.isHidden = true
                shapeLayerBeaconRange.isHidden = true
                trackPoint1.isHidden = true
                trackPoint2.isHidden = true
                trackPoint3.isHidden = true
                pulsatingLayerBeacon.isHidden = true
            } else {}
        default: print("default PointZaehler")
        }
    }
    
    @objc func addFire() {
        timerCountFireWork = timerCountFireWork + 1
        if timerCountFireWork <= 2 {
        } else if timerCountFireWork >= 2 && timerCountFireWork <= 20 {
            let lower: UInt32 = 10
            let upper: UInt32 = UInt32(UIScreen.main.bounds.width)
            let pop = PopView()
            pop.center = .init(x: CGFloat(arc4random_uniform(upper - lower) + lower), y: CGFloat(arc4random_uniform(upper - lower) + lower))
            view.addSubview(pop)
        } else {
            timerFireWork.invalidate()
        }
    }
    
    private func setActionButton() {
        let widthActionButton: CGFloat = 80
        let heightActionButton: CGFloat = 80
        btnQuestionView.frame = CGRect(x: view3.center.x - widthActionButton/2, y: view3.center.y - heightActionButton/2, width: widthActionButton, height: heightActionButton)
        btnQuestionView.backgroundColor = UIColor.backgroundColor
        btnQuestionView.setTitleColor(UIColor.redAudi, for: .normal)
        btnQuestionView.tag = 89
        btnQuestionView.backgroundColor = UIColor.clear
        btnQuestionView.setTitle("Go!", for: UIControlState.normal)
        btnQuestionView.addTarget(self, action: #selector(ViewController.goToQuestionView), for: UIControlEvents.touchUpInside)
        btnQuestionView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        btnQuestionView.isHidden = true
        btnQuestionView.isUserInteractionEnabled = false
        self.view.addSubview(btnQuestionView)
    }
    
    private func setTrackPoints() {
        locationManager.startRangingBeacons(in: region)
        pulsatingLayerBeacon = CAShapeLayer()
        pulsatingLayerBeacon.path = circularPuls.cgPath
        pulsatingLayerBeacon.fillColor = UIColor.redAudiAlpha.cgColor
        pulsatingLayerBeacon.position = view3.center
        view.layer.addSublayer(pulsatingLayerBeacon)
        trackLayerBeacon.path = circularPath3.cgPath
        trackLayerBeacon.strokeColor = UIColor.darkGray.cgColor
        trackLayerBeacon.fillColor = UIColor.backgroundColor.cgColor
        trackLayerBeacon.lineWidth = shaperLineWidth
        trackLayerBeacon.lineCap = kCALineCapRound
        trackLayerBeacon.position = view3.center
        view.layer.addSublayer(trackLayerBeacon)
        shapeLayerBeaconRange.position = view3.center
        shapeLayerBeaconRange.path = circularPath3.cgPath
        shapeLayerBeaconRange.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayerBeaconRange.lineWidth = shaperLineWidth
        shapeLayerBeaconRange.lineCap = kCALineCapRound
        shapeLayerBeaconRange.fillColor = UIColor.clear.cgColor
        shapeLayerBeaconRange.strokeEnd = 0
        view.layer.addSublayer(shapeLayerBeaconRange)
        pointIsRealAnimation.toValue = 1
        pointIsRealAnimation.duration = 1
        pointIsRealAnimation.isRemovedOnCompletion = false
        pointIsRealAnimation.fillMode = kCAFillModeForwards
        trackPoint1.path = pointPath.cgPath
        trackPoint1.strokeColor = UIColor.whiteAudi.cgColor
        trackPoint1.fillColor = UIColor.clear.cgColor
        trackPoint1.lineWidth = 7
        trackPoint1.lineCap = kCALineCapRound
        trackPoint1.position = view11.center
        trackPoint2.path = pointPath.cgPath
        trackPoint2.strokeColor = UIColor.whiteAudi.cgColor
        trackPoint2.fillColor = UIColor.clear.cgColor
        trackPoint2.lineWidth = 7
        trackPoint2.lineCap = kCALineCapRound
        trackPoint2.position = view12.center
        trackPoint3.path = pointPath.cgPath
        trackPoint3.strokeColor = UIColor.whiteAudi.cgColor
        trackPoint3.fillColor = UIColor.clear.cgColor
        trackPoint3.lineWidth = 7
        trackPoint3.lineCap = kCALineCapRound
        trackPoint3.position = view13.center
        trackPoint4.path = pointPath.cgPath
        trackPoint4.strokeColor = UIColor.whiteAudi.cgColor
        trackPoint4.fillColor = UIColor.clear.cgColor
        trackPoint4.lineWidth = 7
        trackPoint4.lineCap = kCALineCapRound
        trackPoint4.position = view14.center
        view.layer.addSublayer(trackPoint1)
        view.layer.addSublayer(trackPoint2)
        view.layer.addSublayer(trackPoint3)
        view.layer.addSublayer(trackPoint4)
        
        pointShapeLayer1.path = pointPath.cgPath
        pointShapeLayer1.position = view11.center
        pointShapeLayer1.strokeColor = UIColor.white.cgColor
        pointShapeLayer1.lineCap = kCALineCapRound
        pointShapeLayer1.fillColor = UIColor.clear.cgColor
        pointShapeLayer1.lineWidth = 6
        pointShapeLayer1.strokeEnd = 0
        view.layer.addSublayer(pointShapeLayer1)
        pointShapeLayer2.path = pointPath.cgPath
        pointShapeLayer2.position = view12.center
        pointShapeLayer2.strokeColor = UIColor.white.cgColor
        pointShapeLayer2.lineCap = kCALineCapRound
        pointShapeLayer2.fillColor = UIColor.clear.cgColor
        pointShapeLayer2.lineWidth = 6
        pointShapeLayer2.strokeEnd = 0
        view.layer.addSublayer(pointShapeLayer2)
        pointShapeLayer3.path = pointPath.cgPath
        pointShapeLayer3.position = view13.center
        pointShapeLayer3.strokeColor = UIColor.white.cgColor
        pointShapeLayer3.lineCap = kCALineCapRound
        pointShapeLayer3.fillColor = UIColor.clear.cgColor
        pointShapeLayer3.lineWidth = 6
        pointShapeLayer3.strokeEnd = 0
        view.layer.addSublayer(pointShapeLayer3)
        pointShapeLayer4.path = pointPath.cgPath
        pointShapeLayer4.position = view14.center
        pointShapeLayer4.strokeColor = UIColor.white.cgColor
        pointShapeLayer4.lineCap = kCALineCapRound
        pointShapeLayer4.fillColor = UIColor.clear.cgColor
        pointShapeLayer4.lineWidth = 6
        pointShapeLayer4.strokeEnd = 0
        view.layer.addSublayer(pointShapeLayer4)
        finishLayer.path = finishPath.cgPath
        finishLayer.position = CGPoint(x: view.center.x, y: view3.center.y)
        finishLayer.strokeColor = UIColor.red.cgColor
        finishLayer.lineCap = kCALineCapRound
        finishLayer.fillColor = UIColor.clear.cgColor
        finishLayer.lineWidth = 5
    }
    
    func setBackGroundClear() {
        for i in 1...12 {
            if let viewX = self.view.viewWithTag(i) {
                viewX.backgroundColor = UIColor.clear
            }
        }
    }
    
}


