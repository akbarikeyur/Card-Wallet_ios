//
//  MyCardVC.swift
//  Card Wallet
//
//  Created by Keyur on 13/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class MyCardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: Label!
    
    var arrCardData : [CardModel] = [CardModel]()
    var isFavCard : Bool = false
    let displayCard : CardDisplayView = CardDisplayView.instanceFromNib() as! CardDisplayView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(getMyCardData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getMyCardData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_USER_DATA), object: nil)
        tblView.register(UINib.init(nibName: "CustomCardTVC", bundle: nil), forCellReuseIdentifier: "CustomCardTVC")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        if isFavCard
        {
            getMyFavoriteCardData()
        }
        else
        {
            getMyCardData()
        }
    }
    
    @objc func getMyCardData()
    {
        if isFavCard
        {
            return
        }
        for tempCard in AppModel.shared.currentUser.myCard
        {
            let index = AppModel.shared.CARDS.firstIndex { (temp) -> Bool in
                temp.card_id == tempCard
            }
            if index != nil
            {
                arrCardData.append(AppModel.shared.CARDS[index!])
            }
        }
        tblView.reloadData()
    }
    
    @objc func getMyFavoriteCardData()
    {
        var removedCard : [String] = [String]()
        for tempCard in AppModel.shared.currentUser.favCard
        {
            let index = AppModel.shared.CARDS.firstIndex { (temp) -> Bool in
                temp.card_id == tempCard
            }
            if index != nil
            {
                arrCardData.append(AppModel.shared.CARDS[index!])
            }
            else
            {
                removedCard.append(tempCard)
            }
        }
        tblView.reloadData()
        
        if removedCard.count > 0
        {
            for temp in removedCard
            {
                guard let index = AppModel.shared.currentUser.favCard.firstIndex(of: temp) else {return}
                AppModel.shared.currentUser.favCard.remove(at: index)
            }
            updateCurrentUserData()
        }
    }
    
    
    //MARK:- Button click event
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddCard(_ sender: Any) {
        self.view.endEditing(true)
        let vc : AddCardVC = STORYBOARD.CARD.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundLbl.isHidden = (arrCardData.count > 0)
        return arrCardData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCardTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCardTVC") as! CustomCardTVC
        
        let card = arrCardData[indexPath.row]
        cell.nameLbl.text = card.company_name
        cell.userNameLbl.text = card.name
        cell.contactLbl.text = card.contact
        cell.addressLbl.text = card.address
        cell.outerView.backgroundColor = getColorFromHashKey(card.category)
        
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
                displayCard.card = AppModel.shared.CARDS[indexPath.row]
                displayCard.setup()
            }
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
