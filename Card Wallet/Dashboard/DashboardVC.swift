//
//  DashboardVC.swift
//  Card Wallet
//
//  Created by Keyur on 12/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: Label!
    @IBOutlet weak var searchTxt: UISearchBar!
    
    let displayCard : CardDisplayView = CardDisplayView.instanceFromNib() as! CardDisplayView
    var arrSearchData : [CardModel] = [CardModel]()
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateCardList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_USER_DATA), object: nil)
        tblView.register(UINib.init(nibName: "CustomCardTVC", bundle: nil), forCellReuseIdentifier: "CustomCardTVC")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK:- Update Card list
    @objc func updateCardList()
    {
        tblView.reloadData()
    }
    
    //MARK:- Set User Data
    @objc func setUserData()
    {
        if AppModel.shared.currentUser.picture != nil {
            setBackgroundImage(AppModel.shared.currentUser.picture, btn: profilePicBtn)
        }else{
            delay(2.0) {
                if AppModel.shared.currentUser.picture != nil {
                    setBackgroundImage(AppModel.shared.currentUser.picture, btn: self.profilePicBtn)
                }
            }
        }
    }
    
    
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func clickToProfilePicBtn(_ sender: Any) {
        
    }
    
    @IBAction func clickToFilter(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = AppModel.shared.CATEGORY
        dropDown.selectionAction = { (index: Int, item: String) in
            print(item)
            self.arrSearchData = [CardModel]()
            for temp in AppModel.shared.CARDS {
                if temp.category == item {
                    self.arrSearchData.append(temp)
                }
            }
            self.isSearch = true
            self.tblView.reloadData()
        }
        dropDown.show()
    }
    
    
    @IBAction func clickToAddCard(_ sender: Any) {
        self.view.endEditing(true)
        let vc : AddCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundLbl.isHidden = (AppModel.shared.CARDS.count > 0)
        return isSearch ? arrSearchData.count : AppModel.shared.CARDS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCardTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCardTVC") as! CustomCardTVC
        
        let card = (isSearch ? arrSearchData : AppModel.shared.CARDS)[indexPath.row]
        if card.image != ""
        {
            setImageFromUrl(card.image, img: cell.logoImg)
            cell.logoImg.layer.borderColor = colorFromHex(hex: card.color).cgColor
            cell.logoImg.layer.borderWidth = 2
        }
        cell.nameLbl.text = card.company_name
        cell.userNameLbl.text = card.name
        cell.contactLbl.text = card.contact
        cell.addressLbl.text = card.address
        cell.outerView.backgroundColor = colorFromHex(hex: card.color)
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
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tblView)
            if let indexPath = tblView.indexPathForRow(at: touchPoint) {
                
                displaySubViewtoParentView(self.view, subview: displayCard)
                displaySubViewWithScaleOutAnim(displayCard)
                displayCard.card = (isSearch ? arrSearchData : AppModel.shared.CARDS)[indexPath.row]
                displayCard.setup()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrSearchData = [CardModel]()
        //Search by Name, SR#, Grad Year
        arrSearchData = AppModel.shared.CARDS.filter({ (temp) -> Bool in
            let company_name: NSString = temp.company_name! as NSString
            let name: NSString = temp.name! as NSString
            return ((name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound) || ((company_name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
        })
        
        if arrSearchData.count > 0 {
            isSearch = true
        }else{
            isSearch = false
        }
        
        tblView.reloadData()
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
