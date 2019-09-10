//
//  CardDisplayView.swift
//  Card Wallet
//
//  Created by Keyur on 15/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CardDisplayView: UIView {

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var frontView: View!
    @IBOutlet weak var backView: View!
    @IBOutlet weak var logoImgView: ImageView!
    @IBOutlet weak var companyNameLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var userNameLbl: Label!
    @IBOutlet weak var contactLbl: Label!
    @IBOutlet weak var emailLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var removeCardView: View!
    @IBOutlet weak var editBtnView: View!
    
    @IBOutlet weak var shareCardView: View!
    @IBOutlet weak var shareFrontView: UIImageView!
    @IBOutlet weak var shareBackView: UIImageView!
    
    
    var card : CardModel = CardModel.init()
    var isFrontView : Bool = true
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CardDisplayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        if favoriteBtn == nil || card.user_id == ""
        {
            delay(0) {
                self.setup()
            }
            return
        }
        
        if card.user_id == AppModel.shared.currentUser.uID
        {
            favoriteBtn.isHidden = true
            editBtnView.isHidden = false
            removeCardView.isHidden = false
        }
        else{
            favoriteBtn.isHidden = false
            editBtnView.isHidden = true
            removeCardView.isHidden = true
            
            let index = AppModel.shared.currentUser.favCard.firstIndex { (temp) -> Bool in
                temp == card.card_id
            }
            if index == nil
            {
                favoriteBtn.isSelected = false
            }
            else
            {
                favoriteBtn.isSelected = true
            }
            
        }
        frontView.isHidden = false
        backView.isHidden = false
        setImageFromUrl(card.image, img: logoImgView)
        companyNameLbl.text = card.company_name
        categoryLbl.text = card.category
        userNameLbl.text = card.name
        contactLbl.text = card.contact
        emailLbl.text = card.email
        addressLbl.text = card.address
        frontView.backgroundColor = colorFromHex(hex: card.color)
        backView.backgroundColor = colorFromHex(hex: card.color)
        
    }

    @IBAction func clickToBack(_ sender: Any) {
        displaySubViewWithScaleInAnim(self)
    }
    
    @IBAction func clickToShare(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelButton)
        
        let cameraButton = UIAlertAction(title: "Internal Share", style: .default)
        { _ in
            let vc : ShareCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "ShareCardVC") as! ShareCardVC
            vc.card = self.card
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheet.addAction(cameraButton)
        
        let galleryButton = UIAlertAction(title: "External Share", style: .default)
        { _ in
            if let frontImage : UIImage = self.frontView.generateImage()
            {
                if let backImage : UIImage = self.backView.generateImage()
                {
                    let activityViewController = UIActivityViewController(activityItems: [frontImage, backImage] , applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self
                    UIApplication.topViewController()!.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        actionSheet.addAction(galleryButton)
        
        UIApplication.topViewController()!.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickToFavorite(_ sender: Any) {
        favoriteBtn.isSelected = !favoriteBtn.isSelected
        let index = AppModel.shared.currentUser.favCard.firstIndex { (temp) -> Bool in
            temp == card.card_id
        }
        if index == nil
        {
            AppModel.shared.currentUser.favCard.append(card.card_id)
        }
        else
        {
            AppModel.shared.currentUser.favCard.remove(at: index!)
        }
        updateCurrentUserData()
    }
    
    @IBAction func clickToRemoveCard(_ sender: Any) {
        showAlertWithOption("Delete", message: "Are you sure you want to delete?", completionConfirm: {
            removeCard(card: self.card)
            self.clickToBack(self)
        }) {
            
        }
    }
    
    @IBAction func clickToEditCard(_ sender: Any) {
        let vc : AddCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.card = card
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToFlipCard(_ sender: Any) {
        let duration = 0.3
        if isFrontView
        {
            self.backView.transform = CGAffineTransform(scaleX: 0, y: 1.0)
            self.frontView.transform = CGAffineTransform(scaleX: 1, y: 1.0)
            
            UIView.animate(withDuration: duration, animations: {
                self.frontView.transform = CGAffineTransform(scaleX: 0.0001, y: 1.0)
            }) { (isDone) in
                UIView.animate(withDuration: duration) {
                    self.backView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
            isFrontView = false
        }
        else
        {
            self.backView.transform = CGAffineTransform(scaleX: 1, y: 1.0)
            self.frontView.transform = CGAffineTransform(scaleX: 0, y: 1.0)
            
            
            UIView.animate(withDuration: duration, animations: {
                self.backView.transform = CGAffineTransform(scaleX: 0.0001, y: 1.0)
            }) { (isDone) in
                UIView.animate(withDuration: duration) {
                    self.frontView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
            isFrontView = true
        }
    }
        
}
