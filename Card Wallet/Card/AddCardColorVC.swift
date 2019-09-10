//
//  AddCardColorVC.swift
//  Card Wallet
//
//  Created by Keyur on 14/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomColorCVC: UICollectionViewCell {
    
    @IBOutlet weak var colorBtn: Button!
}


class AddCardColorVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var colorCV: UICollectionView!
    @IBOutlet weak var addCardBtn: Button!
    
    var card : CardModel = CardModel.init()
    var cardImage : UIImage?
    var isEditCard : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "CustomCardTVC", bundle: nil), forCellReuseIdentifier: "CustomCardTVC")
        
        if isEditCard {
            addCardBtn.setTitle("Update", for: .normal)
        }
        
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddCard(_ sender: Any) {
        self.view.endEditing(true)
        addUpdateCardToFirebase(card, cardImage) { () in
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: DashboardVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    return
                }
            }
            AppDelegate().sharedDelegate().navigateToDashboard()
        }
    }
    
    //MARK:- Collectionview method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DARK_COLOR_ARRAY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomColorCVC = colorCV.dequeueReusableCell(withReuseIdentifier: "CustomColorCVC", for: indexPath) as! CustomColorCVC
        cell.colorBtn.backgroundColor = colorFromHex(hex: DARK_COLOR_ARRAY[indexPath.row])
        cell.colorBtn.isSelected = (card.color == DARK_COLOR_ARRAY[indexPath.row])
        cell.colorBtn.isUserInteractionEnabled = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colorCV.frame.size.height, height: colorCV.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        card.color = DARK_COLOR_ARRAY[indexPath.row]
        colorCV.reloadData()
        tblView.reloadData()
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCardTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCardTVC") as! CustomCardTVC
        
        if cardImage == nil
        {
            setImageFromUrl(card.image, img: cell.logoImg)
        }
        else
        {
            cell.logoImg.image = cardImage
        }        
        cell.logoImg.layer.borderColor = colorFromHex(hex: card.color).cgColor
        cell.logoImg.layer.borderWidth = 2
        cell.nameLbl.text = card.company_name
        cell.userNameLbl.text = card.name
        cell.contactLbl.text = card.contact
        cell.addressLbl.text = card.address
        cell.outerView.backgroundColor = colorFromHex(hex: card.color)
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
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
