//
//  Colors.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var AppColor : UIColor = colorFromHex(hex: "21223c") //2
var LightWhiteColor : UIColor = colorFromHex(hex: "FFFFFF", alpha: 0.5) //3


var Gradient11 : UIColor = colorFromHex(hex: "893AFF")
var Gradient12 : UIColor = colorFromHex(hex: "4817DC")
var Gradient21 : UIColor = colorFromHex(hex: "00CCFF")
var Gradient22 : UIColor = colorFromHex(hex: "0067DB")
var Gradient31 : UIColor = colorFromHex(hex: "FF24BA")
var Gradient32 : UIColor = colorFromHex(hex: "E6411C")



enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case App = 2
    case LightWhite = 3
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
            case .Clear: //0
                return ClearColor
            case .White: //1
                return WhiteColor
            case .App: //2
                return AppColor
            case .LightWhite: //3
                return LightWhiteColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case Purple = 1
    case Blue = 2
    case Pink = 3
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .Purple: //1
                gradient.colors = [
                    Gradient11.cgColor,
                    Gradient12.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            case .Blue: //2
                gradient.colors = [
                    Gradient21.cgColor,
                    Gradient22.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            case .Pink: //3
                gradient.colors = [
                    Gradient31.cgColor,
                    Gradient32.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}

