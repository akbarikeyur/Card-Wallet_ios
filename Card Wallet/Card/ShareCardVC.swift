//
//  ShareCardVC.swift
//  Card Wallet
//
//  Created by Keyur on 16/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class ShareCardVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var arrSearchData : [UserModel] = [UserModel]()
    var arrSelectedUser : [UserModel] = [UserModel]()
    var card : CardModel = CardModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "CustomUserSelectionTCV", bundle: nil), forCellReuseIdentifier: "CustomUserSelectionTCV")
        
        if let textFieldInsideSearchBar : UITextField = searchbar.value(forKey: "searchField") as? UITextField
        {
            textFieldInsideSearchBar.textColor = WhiteColor
        }
    }
    

    //MARK:- Button click event
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToShare(_ sender: Any) {
        self.view.endEditing(true)
        sendInvitationToUser(arrSelectedUser, card)
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppModel.shared.USERS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomUserSelectionTCV = tblView.dequeueReusableCell(withIdentifier: "CustomUserSelectionTCV") as! CustomUserSelectionTCV
        let user : UserModel = AppModel.shared.USERS[indexPath.row]
        setBackgroundImage(user.picture, btn: cell.profilePicBtn)
        cell.nameLbl.text = user.name
        cell.emailLbl.text = user.email
        
        let index = arrSelectedUser.firstIndex { (temp) -> Bool in
            temp.uID == user.uID
        }
        cell.selectBtn.isSelected = (index != nil)
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user : UserModel = AppModel.shared.USERS[indexPath.row]
        let index = arrSelectedUser.firstIndex { (temp) -> Bool in
            temp.uID == user.uID
        }
        if index == nil
        {
            arrSelectedUser.append(user)
        }
        else
        {
            arrSelectedUser.remove(at: index!)
        }
        tblView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.trimmed != ""
        {
            arrSearchData = [UserModel]()
            
            arrSearchData = AppModel.shared.USERS.filter({ (temp) -> Bool in
                let usernameText: NSString = temp.name! as NSString
                
                return (usernameText.range(of: searchBar.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            
            tblView.reloadData()
        }
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
