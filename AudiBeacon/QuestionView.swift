//
//  QuestionView.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 20.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit

class QuestionView: UIViewController {
    
    
    @IBOutlet weak var viewBackgroundImage: UIImageView!
    @IBOutlet weak var viewBackgroundAnswers: UIView!
    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var lblFrage: UILabel!
    @IBOutlet weak var btnDText: UIButton!
    @IBOutlet weak var btnCText: UIButton!
    @IBOutlet weak var btnBText: UIButton!
    @IBOutlet weak var btnAText: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnRestart: UIButton!
    let tapGesture = UITapGestureRecognizer()
    var shuffledQuestions = [String]()
    var aQuestions =  [String]()
    var antworten = [[String]]()
    var rand: Int!
    var fontAudi: String!
    var time: Int!
    var timer = Timer()
    var randomTag: Int!
    var vRichtig: Bool!
    var vMinorTemp: Int!
    var greenAudiRight: UIColor!
    var redAudiWrong: UIColor!
    var vWelcheFrage: Int = 0
    var gefundeneBeacon = [Int]()
    var tapCount = false
    
    @IBOutlet weak var viewBackgroundTimerClear: UIView!
    override func viewDidLoad() {
        if vWelcheFrage == 0 {
            aQuestions = ["Wie funktionieren iBeacons?", "Wie weit gehen iBeacons?", "iBeacons sind zum..", " BLE = Bluetooth"]
            antworten = [["mit Bluetooth", "mit WiFi", "mit GPS", "mit Lichtwellen"], ["70 Meter","10 Meter","30 Meter","50 Meter"],["Indoor navigieren"," Joggen geeignet","Internet teilen","Kinder unterhalten",],["Low Energy","Loves Energy","Live Energy","Large Energy"]]
        } else {
            if let aQuestionsStorage = UserDefaults.standard.object(forKey: "Fragen") {
                if let aAntworten = UserDefaults.standard.object(forKey: "Antworten") {
                    aQuestions = aQuestionsStorage as! [String]
                    antworten = aAntworten as! [[String]]
                }
            }
        }
        super.viewDidLoad()
        setup()
        setViewsBackground()
        setQuestion()
        setAnswers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tapCount == true {
            if let ViewControllerX = segue.destination as? ViewController {
                ViewControllerX.vPointZaehler = vWelcheFrage
                ViewControllerX.gefundeneBeacon = gefundeneBeacon
                UserDefaults.standard.set(vRichtig, forKey: "Bestanden")
            }
        }
//        if let button: UIButton = sender as? UIButton {
//            switch button.tag {
//            case 99: if let ViewControllerX = segue.destination as? ViewController {
//                ViewControllerX.vPointZaehler = vWelcheFrage
//                ViewControllerX.gefundeneBeacon = gefundeneBeacon
//                UserDefaults.standard.set(vRichtig, forKey: "Bestanden")
//                }
//            default: print("switch Button Tag Error")
//            }
//        }
    }
    
    @objc func tapGestureFunction() {
        if tapCount == true {
            performSegue(withIdentifier: "GoBack", sender: nil)
        }
    }
    
    @IBAction func btnCheck(_ sender: Any?) {
        if let index = gefundeneBeacon.index(of: vMinorTemp) {
            gefundeneBeacon.remove(at: index)
        }
        UserDefaults.standard.set(aQuestions, forKey: "Fragen")
        UserDefaults.standard.set(antworten, forKey: "Antworten")
        tapCount = true
        vWelcheFrage = vWelcheFrage + 1
        if let button: UIButton = sender as? UIButton {
            if button.tag == randomTag {
                timer.invalidate()
                lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 25)!
                lblTimer.text = "Richtig!"
                button.backgroundColor = greenAudiRight
                vRichtig = true
                //antworten.remove(at: rand)  Zufallsfrage deaktivert.. jeder Beacon eine Frage daher nicht entfernen
                //aQuestions.remove(at: rand)
                
            } else {
                vRichtig = true
                button.backgroundColor = redAudiWrong
                if let buttonView: UIButton = self.view.viewWithTag(randomTag) as? UIButton {
                    buttonView.backgroundColor = greenAudiRight
                }
                timer.invalidate()
                lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 25)
                lblTimer.text = "Leider \n falsch!"
            }
            for i in 1...4 {
                if let noButton: UIButton = self.view.viewWithTag(i) as? UIButton {
                    noButton.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    @objc private func setTime() {
        
        btnRestart.isHidden = true
        btnRestart.isUserInteractionEnabled = false
        if time <= 0 {
            tapCount = true
            vRichtig = true
            if let index = gefundeneBeacon.index(of: vMinorTemp) {
                gefundeneBeacon.remove(at: index)
            }
            vWelcheFrage = vWelcheFrage + 1
            UserDefaults.standard.set(aQuestions, forKey: "Fragen")
            UserDefaults.standard.set(antworten, forKey: "Antworten")
            lblTimer.text = "Zeit \n vorbei!"
            lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 25)
            timer.invalidate()
            if let buttonView: UIButton = self.view.viewWithTag(randomTag) as? UIButton {
                buttonView.backgroundColor = greenAudiRight
            }
            
            for i in 1...4 {
                if let noButton: UIButton = self.view.viewWithTag(i) as? UIButton {
                    noButton.isUserInteractionEnabled = false
                }
            }
        } else {
            lblTimer.text = String(time)
            time = time - 1
        }
        
        /*if vRichtig == false {
        if time <= 0 {
            btnRestart.isHidden = false
            btnRestart.isUserInteractionEnabled = true
            lblTimer.text = "Zeit \n vorbei!"
            lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 25)
            timer.invalidate()
            vRichtig = false
            for i in 1...4 {
                if let noButton: UIButton = self.view.viewWithTag(i) as? UIButton {
                    noButton.isUserInteractionEnabled = false
                }
            }
        } else {
            btnRestart.isUserInteractionEnabled = false
            btnRestart.isHidden = true
            lblTimer.text = String(time)
            time = time - 1
        }
        }*/
    }
    
    func setAnswers() {
        randomTag = Int(arc4random_uniform(UInt32(4))) + 1
        if let button: UIButton = self.view.viewWithTag(randomTag) as? UIButton {
            switch randomTag {
            case 1: button.setTitle("   A: \(antworten[rand][0])", for: .normal)
            case 2: button.setTitle("   B: \(antworten[rand][0])", for: .normal)
            case 3: button.setTitle("   C: \(antworten[rand][0])", for: .normal)
            case 4: button.setTitle("   D: \(antworten[rand][0])", for: .normal)
            default:
                print(randomTag)
            }
            antworten[rand].remove(at: 0)
        }
        
        for i in 1...4 {
            if i == randomTag {
            } else {
                if let button: UIButton = self.view.viewWithTag(i) as? UIButton {
                    let randTemp = Int(arc4random_uniform(UInt32(antworten[rand].count)))
                    switch i {
                    case 1: button.setTitle("   A: \(antworten[rand][randTemp])", for: .normal)
                    case 2: button.setTitle("   B: \(antworten[rand][randTemp])", for: .normal)
                    case 3: button.setTitle("   C: \(antworten[rand][randTemp])", for: .normal)
                    case 4: button.setTitle("   D: \(antworten[rand][randTemp])", for: .normal)
                    default: print("random Tag setAnswers")
                    }
                   antworten[rand].remove(at: randTemp)
                }
            }
        }
    }
    
    func setViewsBackground() {
        
        for i in 1...4 {
            if let button: UIButton = self.view.viewWithTag(i) as? UIButton {
                if button.tag == i {
                    button.titleLabel?.font = UIFont(name: fontAudi, size: 20)
                    button.tintColor = UIColor.white
                    button.backgroundColor = UIColor.backgroundColor
                    button.titleLabel?.textAlignment = .left
                    button.layer.borderColor = UIColor.white.cgColor
                    button.layer.borderWidth = 1
                }
            }
        }
        view.backgroundColor = UIColor.backgroundColor
        viewQuestion.backgroundColor = UIColor.backgroundColor
        viewQuestion.layer.borderWidth = 2
        viewQuestion.layer.borderColor = UIColor.white.cgColor
        viewBackground.backgroundColor = UIColor.backgroundColor
        viewBackgroundImage.alpha = 0.5
        viewBackgroundTimerClear.backgroundColor = UIColor.backgroundColor
        viewBackgroundTimerClear.layer.cornerRadius = viewBackgroundTimerClear.frame.size.width/2
        viewBackgroundTimerClear.clipsToBounds = true
        viewBackgroundTimerClear.layer.borderWidth = 5.0
        viewBackgroundTimerClear.layer.borderColor = UIColor.white.cgColor
    }
    
    func setQuestion() {
        lblTimer.numberOfLines = 0
        lblTimer.lineBreakMode = .byWordWrapping
        lblTimer.textColor = UIColor.white
        lblTimer.text = ""
        lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 50)
        lblTimer.text = "15"
        lblFrage.font = UIFont(name: "AudiType-ExtendedBold", size: 15)!
        lblFrage.textColor = UIColor.white
        switch vMinorTemp {
        case 35885: rand = 0
            lblFrage.text = "Wie funktionieren iBeacons?"
        case 22438: rand = 1
            lblFrage.text = "Wie weit gehen iBeacons?"
        case 3290: rand = 2
            lblFrage.text = "iBeacons sind zum.."
        case 22936: rand = 3
            lblFrage.text = "BLE = Bluetooth"
        default: print("kein Beacon übergeben setQuestion")
        }
        //rand = Int(arc4random_uniform(UInt32(aQuestions.count)))   nur bei Zufallsfrage
        lblFrage.numberOfLines = 0
        lblFrage.lineBreakMode = .byWordWrapping
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
    
    @IBAction func btnRestart(_ sender: Any) {
        lblTimer.text = ""
        time = 14
        lblTimer.text = "15"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuestionView.setTime), userInfo: nil, repeats: true)
        lblTimer.font = UIFont(name: "AudiType-ExtendedBold", size: 50)
        for i in 1...4 {
            if let noButton: UIButton = self.view.viewWithTag(i) as? UIButton {
                noButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func setup() {
        time = 14
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuestionView.setTime), userInfo: nil, repeats: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(QuestionView.tapGestureFunction))
        btnRestart.isUserInteractionEnabled = false
        btnRestart.isHidden = true
        viewBackground.addGestureRecognizer(tapGesture)
        greenAudiRight = UIColor.rightGreen
        redAudiWrong = UIColor.wrongRed
        rand = 0
        fontAudi = "AudiType-Normal"
        randomTag = 0
        vRichtig = false
    }
}
