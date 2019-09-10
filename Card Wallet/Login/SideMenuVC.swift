//
//  SideMenuVC.swift
//  Card Wallet
//
//  Created by Keyur on 12/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomSideMenuTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: Label!
}

struct MENU {
    static let HOME = "Home"
    static let ADD_CARD = "Add Card"
    static let MY_CARD = "My Card"
    static let FAVORITE_CARD = "Favorite Card"
    static let LOGOUT = "Logout"
}

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var usernameLbl: Label!
    @IBOutlet weak var tblView: UITableView!
    
    let arrMenuData : [String] = [MENU.HOME, MENU.ADD_CARD, MENU.MY_CARD, MENU.FAVORITE_CARD, MENU.LOGOUT]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(setUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_USER_DATA), object: nil)
        
        
    }
    
    //MARK:- Set User Data
    @objc func setUserData()
    {
        if AppModel.shared.currentUser.picture != nil {
            setBackgroundImage(AppModel.shared.currentUser.picture, btn: profilePicBtn)
            usernameLbl.text = AppModel.shared.currentUser.name
        }else{
            delay(2.0) {
                if AppModel.shared.currentUser.picture != nil {
                    setBackgroundImage(AppModel.shared.currentUser.picture, btn: self.profilePicBtn)
                    self.usernameLbl.text = AppModel.shared.currentUser.name
                }
            }
        }
        
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomSideMenuTVC = tblView.dequeueReusableCell(withIdentifier: "CustomSideMenuTVC") as! CustomSideMenuTVC
        cell.titleLbl.text = arrMenuData[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        switch arrMenuData[indexPath.row] {
        case MENU.HOME:
            break
        case MENU.ADD_CARD:
            let vc : AddCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case MENU.MY_CARD:
            let vc : MyCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "MyCardVC") as! MyCardVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case MENU.FAVORITE_CARD:
            let vc : MyCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "MyCardVC") as! MyCardVC
            vc.isFavCard = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case MENU.LOGOUT:
            DispatchQueue.main.async {
                showAlertWithOption("Logout", message: "Are your sure want to logout?", completionConfirm: {
                    AppDelegate().sharedDelegate().logoutFromApp()
                }, completionCancel: {
                    
                })
            }
            break
        default:
            break
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
