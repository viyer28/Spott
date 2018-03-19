//
//  SignUpViewController.swift
//  mark1
//
//  Created by Varun Iyer on 12/20/17.
//  Copyright © 2017 Spott. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton : FBSDKLoginButton?
    
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if ([FBSDKAccessToken currentAccessToken]){
        // User is logged in, do work such as go to next view controller.
        //}
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        let buttonConstraintA = NSLayoutConstraint(item: orLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: loginButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 20)
        
        self.view.addConstraint(buttonConstraintA)
        
    }
    
    @IBAction func bottomSignUpTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    }
                })
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            self.presentAlert(alert: error.localizedDescription)
        } else if result.isCancelled {
            self.presentAlert(alert: "Login Cancelled.")
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    self.presentAlert(alert: error.localizedDescription)
                }
                // User is signed in
            }
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: {(connection, result, error) in
                        if error != nil {
                            self.presentAlert(alert: error!.localizedDescription)
                        } else {
                            if let userDetails = result {
                                print(userDetails)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
}
