//
//  Extensions.swift
//  AudiBeacon
//
//  Created by Christian Liefeldt on 17.03.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b:CGFloat) -> UIColor {
     
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func rgba(r: CGFloat, g: CGFloat, b:CGFloat) -> UIColor {
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 0.3)
    }
    
    static let backgroundColor = UIColor.rgb(r: 0, g: 0, b: 0)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    static let gold = UIColor.rgb(r: 255, g: 215, b: 0)
    static let audiSilverWarm = UIColor.rgb(r: 182, g: 177, b: 169)
    static let whiteAudi = UIColor.rgba(r: 255, g: 255, b: 255)
    static let redAudi = UIColor.rgb(r: 187, g: 10, b: 48)
    static let redAudiAlpha = UIColor.rgba(r: 187, g: 10, b: 48)
    static let rightGreen = UIColor.rgb(r: 0, g: 150, b: 64)
    static let wrongRed = UIColor.rgb(r: 187, g: 10, b: 48)
    
}
