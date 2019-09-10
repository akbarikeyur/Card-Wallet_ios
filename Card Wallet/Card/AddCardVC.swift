//
//  AddCardVC.swift
//  Card Wallet
//
//  Created by Keyur on 12/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

class CustomCategoryTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: Label!
    
}

class AddCardVC: UploadImageVC, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logoBtn: Button!
    @IBOutlet weak var companyNameTxt: TextField!
    @IBOutlet weak var categoryTxt: TextField!
    @IBOutlet weak var userNameTxt: TextField!
    @IBOutlet weak var contactTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var addressTxt: TextField!
    
    @IBOutlet var categoryView: UIView!
    @IBOutlet weak var searchCategoryTxt: UISearchBar!
    @IBOutlet weak var categoryTblView: UITableView!
    
    
    var card : CardModel = CardModel.init()
    var cardImage : UIImage?
    var arrSearchCategoryData : [String] = [String]()
    var isEditCard : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let textFieldInsideSearchBar : UITextField = searchCategoryTxt.value(forKey: "searchField") as? UITextField
        {
            textFieldInsideSearchBar.textColor = WhiteColor
        }
        
        if card.card_id != ""
        {
            isEditCard = true
            
            setBackgroundImage(card.image, btn: logoBtn)
            companyNameTxt.text = card.company_name
            categoryTxt.text = card.category
            userNameTxt.text = card.name
            contactTxt.text = card.contact
            emailTxt.text = card.email
            addressTxt.text = card.address
        }
        else
        {
            card.color = DARK_COLOR_ARRAY[0]
        }
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToSelectLogo(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        self.view.endEditing(true)
        cardImage = choosenImage.simpleRemoveBackgroundColor()
        logoBtn.setBackgroundImage(cardImage, for: .normal)
    }
    
    @IBAction func clickToSelectAddress(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        self.view.endEditing(true)
        openCategoryView()
    }
    
    
    @IBAction func clickToCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddCard(_ sender: Any) {
        self.view.endEditing(true)
        
        if !isEditCard && cardImage == nil
        {
            displayToast("Please select your logo.")
        }
        else if companyNameTxt.text?.trimmed == ""
        {
            displayToast("Please enter your company name.")
        }
        else if companyNameTxt.text?.trimmed == ""
        {
            displayToast("Please enter your company name.")
        }
        else if categoryTxt.text?.trimmed == ""
        {
            displayToast("Please select category.")
        }
        else if userNameTxt.text?.trimmed == ""
        {
            displayToast("Please enter your name.")
        }
        else if contactTxt.text?.trimmed == ""
        {
            displayToast("Please enter your contact number.")
        }
        else if emailTxt.text?.trimmed != "" && !(emailTxt.text?.isValidEmail)!
        {
            displayToast("Invalid email.")
        }
        else if addressTxt.text?.trimmed == ""
        {
            displayToast("Please enter your address.")
        }
        else
        {
            if !isEditCard
            {
                card.card_id = getCurrentTimeStampValue()
            }
            card.user_id = currentUserId()
            card.company_name = companyNameTxt.text?.trimmed
            card.name = userNameTxt.text
            card.contact = contactTxt.text
            card.email = emailTxt.text
            card.address = addressTxt.text
            card.category = categoryTxt.text
            
            let vc : AddCardColorVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "AddCardColorVC") as! AddCardColorVC
            vc.card = card
            if cardImage != nil
            {
                vc.cardImage = cardImage!
            }
            vc.isEditCard = isEditCard
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - Navigation
    func openCategoryView()
    {
        self.view.endEditing(true)
        searchCategoryTxt.text = categoryTxt.text
        displaySubViewtoParentView(self.view, subview: categoryView)
        categoryTblView.reloadData()
    }
    
    @IBAction func clickToDoneCategory(_ sender: Any) {
        self.view.endEditing(true)
        categoryTxt.text = searchCategoryTxt.text
        categoryView.removeFromSuperview()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.trimmed != ""
        {
            arrSearchCategoryData = [String]()
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchBar.text!)
            let array = (AppModel.shared.CATEGORY as NSArray).filtered(using: searchPredicate)
            arrSearchCategoryData = array as! [String]
            categoryTblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchCategoryTxt.text?.trimmed.count == 0) ? AppModel.shared.CATEGORY.count : arrSearchCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCategoryTVC = categoryTblView.dequeueReusableCell(withIdentifier: "CustomCategoryTVC") as! CustomCategoryTVC
        cell.titleLbl.text = (searchCategoryTxt.text?.trimmed.count == 0) ? AppModel.shared.CATEGORY[indexPath.row] : arrSearchCategoryData[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryTxt.text = (searchCategoryTxt.text?.trimmed.count == 0) ? AppModel.shared.CATEGORY[indexPath.row] : arrSearchCategoryData[indexPath.row]
        categoryView.removeFromSuperview()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
