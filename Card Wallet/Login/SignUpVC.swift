//
//  SignUpVC.swift
//  Card Wallet
//
//  Created by Keyur on 12/07/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class SignUpVC: UploadImageVC {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    
    var profileImg : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickToProfilePicBtn(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        self.view.endEditing(true)
        if profileImg == nil {
            displayToast("Please select profile picture.")
        }
        else if nameTxt.text?.trimmed == "" {
            displayToast("Please enter your name.")
        }
        else if emailTxt.text?.trimmed == "" {
            displayToast("Please enter email.")
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast("Invalid email.")
        }
        else if passwordTxt.text?.trimmed == "" {
            displayToast("Please enter password.")
        }
        else {
            createAccountToFirebase(emailTxt.text!, passwordTxt.text!, nameTxt.text!, profileImg!)
        }
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func selectedImage(choosenImage: UIImage) {
        profilePicBtn.setBackgroundImage(choosenImage, for: .normal)
        profileImg = choosenImage
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
