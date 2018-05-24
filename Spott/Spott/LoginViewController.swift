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
class LoginViewController: UIViewController, UITextFieldDelegate {
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
        usernameLabel.text="email"
        self.view.addSubview(usernameLabel)
        
        let passwordLabel = UILabel(frame:CGRect(x: cw*0.15, y: ch*0.6, width: cw*0.5, height: ch*0.05));
        passwordLabel.textColor = C.darkColor
        passwordLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        passwordLabel.text="password"
        
        self.view.addSubview(passwordLabel)
        
        usernameField = UITextField(frame:CGRect(x: cw*0.15, y: ch*0.55, width: cw*0.7, height: ch*0.05));
        self.view.addSubview(usernameField)
        usernameField.keyboardType = UIKeyboardType.default
        usernameField.returnKeyType = UIReturnKeyType.done
        usernameField.clearButtonMode = UITextFieldViewMode.whileEditing
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        usernameField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        usernameField.placeholder = "email"
        usernameField.delegate = self
        usernameField.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        usernameField.backgroundColor = UIColor.white
        usernameField.borderStyle = UITextBorderStyle.roundedRect
        usernameField.autocapitalizationType = .none
        
        passwordField = UITextField(frame:CGRect(x: cw*0.15, y: ch*0.65, width: cw*0.7, height: ch*0.05));
        passwordField.keyboardType = UIKeyboardType.default
        passwordField.delegate = self
        passwordField.returnKeyType = UIReturnKeyType.done
        passwordField.clearButtonMode = UITextFieldViewMode.whileEditing;
        usernameField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        passwordField.placeholder = "password"
        passwordField.backgroundColor = UIColor.white
        passwordField.borderStyle = UITextBorderStyle.roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        
        let spottImg = UIImageView(frame:CGRect(x: cw * 0.5 - ch * 0.125, y: ch * 0.15, width: ch * 0.25, height: ch * 0.25))
        spottImg.contentMode = .scaleAspectFit
        spottImg.image = UIImage(named: "spottOwl")
        self.view.addSubview(spottImg)
        
        let betaImg = UIImageView(frame:CGRect(x: C.w*0.5-ch*0.03*640.0/176.0 / 2.0, y: ch * 0.4, width: ch*0.03*640.0/176.0, height: ch*0.03))
        betaImg.image = UIImage(named: "betaImage")
        self.view.addSubview(betaImg)
        
        let button = UIButton(type: .system) // let preferred over var here
        button.frame = CGRect(x: cw*0.25, y: ch*0.72, width: cw*0.5, height: ch*0.05)
        button.layer.cornerRadius = button.frame.size.width / 10;
        button.backgroundColor = C.goldishColor
        button.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        button.titleLabel?.text = "login"
        button.setTitleColor(C.darkColor, for: .normal)
        button.setTitle("log in", for: .normal)
        button.addTarget(self, action: #selector(login), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        
        let rbutton = UIButton(type: .system) // let preferred over var here
        rbutton.frame = CGRect(x: cw*0.25, y: ch*0.80, width: cw*0.5, height: ch*0.05)
        rbutton.layer.cornerRadius = button.frame.size.width / 10;
        rbutton.backgroundColor = C.goldishColor
        rbutton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        rbutton.titleLabel?.text = "sign up"
        rbutton.setTitleColor(C.darkColor, for: .normal)
        rbutton.setTitle("sign up", for: .normal)
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
                let alert = UIAlertController(title: "Login Failed", message: "Could not login with email and password combination.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
    func loginSuccess()
    {
        if (Auth.auth().currentUser != nil)
        {
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("Recieved documents")
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        C.refid = document.documentID
                        C.userData = document.data()
                        C.updateUser()
                        C.updateLocations()
                        //C.addUserListener()
                        
                        let con = NavigationViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                           navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
                                                           options: nil)
                        C.navigationViewController = con
                        
                        C.profileViewController = ProfileViewController()
                        
                        //initialViewController.view.backgroundColor = C.darkColor
                        self.present(C.navigationViewController, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -216, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -216, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    @objc func signup()
    {
        self.dismiss(animated: false, completion: nil)
    }
}


