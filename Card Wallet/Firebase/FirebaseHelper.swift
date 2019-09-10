//
//  FirebaseHelper.swift
//  Card Wallet
//
//  Created by Keyur on 11/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

var appUsersRef:DatabaseReference = Database.database().reference().child("USERS")
var appUsersRefHandler:UInt = 0;

var cardRef:DatabaseReference = Database.database().reference().child("CARDS")
var cardRefHandler:UInt = 0;

var categoryRef:DatabaseReference = Database.database().reference().child("CATEGORY")
var categoryRefHandler:UInt = 0;

var invitationRef:DatabaseReference = Database.database().reference().child("INVITATION")
var invitationRefHandler:UInt = 0;

var storage = Storage.storage()

func setupFirebase()
{
    if isUserLogin()
    {
        callAllHandler()
    }
}

func loginToFirebase(_ email : String, _ password : String)
{
    showLoader()
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        removeLoader()
        if error == nil {
            let user : UserModel = UserModel.init()
            user.email = authResult?.user.email
            user.uID = authResult?.user.uid
            AppModel.shared.currentUser = user
            callAllHandler()
            AppDelegate().sharedDelegate().navigateToDashboard()
        }
        else {
            displayToast(error!.localizedDescription)
        }
    }
}

func createAccountToFirebase(_ email : String, _ password : String, _ name : String, _ image : UIImage)
{
    showLoader()
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        if error == nil {
            
            let user : UserModel = UserModel.init()
            user.email = authResult?.user.email
            user.name = name
            user.uID = authResult?.user.uid
            
            uploadImageToFirebase(image, user.uID, 1, { (strUrl) in
                user.picture = strUrl
                AppModel.shared.currentUser = user
                appUsersRef.child(user.uID).setValue(AppModel.shared.currentUser.dictionary())
                callAllHandler()
                AppDelegate().sharedDelegate().navigateToDashboard()
            }) { (error) in
                print(error.localizedDescription)
            }
        }else {
            displayToast(error!.localizedDescription)
        }
    }
}



func googleLogin(_ credential : AuthCredential)
{
    showLoader()
    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
        removeLoader()
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let user : UserModel = UserModel.init()
        user.email = authResult?.user.email
        user.name = authResult?.user.displayName
        user.uID = authResult?.user.uid
        user.picture = authResult?.user.photoURL?.absoluteString
        AppModel.shared.currentUser = user
        appUsersRef.child(user.uID).setValue(AppModel.shared.currentUser.dictionary())
        callAllHandler()
        AppDelegate().sharedDelegate().navigateToDashboard()
    }
}

func currentUserId() -> String
{
    return Auth.auth().currentUser?.uid ?? ""
}


//MARK:- All Handler
func callAllHandler()
{
    appUsersHandler()
    cardsHandler()
    categoryHandler()
    invitationHandler()
}

func appUsersHandler()
{
    appUsersRef.removeObserver(withHandle: appUsersRefHandler)
    
    appUsersRefHandler = appUsersRef.observe(DataEventType.value) { (snapshot : DataSnapshot) in
        
        AppModel.shared.USERS = [UserModel]()
        var isCurrUserExist:Bool = false
        if snapshot.exists()
        {
            for child in snapshot.children {
                
                let user:DataSnapshot = child as! DataSnapshot
                if let tempDict = user.value as? [String : AnyObject]{
                    let userModel = UserModel.init(dict: tempDict)
                    if( AppModel.shared.currentUser != nil && AppModel.shared.currentUser.uID == user.key)
                    {
                        AppModel.shared.currentUser = userModel
                        isCurrUserExist = true
                    }
                    else
                    {
                        AppModel.shared.USERS.append(userModel)
                    }
                }
            }
        }
        if isCurrUserExist
        {
            setIsUserLogin(isUserLogin: true)
            setLoginUserData()
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_USER_DATA), object: nil)
        }
    }
}

func cardsHandler()
{
    cardRef.removeObserver(withHandle: cardRefHandler)
    
    cardRefHandler = cardRef.observe(DataEventType.value) { (snapshot : DataSnapshot) in
        
        AppModel.shared.CARDS = [CardModel]()
        if snapshot.exists()
        {
            for child in snapshot.children {
                
                let card:DataSnapshot = child as! DataSnapshot
                if let tempDict = card.value as? [String : AnyObject]{
                    AppModel.shared.CARDS.append(CardModel.init(dict: tempDict))
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
    }
}

func categoryHandler()
{
    categoryRef.removeObserver(withHandle: categoryRefHandler)
    
    categoryRefHandler = categoryRef.observe(DataEventType.value) { (snapshot : DataSnapshot) in
        
        AppModel.shared.CATEGORY = [String]()
        if snapshot.exists()
        {
            for child in snapshot.children {
                
                let category:DataSnapshot = child as! DataSnapshot
                if let temp = category.value as? String{
                    AppModel.shared.CATEGORY.append(temp)
                }
            }
        }
    }
}

func invitationHandler()
{
    invitationRef.removeObserver(withHandle: invitationRefHandler)
    
    invitationRefHandler = invitationRef.observe(DataEventType.value) { (snapshot : DataSnapshot) in
        
        AppModel.shared.INVITATION = [String : [InvitationModel]]()
        if snapshot.exists()
        {
            for child in snapshot.children {
                
                let card:DataSnapshot = child as! DataSnapshot
                if let tempDict = card.value as? [String : AnyObject]{
                    print(tempDict)
                }
            }
        }
    }
}

//MARK:- Update Current User Data
func updateCurrentUserData()
{
    if AppModel.shared.currentUser != nil && AppModel.shared.currentUser.uID != ""
    {
        appUsersRef.child(AppModel.shared.currentUser.uID).setValue(AppModel.shared.currentUser.dictionary())
    }
}

//MARK:- Add Card
func addUpdateCardToFirebase(_ card : CardModel, _ image : UIImage?, _ completionHandler : @escaping () ->())
{
    if image != nil
    {
        uploadImageToFirebase(image!, card.image, 2, { (strUrl) in
            card.image = strUrl
            countinueToAddUpdateCard(card) {
                completionHandler()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    else
    {
        countinueToAddUpdateCard(card) {
            completionHandler()
        }
    }
}

func countinueToAddUpdateCard(_ card : CardModel, _ completionHandler : @escaping () ->())
{
    cardRef.child(card.card_id).setValue(card.dictionary())
    let index = AppModel.shared.currentUser.myCard.firstIndex { (temp) -> Bool in
        temp == card.card_id
    }
    if index == nil
    {
        AppModel.shared.currentUser.myCard.append(card.card_id)
        updateCurrentUserData()
    }
    let index1 = AppModel.shared.CATEGORY.firstIndex(where: { (temp) -> Bool in
        temp == card.category
    })
    
    if index1 == nil
    {
        AppModel.shared.CATEGORY.append(card.category)
        categoryRef.setValue(AppModel.shared.CATEGORY)
    }
    completionHandler()
}

func uploadImageToFirebase(_ image: UIImage, _ imageName : String, _ type : Int, _ completionHandler : @escaping (_ imageURL: String) ->(), _ errorHandler : @escaping (_ error: Error) ->()) {

    guard let imageData = image.pngData() else { return }
    showLoader()
    var imgName = imageName
    if imgName == ""
    {
        imgName = getCurrentTimeStampValue()
    }
    
    let folderName = (type == 1) ? "User/" : "Card/"
    let imagePath = folderName + imgName + ".png"
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    let storageRef = storage.reference(withPath: imagePath)
    storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
        if let error = error {
            print(error.localizedDescription)
            removeLoader()
            return
        }
        
        // You can also access to download URL after upload.
        storageRef.downloadURL { (url, error) in
            removeLoader()
            guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                return
            }
            completionHandler(downloadURL.absoluteString    )
        }
    }
}

func removeCard(card : CardModel)
{
    guard let index = AppModel.shared.CARDS.firstIndex(of: card) else {return}
    AppModel.shared.CARDS.remove(at: index)
    cardRef.child(card.card_id).removeValue()
    guard let index1 = AppModel.shared.currentUser.myCard.firstIndex(of: card.card_id) else {return}
    AppModel.shared.currentUser.myCard.remove(at: index1)
    updateCurrentUserData()
}

func sendInvitationToUser(_ users : [UserModel], _ card : CardModel)
{
    for temp in users
    {
        let newInvitation : InvitationModel = InvitationModel.init()
        newInvitation.id = getCurrentTimeStampValue()
        newInvitation.card_id = card.card_id
        newInvitation.date = getCurrentTimeStampValue()
        newInvitation.title = AppModel.shared.currentUser.name + "send you invitation for " + card.company_name
        newInvitation.user_id = temp.uID
        
        var invitationArray : [InvitationModel] = [InvitationModel]()
        
        if let data =  AppModel.shared.INVITATION[temp.uID]
        {
            invitationArray = data
        }
        invitationArray.append(newInvitation)
        
        invitationRef.child(temp.uID).setValue(AppModel.shared.getInvitationArrOfDictionary(arr: invitationArray))
    }
}
