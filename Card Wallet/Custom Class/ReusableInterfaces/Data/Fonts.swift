//
//  Fonts.swift
//  Cozy Up
//
//  Created by Amisha on 22/05/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation

import UIKit

let HELVETICA_BOLD = "Helvetica-Bold"
let HELVETICA_REGULAR = "Helvetica"
let HELVETICA_LIGHT = "Helvetica-Light"


enum FontType : String {
    case Clear = ""
    
    case HelveticaBold = "hb"
    case HelveticaRegular = "hr"
    case HelveticaLight = "hl"
}


extension FontType {
    var value: String {
        get {
            switch self {
            case .Clear:
                return HELVETICA_REGULAR
            
            case .HelveticaBold :
                return HELVETICA_BOLD
            case .HelveticaRegular :
                return HELVETICA_REGULAR
            case .HelveticaLight :
                return HELVETICA_LIGHT
            }
        }
    }
}

