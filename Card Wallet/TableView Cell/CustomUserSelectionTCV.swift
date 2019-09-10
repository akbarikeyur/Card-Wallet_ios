//
//  CustomUserSelectionTCV.swift
//  Card Wallet
//
//  Created by Keyur on 18/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomUserSelectionTCV: UITableViewCell {

    @IBOutlet weak var outherVIew: UIView!
    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var emailLbl: Label!
    @IBOutlet weak var selectBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
