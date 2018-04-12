//
//  SignUpViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/22/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
class SettingsViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var emailField: UITextField!
    var nameField: UITextField!
    var passwordField: UITextField!
    var rePasswordField: UITextField!
    var majorField: UITextField!
    var ageField: UITextField!
    var whoField1: UITextField!
    var whoField2: UITextField!
    var whoField3: UITextField!
    var homeField: UITextField!
    var whatField1: UITextField!
    var whatField2: UITextField!
    var whatField3: UITextField!
    var ch: CGFloat!
    var changedPic = 0
    var cw: CGFloat!
    var dateFormate = Bool()
    var profileImageView: UIImageView!
    var majors = ["Computer Science", "Economics"]
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        ch = self.tableView.frame.height
        cw = self.tableView.frame.width
        tableView.allowsSelection = false;
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = C.goldishColor
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.rowHeight = C.h*0.5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        nameField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        emailField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        passwordField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        rePasswordField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.125, width: cw*0.6, height: ch*0.05));
        majorField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        whatField1 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.06, width: cw*0.4, height: ch*0.04));
        whatField2 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.12, width: cw*0.4, height: ch*0.04));
        whatField3 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.18, width: cw*0.4, height: ch*0.04));
        whoField1 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.06, width: cw*0.4, height: ch*0.04))
        whoField2 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.12, width: cw*0.4, height: ch*0.04));
        whoField3 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.18, width: cw*0.4, height: ch*0.04));
        profileImageView = UIImageView(frame: CGRect(x: cw*0.5 - ch * 0.15, y: ch*0.15, width: ch*0.3, height: ch*0.3))
        homeField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        ageField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changedPic = 0
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        cell.backgroundView?.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        if indexPath.row == 0
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.25, y: ch*0.01, width: cw * 0.5, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            titleLabel.textAlignment = .center
            titleLabel.textColor = C.darkColor
            titleLabel.text="Account Info"
            cell.addSubview(titleLabel)
            
            let backButton = UIButton(frame: CGRect(x: cw*0.05, y: ch*0.01, width: cw * 0.2, height: ch*0.08))
            backButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 28.0)
            backButton.titleLabel?.text = "<"
            backButton.setTitleColor(C.goldishColor, for: .normal)
            backButton.setTitle("<", for: .normal)
            backButton.addTarget(self, action: #selector(backClick), for: UIControlEvents.touchUpInside)
            
            let logoutButton = UIButton(frame: CGRect(x: cw*0.75, y: ch*0.01, width: cw * 0.2, height: ch*0.08))
            logoutButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            logoutButton.titleLabel?.text = "Logout"
            logoutButton.setTitleColor(C.goldishColor, for: .normal)
            logoutButton.setTitle("Logout", for: .normal)
            logoutButton.addTarget(self, action: #selector(logoutClick), for: UIControlEvents.touchUpInside)
            
            cell.addSubview(backButton)
            cell.addSubview(logoutButton)
        }
        if indexPath.row == 1
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.1, y: ch*0.01, width: cw * 0.18, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = C.darkColor
            titleLabel.text="Name:"
            titleLabel.textAlignment = .right
            cell.addSubview(titleLabel)
            
            nameField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            nameField.keyboardType = UIKeyboardType.default
            nameField.returnKeyType = UIReturnKeyType.done
            nameField.clearButtonMode = UITextFieldViewMode.whileEditing;
            nameField.placeholder = "Enter your name"
            nameField.backgroundColor = UIColor.white
            nameField.borderStyle = UITextBorderStyle.roundedRect
            nameField.tintColor = UIColor.black
            nameField.text = C.user.name
            cell.addSubview(nameField)
            
        }
        if indexPath.row == 2
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.1, y: ch*0.01, width: cw * 0.18, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = C.darkColor
            titleLabel.text="Email:"
            titleLabel.textAlignment = .right
            cell.addSubview(titleLabel)
            
            emailField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            emailField.keyboardType = UIKeyboardType.default
            emailField.returnKeyType = UIReturnKeyType.done
            emailField.clearButtonMode = UITextFieldViewMode.whileEditing;
            emailField.placeholder = "Enter your email"
            emailField.backgroundColor = UIColor.white
            emailField.tintColor = UIColor.black
            emailField.borderStyle = UITextBorderStyle.roundedRect
            emailField.autocapitalizationType = .none
            emailField.text = Auth.auth().currentUser?.email
            cell.addSubview(emailField)
            
        }
        else if indexPath.row == 3
        {
            let title1Label = UILabel(frame: CGRect(x: 0, y: ch*0.01, width: cw * 0.28, height: ch * 0.08))
            title1Label.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            title1Label.textAlignment = .right
            title1Label.textColor = C.darkColor
            title1Label.text="Password:"
            cell.addSubview(title1Label)
            
            passwordField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            passwordField.keyboardType = UIKeyboardType.default
            passwordField.returnKeyType = UIReturnKeyType.done
            passwordField.clearButtonMode = UITextFieldViewMode.whileEditing;
            passwordField.placeholder = "Changing your password is disabled"
            passwordField.backgroundColor = UIColor.white
            passwordField.borderStyle = UITextBorderStyle.roundedRect
            passwordField.delegate = self
            passwordField.isSecureTextEntry = true
            passwordField.tintColor = UIColor.black
            passwordField.autocapitalizationType = .none
            passwordField.tintColor = .clear
            cell.addSubview(passwordField)
            
            let title2Label = UILabel(frame: CGRect(x: 0, y: ch*0.11, width: cw * 0.28, height: ch * 0.08))
            title2Label.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            title2Label.textAlignment = .right
            title2Label.textColor = C.darkColor
            title2Label.text="Reenter:"
            cell.addSubview(title2Label)
            
            rePasswordField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            rePasswordField.keyboardType = UIKeyboardType.default
            rePasswordField.returnKeyType = UIReturnKeyType.done
            rePasswordField.tintColor = .clear
            rePasswordField.clearButtonMode = UITextFieldViewMode.whileEditing;
            rePasswordField.placeholder = "Changing your password is disabled"
            rePasswordField.backgroundColor = UIColor.white
            rePasswordField.delegate = self
            rePasswordField.tintColor = UIColor.black
            rePasswordField.borderStyle = UITextBorderStyle.roundedRect
            rePasswordField.isSecureTextEntry = true
            rePasswordField.autocapitalizationType = .none
            cell.addSubview(rePasswordField)
        }
        else if indexPath.row == 4
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.1, y: ch*0.01, width: cw * 0.18, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = C.darkColor
            titleLabel.text="Major:"
            titleLabel.textAlignment = .right
            cell.addSubview(titleLabel)
            
            majorField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            majorField.returnKeyType = UIReturnKeyType.done
            majorField.placeholder = "Select your major"
            majorField.text = "Undecided"
            majorField.backgroundColor = UIColor.white
            majorField.borderStyle = UITextBorderStyle.roundedRect
            let pickerView = SignUpPickerView(frame: CGRect.zero, field:majorField, type: 1)
            majorField.tintColor = .clear
            majorField.delegate = self
            majorField.inputView = pickerView
            majorField.text = C.user.major
            
            cell.addSubview(majorField)
        }
        else if indexPath.row == 5
        {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: ch*0.01, width: cw * 0.28, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textAlignment = .right
            titleLabel.textColor = C.darkColor
            titleLabel.text="Hometown:"
            cell.addSubview(titleLabel)
            
            homeField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            homeField.keyboardType = UIKeyboardType.default
            homeField.returnKeyType = UIReturnKeyType.done
            homeField.clearButtonMode = UITextFieldViewMode.whileEditing;
            homeField.placeholder = "Enter your hometown"
            homeField.backgroundColor = UIColor.white
            homeField.tintColor = UIColor.black
            homeField.borderStyle = UITextBorderStyle.roundedRect
            homeField.autocapitalizationType = .none
            homeField.text = C.user.hometown
            
            cell.addSubview(homeField)
        }
        else if indexPath.row == 6
        {
            let ageLabel = UILabel(frame: CGRect(x: 0, y: ch*0.01, width: cw * 0.28, height: ch * 0.08))
            ageLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            ageLabel.textColor = C.darkColor
            ageLabel.text="DOB:"
            ageLabel.textAlignment = .right
            cell.addSubview(ageLabel)
            
            ageField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
            ageField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            ageField.returnKeyType = UIReturnKeyType.done
            ageField.tintColor = .black
            ageField.delegate = self
            ageField.text = C.user.dob
            ageField.backgroundColor = UIColor.white
            ageField.borderStyle = UITextBorderStyle.roundedRect
            ageField.tag = 1
            
            cell.addSubview(ageField)
        }
        else if indexPath.row == 7
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.25, y: ch*0.01, width: cw * 0.5, height: ch * 0.06))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = C.darkColor
            titleLabel.text="Profile Picture"
            titleLabel.textAlignment = .center
            cell.addSubview(titleLabel)
            
            let cameraButton = UIButton(type: .system)
            cameraButton.frame = CGRect(x: cw*0.075, y: ch*0.09, width: cw * 0.35, height: ch * 0.05)
            cameraButton.layer.cornerRadius = cameraButton.frame.size.width / 10;
            cameraButton.backgroundColor = C.goldishColor
            cameraButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            cameraButton.titleLabel?.text = "Camera"
            cameraButton.setTitleColor(C.darkColor, for: .normal)
            cameraButton.setTitle("Camera", for: .normal)
            cameraButton.addTarget(self, action: #selector(cameraClick), for: UIControlEvents.touchUpInside)
            cell.addSubview(cameraButton)
            
            let cameraRollButton = UIButton(type: .system)
            cameraRollButton.frame = CGRect(x: cw*0.575, y: ch*0.09, width: cw * 0.35, height: ch * 0.05)
            cameraRollButton.layer.cornerRadius = cameraButton.frame.size.width / 10;
            cameraRollButton.backgroundColor = C.goldishColor
            cameraRollButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            cameraRollButton.titleLabel?.text = "Camera Roll"
            cameraRollButton.setTitleColor(C.darkColor, for: .normal)
            cameraRollButton.setTitle("Camera Roll", for: .normal)
            cameraRollButton.addTarget(self, action: #selector(cameraRollClick), for: UIControlEvents.touchUpInside)
            cell.addSubview(cameraRollButton)
            
            if changedPic == 0
            {
                    profileImageView.image = C.user.image
            }
            cell.addSubview(profileImageView)
            profileImageView.layer.borderWidth = 1.0 as CGFloat
            profileImageView.layer.borderColor = C.goldishColor.cgColor
        }
        else if indexPath.row == 8
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.05, y: ch*0.01, width: cw * 0.4, height: ch * 0.04))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            titleLabel.textColor = C.darkColor
            titleLabel.text="Who are you?"
            titleLabel.textAlignment = .left
            cell.addSubview(titleLabel)
            
            whatField1.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whatField1.returnKeyType = UIReturnKeyType.done
            whatField1.keyboardType = UIKeyboardType.default
            whatField1.clearButtonMode = UITextFieldViewMode.whileEditing;
            whatField1.placeholder = "Adjective 1"
            whatField1.tintColor = UIColor.black
            whatField1.delegate = self
            whatField1.backgroundColor = UIColor.white
            whatField1.borderStyle = UITextBorderStyle.roundedRect
            whatField1.text = C.user.whatIDo[0]
            
            whatField2.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whatField2.returnKeyType = UIReturnKeyType.done
            whatField2.keyboardType = UIKeyboardType.default
            whatField2.clearButtonMode = UITextFieldViewMode.whileEditing;
            whatField2.placeholder = "Adjective 2"
            whatField2.tintColor = UIColor.black
            whatField2.delegate = self
            whatField2.backgroundColor = UIColor.white
            whatField2.borderStyle = UITextBorderStyle.roundedRect
            whatField2.text = C.user.whatIDo[1]
            
            whatField3.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whatField3.returnKeyType = UIReturnKeyType.done
            whatField3.keyboardType = UIKeyboardType.default
            whatField3.clearButtonMode = UITextFieldViewMode.whileEditing;
            whatField3.placeholder = "Adjective 3"
            whatField3.tintColor = UIColor.black
            whatField3.delegate = self
            whatField3.backgroundColor = UIColor.white
            whatField3.borderStyle = UITextBorderStyle.roundedRect
            whatField3.text = C.user.whatIDo[2]
            
            cell.addSubview(whatField1)
            cell.addSubview(whatField2)
            cell.addSubview(whatField3)
            
            let centerLine = UIView(frame: CGRect(x: cw*0.498, y: 0, width: cw*0.001, height: ch*0.25))
            centerLine.backgroundColor = C.goldishColor
            cell.addSubview(centerLine)
            
            let titleLabel2 = UILabel(frame: CGRect(x: cw*0.55, y: ch*0.01, width: cw * 0.4, height: ch * 0.04))
            titleLabel2.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            titleLabel2.textColor = C.darkColor
            titleLabel2.text="What do you do?"
            titleLabel2.textAlignment = .left
            cell.addSubview(titleLabel2)
            
            whoField1.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whoField1.returnKeyType = UIReturnKeyType.done
            whoField1.keyboardType = UIKeyboardType.default
            whoField1.clearButtonMode = UITextFieldViewMode.whileEditing;
            whoField1.placeholder = "Activity 1"
            whoField1.tintColor = UIColor.black
            whoField1.delegate = self
            whoField1.backgroundColor = UIColor.white
            whoField1.borderStyle = UITextBorderStyle.roundedRect
            whoField1.text = C.user.whoIam[0]
            
            whoField2.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whoField2.returnKeyType = UIReturnKeyType.done
            whoField2.keyboardType = UIKeyboardType.default
            whoField2.clearButtonMode = UITextFieldViewMode.whileEditing;
            whoField2.placeholder = "Activity 2"
            whoField2.tintColor = UIColor.black
            whoField2.delegate = self
            whoField2.backgroundColor = UIColor.white
            whoField2.borderStyle = UITextBorderStyle.roundedRect
            whoField2.text = C.user.whoIam[1]
            
            whoField3.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whoField3.returnKeyType = UIReturnKeyType.done
            whoField3.keyboardType = UIKeyboardType.default
            whoField3.clearButtonMode = UITextFieldViewMode.whileEditing;
            whoField3.placeholder = "Activity 3"
            whoField3.tintColor = UIColor.black
            whoField3.delegate = self
            whoField3.backgroundColor = UIColor.white
            whoField3.borderStyle = UITextBorderStyle.roundedRect
            whoField3.text = C.user.whoIam[2]
            
            cell.addSubview(whoField1)
            cell.addSubview(whoField2)
            cell.addSubview(whoField3)
            
        }
        else if indexPath.row == 9
        {
            let signUpButton = UIButton(type: .system)
            signUpButton.frame = cell.frame
            signUpButton.backgroundColor = C.goldishColor
            signUpButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            signUpButton.titleLabel?.text = "Update Account"
            signUpButton.setTitleColor(C.darkColor, for: .normal)
            signUpButton.setTitle("Update Account", for: .normal)
            signUpButton.addTarget(self, action: #selector(signUpClick), for: UIControlEvents.touchUpInside)
            cell.addSubview(signUpButton)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3
        {
            return ch*0.2
        }
        if indexPath.row == 8
        {
            return ch*0.25
        }
        if indexPath.row == 7
        {
            return ch*0.5
        }
        else
            
        {
            return ch*0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return ch*0.1
        }
        else
        {
            return ch*0.1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majors.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majors[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return majorField.text = majors[row]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backClick()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cameraClick() {
        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //            let imagePicker = UIImagePickerController()
        //            imagePicker.delegate = self
        //            imagePicker.sourceType = .camera;
        //            imagePicker.allowsEditing = false
        //            self.present(imagePicker, animated: true, completion: nil)
        //        }
        let alert = UIAlertController(title: "Cannot Use Camera", message: "Camera Roll Functionality is Disabled.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            //profileImageView.frame = CGRect(x: cw*0.5 - ch * 0.15, y: ch*0.15, width: ch*0.3, height: ch*0.3)
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutClick()
    {
        if Auth.auth().currentUser != nil
        {
            try! Auth.auth().signOut()
        }
        let initialViewController = LoginViewController()
        present(initialViewController, animated: false, completion: nil)
    }
    
    @objc func cameraRollClick() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @objc func signUpClick()
    {
        if nameField.text?.count as Int! < 4 {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Name must be at least 3 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if emailField.text?.count as Int! == 0 {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Email field is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if (emailField.text as String!).index(of: "@") == nil
        {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Email must be a uchicago email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if emailField.text?[(emailField.text as String!).index(of: "@")!...] != "@uchicago.edu" {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Email must be a uchicago email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
//        else if passwordField.text?.count as Int! < 7 {
//            let alert = UIAlertController(title: "Cannot Update Information", message: "Pasword must be at least 7 characters", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        else if passwordField.text?.count as Int! != passwordField.text?.count as Int! {
//            let alert = UIAlertController(title: "Cannot Update Information", message: "Paswords do not match", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        else if whoField1.text?.count == 0 || whoField2.text?.count == 0 || whoField3.text?.count == 0
        {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Must pick 3 adjectives to describe who you are!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if whatField1.text?.count == 0 || whatField2.text?.count == 0 || whatField3.text?.count == 0
        {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Must pick 3 adjectives to describe who you are!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if homeField.text?.count == 0
        {
            let alert = UIAlertController(title: "Cannot Update Information", message: "Must pick 3 adjectives to describe who you are!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if changedPic == 1
        {
            uploadProfilePicture(ref: C.refid)
        }
        
        db.collection("user_info").document(C.refid).updateData([
            "dob" : self.ageField.text!,
            "name" : self.nameField.text!,
            "who1" : self.whoField1.text!,
            "who2" : self.whoField2.text!,
            "who3" : self.whoField3.text!,
            "what1" : self.whatField1.text!,
            "hometown" : self.homeField.text!,
            "what2" : self.whatField2.text!,
            "what3" : self.whatField3.text!,
            "major" : self.majorField.text!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.updateUserData()
                }
        }
        
    }
    
    func uploadProfilePicture(ref: String)
    {
        let profileRef = C.stoRef.child("profilePictures/\(ref).jpg")
        var data = Data()
        data = UIImageJPEGRepresentation(profileImageView.image!, 0.8)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let uploadTask = profileRef.putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = "gs://"+metaData!.bucket+"/profilePictures/"+metaData!.name!
                //store downloadURL at database
                C.user.image = self.profileImageView.image!
                C.db.collection("user_info").document(C.refid).updateData(["profilePicture": downloadURL])
            }
            
        }
    }
    
    func updateUserData()
    {
        let docRef = db.collection("user_info").document(C.refid)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                C.userData = document.data()
                C.updateUser()
                //initialViewController.view.backgroundColor = C.darkColor
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 1 {
            //2. this one helps to make sure that user enters only numeric characters and '-' in fields
            let numbersOnly = CharacterSet(charactersIn: "1234567890-")
            
            let Validate = string.rangeOfCharacter(from: numbersOnly.inverted) == nil ? true : false
            if !Validate {
                return false;
            }
            if range.length + range.location > (textField.text?.characters.count)! {
                return false
            }
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            if newLength == 3 || newLength == 6 {
                let  char = string.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                
                if (isBackSpace == -92) {
                    dateFormate = false;
                }else{
                    dateFormate = true;
                }
                
                if dateFormate {
                    let textContent:String!
                    textContent = textField.text
                    //3.Here we add '-' on overself.
                    let textWithHifen:String = "\(textContent!)-" as String
                    textField.text = textWithHifen
                    dateFormate = false
                }
            }
            //4. this one helps to make sure only 8 character is added in textfield .(ie: dd-mm-yy)
            return newLength <= 8;
            
        }
        if textField.tintColor == .clear
        {
            return false
        }
        else
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 30
        }
    }
    
}

class SettingsPickerView : UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var majors =
        ["American Sign Language", "Anthropology", "Art History", "Arts", "Astronomy and Astrophysics", "Big Problems", "Biological Chemistry", "Biological Sciences", "Cancer Biology", "Cellular and Molecular Biology", "Ecology and Evolution", "Endocrinology", "Genetics", "Immunology", "Microbiology", "Neuroscience", "Chemistry", "Chicago Studies", "Cinema and Media Studies", "Classical Studies", "Language and Literature", "Language Intensive", "Greek and Roman Cultures", "Comparative Human Development", "Comparative Literature", "Comparative Race and Ethnic Studies", "Computational Neuroscience", "Computer Science", "Creative Writing", "Early Christian Literature", "East Asian Languages and Civilizations", "Chinese", "Japanese", "Korean", "Economics", "Education", "Education Profession", "English and Creative Writing", "English Language and Literature", "Environmental Science", "Environmental and Urban Studies", "Fundamentals: Issues and Texts", "Gender and Sexuality Studies", "Geographical Studies", "Geophysical Sciences", "Germanic Studies", "Health Professions", "History", "History", "Philosophy", "Social Studies of Science and Medicine", "(HIPS)", "Human Rights", "Humanities", "International Studies", "Jewish Studies", "Journalism", "Latin American Studies", "Law", "Letters", "and Society", "Linguistics", "Languages in Linguistics", "Swahili", "Mathematics", "Applied Mathematics", "Mathematics with a Specialization in Economics", "Medicine", "Medieval Studies", "Molecular Engineering", "Music", "Near Eastern Languages and Civilizations", "Near Eastern Art and Archaeology", "Near Eastern History and Civilization", "Norwegian Studies", "Philosophy", "Philosophy and Allied Fields", "Physics", "Political Science", "Psychology", "Public Policy Studies", "Public and Social Service", "Religion and the Humanities", "Religious Studies", "Romance Languages and Literatures", "Science and Technology", "Slavic Languages and Literatures", "Social Service Administration", "Sociology", "South Asian Languages and Civilizations", "Statistics", "BA/MS", "Theater and Performance Studies", "Tutorial Studies", "Visual Arts"]
    var genders = ["Male", "Female", "Other"]
    var field: UITextField!
    var type: Int!
    init(frame:CGRect, field: UITextField, type:Int) {
        super.init(frame:frame)
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = C.darkColor
        self.backgroundColor = C.darkColor
        self.tintColor = UIColor.white
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        field.inputAccessoryView = toolBar
        self.field = field
        self.type = type
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Delegates and data sources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if type == 1
        {
            return majors.count
        }
        else if type == 2
        {
            return genders.count
        }
        return majors.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if type == 1
        {
            return majors[row]
        }
        else if type == 2
        {
            return genders[row]
        }
        return majors[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if type == 1
        {
            field.text = majors[row]
        }
        else if type == 2
        {
            field.text = genders[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        self.subviews[1].backgroundColor = C.goldishColor
        self.subviews[2].backgroundColor = C.goldishColor
        var string = ""
        if type == 1
        {
            string = majors[row]
        }
        else if type == 2
        {
            string = genders[row]
        }
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    @objc func doneClick() {
        field.resignFirstResponder()
    }
    
}

