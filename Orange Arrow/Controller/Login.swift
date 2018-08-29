//
//  Login.swift
//  Orange Arrow
//
//  Created by 刘祥 on 8/7/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
//import FirebaseUI
import FBSDKLoginKit
import ValidationComponents
import Firebase
import SVProgressHUD
import GoogleSignIn

class Login: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordToLogin: UITextField!
    @IBOutlet weak var invalidMessage: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var facebookLoginBtn: FBSDKLoginButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var googleBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        facebookLoginBtn = FBSDKLoginButton()
        facebookLoginBtn.delegate = self
        facebookLoginBtn.readPermissions = ["email","public_profile"]

        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        googleBtn.style = GIDSignInButtonStyle.wide


        // Do any additional setup after loading the view.
    }
    
//    @objc func handleCus(){
//        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
//            if err != nil {
//                print("--------======------------\(err!)")
//                return
//            }
//
//            print(result!.token.tokenString)
//            self.loginWithFireBase()
//        }
//    }
    
//    func authUI(_ authUI: , didSignInWith user: User?, error: Error?) {
//        // handle user and error as necessary
//        if error != nil {
//            print("login with error \(error!)")
//        }
//
//        performSegue(withIdentifier: "gotoInfoWithEmail", sender: self)
//    }
    
    // MARK - to make return key as done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag
        {
        case 0:
            emailAddress.resignFirstResponder();
        case 1:
            passwordToLogin.resignFirstResponder();
        default:
            break
        }
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("log out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print("there is a big error for login facebook ", error)
            return
        }
        print("success")
        loginWithFireBase()
    }
    
    func loginWithFireBase() {
        print("===================start=================")
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if error != nil{
                print("there is an error with FB user \(error!)")
                return
            }
            print("successfully login with user")
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email"]).start { (connection, result, err) in
            if err != nil{
                print("failed to start graph request \(err!)")
                return
            }
            print(result ?? "")
        }
    }
    


    
    // MARK - EMAIL & PASSWORD & Facebook & Google LOGIN
    @IBAction func LoginBtnTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            // email
            
            //to check both input has value and email format is right
            
            let emailPredicate = EmailValidationPredicate()
            guard let loggedEmail = emailAddress.text, !loggedEmail.isEmpty && emailPredicate.evaluate(with: loggedEmail) else{
                self.invalidMessage.text = "Please enter correct email"
                self.invalidMessage.backgroundColor = UIColor.white
                return
            }

            guard let loggedPassword = passwordToLogin.text, !loggedPassword.isEmpty else{
                self.invalidMessage.text = "Please enter your password"
                self.invalidMessage.backgroundColor = UIColor.white
                return
            }
            
            //disable every interface
            emailAddress.isEnabled = false
            passwordToLogin.isEnabled = false
            switchBtn.isEnabled = false
            facebookLoginBtn.isEnabled = false
//            googleLoginBtn.isEnabled = false
            
            //login
            SVProgressHUD.show()

            Auth.auth().signIn(withEmail: loggedEmail, password: loggedPassword) { (user, error) in
                if error != nil{
                    print(error!)
                    self.invalidMessage.text = "Wrong Users Information!"
                    self.invalidMessage.backgroundColor = UIColor.white
                    self.emailAddress.isEnabled = true
                    self.passwordToLogin.isEnabled = true
                    self.switchBtn.isEnabled = true
                    self.facebookLoginBtn.isEnabled = true
    
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.dismiss()
                    //goto next page
                    self.performSegue(withIdentifier: "gotoInfoWithEmail", sender: self)
                }
            }
      
        }else if sender.tag == 2 {
            //google
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! Register
//        if segue.identifier == "gotoInfoWithEmail"{
//            
//            destinationVC.registerType = "Email"
//            
//        } else if segue.identifier == "gotoInfoWithFacebook"{
//            destinationVC.registerType = "Facebook"
//        }else if segue.identifier == "gotoInfoWithGoogle"{
//            destinationVC.registerType = "Google"
//        }
//    }
    
    
    
    @IBAction func rememberToLogin(_ sender: UISwitch) {
    }
    

}


