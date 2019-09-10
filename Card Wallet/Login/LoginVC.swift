//
//  LoginVC.swift
//  Card Wallet
//
//  Created by Keyur on 11/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clickToStart(_ sender: Any) {
        let vc : SignInVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

