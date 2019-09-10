//
//  NotificationVC.swift
//  Card Wallet
//
//  Created by Keyur on 18/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: Label!
    
    var arrInvitationData : [InvitationModel] = [InvitationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "CustomNotificationTVC", bundle: nil), forCellReuseIdentifier: "CustomNotificationTVC")
        
        if let data = AppModel.shared.INVITATION[AppModel.shared.currentUser.uID]
        {
            arrInvitationData = data
        }        
        tblView.reloadData()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundLbl.isHidden = (arrInvitationData.count > 0)
        return arrInvitationData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomNotificationTVC = tblView.dequeueReusableCell(withIdentifier: "CustomNotificationTVC") as! CustomNotificationTVC
        
        let dict = arrInvitationData[indexPath.row]
        
        let index = AppModel.shared.USERS.firstIndex { (temp) -> Bool in
            temp.uID == dict.user_id
        }
        if index != nil
        {
            setBackgroundImage(AppModel.shared.USERS[index!].picture, btn: cell.profilePicBtn)
            cell.nameLbl.text = AppModel.shared.USERS[index!].name
        }
        cell.subTitleLbl.text = dict.title
        cell.contentView.alpha = 0
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
