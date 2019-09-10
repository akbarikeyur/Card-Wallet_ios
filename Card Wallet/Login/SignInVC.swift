//
//  SignInVC.swift
//  Card Wallet
//
//  Created by Keyur on 12/07/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed == "" {
            displayToast("Please enter email.")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("Invalid email.")
        }
        else if passwordTxt.text?.trimmed == "" {
            displayToast("Please enter password.")
        }
        else {
            loginToFirebase(emailTxt.text!, passwordTxt.text!)
        }
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        let vc : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
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
