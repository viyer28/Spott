//
//  ViewController.swift
//  mark1
//
//  Created by Varun Iyer on 12/19/17.
//  Copyright © 2017 Spott. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton : FBSDKLoginButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ([FBSDKAccessToken currentAccessToken]){
            // User is logged in, do work such as go to next view controller.
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User has cancelled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: {(connection, result, error) in
                        if error != nil {
                            print(error!)
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
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("FB logged out.")
    }
}

