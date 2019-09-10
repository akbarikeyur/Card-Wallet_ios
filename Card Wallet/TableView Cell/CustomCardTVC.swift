//
//  CustomCardTVC.swift
//  Card Wallet
//
//  Created by Keyur on 11/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomCardTVC: UITableViewCell {

    @IBOutlet weak var outerView: View!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var userNameLbl: Label!
    @IBOutlet weak var contactLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
