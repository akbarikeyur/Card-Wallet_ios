//
//  AppModel.swift
//  ToShare
//
//  Created by ToShare Pty. Ltd on 1/2/18.
//  Copyright © 2018 ToShare Pty. Ltd. All rights reserved.
//

import UIKit

class AppModel: NSObject {
    static let shared = AppModel()
    var currentUser : UserModel!
    var USERS : [UserModel] = [UserModel]()
    var CARDS : [CardModel] = [CardModel]()
    var CATEGORY : [String] = [String]()
    var INVITATION : [String : [InvitationModel]] = [String : [InvitationModel]]()
    
    func getInvitationArrOfDictionary(arr:[InvitationModel]) -> [[String:Any]]{ // story
        
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
}

class UserModel:AppModel {
    
    var uID : String!
    var name : String!
    var email : String!
    var picture : String!
    var myCard : [String]!
    var favCard : [String]!
    var fcmToken : String!
    var badge : Int!
    
    override init(){
        uID = ""
        name = ""
        email = ""
        picture = ""
        myCard = [String]()
        favCard = [String]()
        fcmToken = ""
        badge = 0
    }
    init(dict : [String : Any])
    {
        uID = ""
        name = ""
        email = ""
        picture = ""
        myCard = [String]()
        favCard = [String]()
        fcmToken = ""
        badge = 0
        
        if let temp = dict["uID"] as? String{
            uID = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["email"] as? String{
            email = temp
        }
        if let temp = dict["picture"] as? String{
            picture = temp
        }
        if let temp = dict["myCard"] as? [String] {
            myCard = temp
        }
        if let temp = dict["favCard"] as? [String] {
            favCard = temp
        }
        if let temp = dict["fcmToken"] as? String {
            fcmToken = temp
        }
        if let temp = dict["badge"] as? Int {
            badge = temp
        }
    }
    
    func dictionary() -> [String:Any]{
        return ["uID":uID, "name":name, "email":email, "picture":picture, "myCard":myCard, "favCard":favCard, "fcmToken":fcmToken, "badge" : badge]
    }
}

class CardModel:AppModel {
    
    var card_id : String!
    var user_id : String!
    var company_name : String!
    var name : String!
    var contact : String!
    var email : String!
    var address : String!
    var category : String!
    var image : String!
    var color : String!
    
    override init(){
        card_id = ""
        user_id = ""
        company_name = ""
        name = ""
        contact = ""
        email = ""
        address = ""
        category = ""
        image = ""
        color = ""
    }
    init(dict : [String : Any])
    {
        card_id = ""
        user_id = ""
        company_name = ""
        name = ""
        contact = ""
        email = ""
        address = ""
        category = ""
        image = ""
        color = ""
        
        if let temp = dict["card_id"] as? String{
            card_id = temp
        }
        if let temp = dict["user_id"] as? String{
            user_id = temp
        }
        if let temp = dict["company_name"] as? String{
            company_name = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["contact"] as? String{
            contact = temp
        }
        if let temp = dict["email"] as? String{
            email = temp
        }
        if let temp = dict["address"] as? String{
            address = temp
        }
        if let temp = dict["category"] as? String{
            category = temp
        }
        if let temp = dict["image"] as? String{
            image = temp
        }
        if let temp = dict["color"] as? String{
            color = temp
        }
    }
    
    func dictionary() -> [String:Any]{
        return ["card_id":card_id, "user_id":user_id, "company_name":company_name, "name":name, "contact":contact, "email":email, "address":address, "category" : category, "image":image, "color" : color]
    }
}

class InvitationModel:AppModel {
    
    var id : String!
    var title : String!
    var card_id : String!
    var user_id : String!
    var date : String!
    
    override init(){
        id = ""
        title = ""
        card_id = ""
        user_id = ""
        date = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        title = ""
        card_id = ""
        user_id = ""
        date = ""
        
        if let temp = dict["id"] as? String{
            id = temp
        }
        if let temp = dict["title"] as? String{
            title = temp
        }
        if let temp = dict["card_id"] as? String{
            card_id = temp
        }
        if let temp = dict["user_id"] as? String{
            user_id = temp
        }
        if let temp = dict["date"] as? String{
            date = temp
        }
    }
    
    func dictionary() -> [String:Any]{
        return ["id":id, "title":title, "card_id":card_id, "user_id":user_id, "date":date]
    }
}


func toJson(_ dict:[String:Any]) -> String{
    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString!
}
