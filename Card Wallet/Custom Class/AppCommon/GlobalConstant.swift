//
//  GlobalConstant.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import UIKit


let APP_NAME = "My Card Wallet"
let APP_VERSION = 1.0
let BUILD_VERSION = 1
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString

let ITUNES_URL = ""

struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var CARD = UIStoryboard(name: "Card", bundle: nil)
}

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

struct GOOGLE {
    static var KEY = "AIzaSyANUVUNtpFLgdZyOedNJPeoRNG2B_zo0D0"
}

struct DATE_FORMAT {
    static var DISPLAY_DATE_FORMAT = "DD-MM-YYYY"
    static var DISPLAY_TIME_FORMAT = "hh:mm a"
    static var DISPLAY_DATE_TIME_FORMAT = "DD-MM-YYYY hh:mm a"
}

struct NOTIFICATION {
    static var UPDATE_USER_DATA = "UPDATE_USER_DATA"
    static var UPDATE_CARD_DATA = "UPDATE_CARD_DATA"
}
