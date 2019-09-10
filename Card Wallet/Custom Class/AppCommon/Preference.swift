//
//  Preference.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
    
    let IS_USER_LOGIN_KEY       =   "IS_USER_LOGIN"
    let IS_USER_SIGNUP_KEY       =   "IS_USER_SIGNUP"
}


func setDataToPreference(data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: key) as AnyObject?
}

func removeDataFromPreference(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues()
{
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

//MARK: - User login boolean
func setIsUserLogin(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_USER_LOGIN_KEY)
}

func isUserLogin() -> Bool
{
    let isUserLogin = getDataFromPreference(key: Preference.sharedInstance.IS_USER_LOGIN_KEY)
    return isUserLogin == nil ? false:(isUserLogin as! Bool)
}

//MARK: - User Signup boolean
func setIsSignup(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_USER_SIGNUP_KEY)
}

func isSignup() -> Bool
{
    let isUserLogin = getDataFromPreference(key: Preference.sharedInstance.IS_USER_SIGNUP_KEY)
    return isUserLogin == nil ? false:(isUserLogin as! Bool)
}

//MARK: - User Data
func setLoginUserData()
{
    setDataToPreference(data: AppModel.shared.currentUser.dictionary() as AnyObject, forKey: "LOGIN_USER_DATA")
    setIsUserLogin(isUserLogin: true)
}

func getLoginUserData() -> UserModel
{
    if let data : [String : Any] = getDataFromPreference(key: "LOGIN_USER_DATA") as? [String : Any]
    {
        return UserModel.init(dict: data)
    }
    return UserModel.init()
}

