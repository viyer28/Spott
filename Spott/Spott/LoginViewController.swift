//
//  loginviewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/22/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {
    var usernameField: UITextField!
    var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let cw = self.view.frame.width
        let ch = self.view.frame.height
        let usernameLabel = UILabel(frame:CGRect(x: cw*0.15, y: ch*0.5, width: cw*0.5, height: ch*0.05));
        usernameLabel.textColor = C.darkColor
        usernameLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        usernameLabel.text="Email:"
        self.view.addSubview(usernameLabel)
        
        let passwordLabel = UILabel(frame:CGRect(x: cw*0.15, y: ch*0.6, width: cw*0.5, height: ch*0.05));
        passwordLabel.textColor = C.darkColor
        passwordLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        passwordLabel.text="Password:"
        
        self.view.addSubview(passwordLabel)
        
        usernameField = UITextField(frame:CGRect(x: cw*0.15, y: ch*0.55, width: cw*0.7, height: ch*0.05));
        self.view.addSubview(usernameField)
        usernameField.keyboardType = UIKeyboardType.default
        usernameField.returnKeyType = UIReturnKeyType.done
        usernameField.clearButtonMode = UITextFieldViewMode.whileEditing
        usernameField.placeholder = "Enter email"
        usernameField.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        usernameField.backgroundColor = UIColor.white
        usernameField.borderStyle = UITextBorderStyle.roundedRect
        usernameField.autocapitalizationType = .none
        
        passwordField = UITextField(frame:CGRect(x: cw*0.15, y: ch*0.65, width: cw*0.7, height: ch*0.05));
        passwordField.keyboardType = UIKeyboardType.default
        passwordField.returnKeyType = UIReturnKeyType.done
        passwordField.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordField.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        passwordField.placeholder = "Enter password"
        passwordField.backgroundColor = UIColor.white
        passwordField.borderStyle = UITextBorderStyle.roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        
        let spottImg = UIImageView(frame:CGRect(x: cw * 0.5 - ch * 0.125, y: ch * 0.15, width: ch * 0.25, height: ch*0.25))
        spottImg.image = UIImage(named: "spottIcon")
        self.view.addSubview(spottImg)
        
        let button = UIButton(type: .system) // let preferred over var here
        button.frame = CGRect(x: cw*0.25, y: ch*0.72, width: cw*0.5, height: ch*0.05)
        button.layer.cornerRadius = button.frame.size.width / 10;
        button.backgroundColor = C.goldishColor
        button.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        button.titleLabel?.text = "Login"
        button.setTitleColor(C.darkColor, for: .normal)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(login), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        
        let rbutton = UIButton(type: .system) // let preferred over var here
        rbutton.frame = CGRect(x: cw*0.25, y: ch*0.80, width: cw*0.5, height: ch*0.05)
        rbutton.layer.cornerRadius = button.frame.size.width / 10;
        rbutton.backgroundColor = C.goldishColor
        rbutton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        rbutton.titleLabel?.text = "Sign Up"
        rbutton.setTitleColor(C.darkColor, for: .normal)
        rbutton.setTitle("Signup", for: .normal)
        rbutton.addTarget(self, action: #selector(signup), for: UIControlEvents.touchUpInside)
        self.view.addSubview(rbutton)
        
        self.view.addSubview(passwordField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func login()
    {
        Auth.auth().signIn(withEmail: self.usernameField.text!, password: self.passwordField.text!) { (user, error) in
            
            if error == nil {
                self.loginSuccess()
            } else {
                print("boo")
            }
        }
    }
    func loginSuccess()
    {
        if (Auth.auth().currentUser != nil)
        {
            Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("Recieved documents")
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        C.refid = document.documentID
                        C.userData = document.data()
                        C.user.name = C.userData["name"] as! String
                        C.user.numFriends = 123
                        C.user.profilePictureURL = "sample_prof"
                        C.user.whoIam = ["Charismatic", "Chill", "Risktaking"]
                        C.user.whatIDo = ["Tennis", "Trumpet", "Skiiing"]
                        if C.userData["who1"] != nil
                        {
                            C.user.whoIam[0] = C.userData["who1"] as! String
                        }
                        if C.userData["who2"] != nil
                        {
                            C.user.whoIam[1] = C.userData["who2"] as! String
                        }
                        if C.userData["who3"] != nil
                        {
                            C.user.whoIam[2] = C.userData["who3"] as! String
                        }
                        if C.userData["what1"] != nil
                        {
                            C.user.whoIam[0] = C.userData["what1"] as! String
                        }
                        if C.userData["what2"] != nil
                        {
                            C.user.whoIam[1] = C.userData["what2"] as! String
                        }
                        if C.userData["what3"] != nil
                        {
                            C.user.whoIam[2] = C.userData["what3"] as! String
                        }
                        C.user.xp = 10000
                        C.user.level = 10
                        C.user.major = C.userData["major"] as! String
                        C.user.age = 20
                        let initialViewController = TabBarViewController()
                        //initialViewController.view.backgroundColor = C.darkColor
                        self.present(initialViewController, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    @objc func signup()
    {
        print(1)
        let nextViewController = SignUpViewController()
        self.present(nextViewController, animated: true, completion: nil)
    }
}


