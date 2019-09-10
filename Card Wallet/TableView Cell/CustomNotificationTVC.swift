//
//  CustomNotificationTVC.swift
//  Card Wallet
//
//  Created by Keyur on 18/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomNotificationTVC: UITableViewCell {

    @IBOutlet weak var outerView: View!
    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var subTitleLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
