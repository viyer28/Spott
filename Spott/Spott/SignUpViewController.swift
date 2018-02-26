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
class SignUpViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var emailField: UITextField!
    var nameField: UITextField!
    var passwordField: UITextField!
    var rePasswordField: UITextField!
    var majorField: UITextField!
    var genderField: UITextField!
    var whoField1: UITextField!
    var whoField2: UITextField!
    var whoField3: UITextField!
    var whatField1: UITextField!
    var whatField2: UITextField!
    var whatField3: UITextField!
    var ch: CGFloat!
    var cw: CGFloat!
    var profileImageView: UIImageView!
    var majors = ["Computer Science", "Economics"]
    override func viewDidLoad() {
        super.viewDidLoad()
        ch = self.tableView.frame.height
        cw = self.tableView.frame.width
        tableView.allowsSelection = false;
        self.tableView.backgroundColor = C.darkColor
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
        whatField1 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.06, width: cw*0.4, height: ch*0.04));
        whatField2 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.12, width: cw*0.4, height: ch*0.04));
        whatField3 = UITextField(frame:CGRect(x: cw*0.05, y: ch*0.18, width: cw*0.4, height: ch*0.04));
        whoField1 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.06, width: cw*0.4, height: ch*0.04))
        whoField2 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.12, width: cw*0.4, height: ch*0.04));
        whoField3 = UITextField(frame:CGRect(x: cw*0.55, y: ch*0.18, width: cw*0.4, height: ch*0.04));
        majorField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
        profileImageView = UIImageView(frame: CGRect(x: cw*0.5 - ch * 0.15, y: ch*0.15, width: ch*0.3, height: ch*0.3))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        cell.backgroundView?.backgroundColor = C.darkColor
        cell.backgroundColor = C.darkColor
        if indexPath.row == 0
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.25, y: ch*0.01, width: cw * 0.5, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 32.0)
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            titleLabel.text="Sign Up"
            cell.addSubview(titleLabel)
            
            let backButton = UIButton(frame: CGRect(x: cw*0.05, y: ch*0.01, width: cw * 0.2, height: ch*0.08))
            backButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            backButton.titleLabel?.text = "back"
            backButton.setTitleColor(C.goldishColor, for: .normal)
            backButton.setTitle("back", for: .normal)
            backButton.addTarget(self, action: #selector(backClick), for: UIControlEvents.touchUpInside)
            
            cell.addSubview(backButton)
        }
        if indexPath.row == 1
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.1, y: ch*0.01, width: cw * 0.18, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = UIColor.white
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
            cell.addSubview(nameField)
          
        }
        if indexPath.row == 2
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.1, y: ch*0.01, width: cw * 0.18, height: ch * 0.08))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = UIColor.white
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
            cell.addSubview(emailField)
            
        }
        else if indexPath.row == 3
        {
            let title1Label = UILabel(frame: CGRect(x: 0, y: ch*0.01, width: cw * 0.28, height: ch * 0.08))
            title1Label.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            title1Label.textAlignment = .right
            title1Label.textColor = UIColor.white
            title1Label.text="Password:"
            cell.addSubview(title1Label)
            
            passwordField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            passwordField.keyboardType = UIKeyboardType.default
            passwordField.returnKeyType = UIReturnKeyType.done
            passwordField.clearButtonMode = UITextFieldViewMode.whileEditing;
            passwordField.placeholder = "Enter your password"
            passwordField.backgroundColor = UIColor.white
            passwordField.borderStyle = UITextBorderStyle.roundedRect
            passwordField.delegate = self
            passwordField.isSecureTextEntry = true
            passwordField.tintColor = UIColor.black
            passwordField.autocapitalizationType = .none
            cell.addSubview(passwordField)
            
            let title2Label = UILabel(frame: CGRect(x: 0, y: ch*0.11, width: cw * 0.28, height: ch * 0.08))
            title2Label.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            title2Label.textAlignment = .right
            title2Label.textColor = UIColor.white
            title2Label.text="Reenter:"
            cell.addSubview(title2Label)
            
            rePasswordField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            rePasswordField.keyboardType = UIKeyboardType.default
            rePasswordField.returnKeyType = UIReturnKeyType.done
            rePasswordField.clearButtonMode = UITextFieldViewMode.whileEditing;
            rePasswordField.placeholder = "Enter your password again"
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
            titleLabel.textColor = UIColor.white
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
            
            cell.addSubview(majorField)
        }
        else if indexPath.row == 5
        {
            let genderLabel = UILabel(frame: CGRect(x: 0, y: ch*0.01, width: cw * 0.28, height: ch * 0.08))
            genderLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            genderLabel.textColor = UIColor.white
            genderLabel.text="Gender:"
            genderLabel.textAlignment = .right
            cell.addSubview(genderLabel)
            
            genderField = UITextField(frame:CGRect(x: cw*0.3, y: ch*0.025, width: cw*0.6, height: ch*0.05));
            genderField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            genderField.returnKeyType = UIReturnKeyType.done
            genderField.text = "None"
            genderField.tintColor = .clear
            genderField.delegate = self
            genderField.backgroundColor = UIColor.white
            genderField.borderStyle = UITextBorderStyle.roundedRect
            
            let pickerView = SignUpPickerView(frame: CGRect.zero, field:genderField, type: 2)
            genderField.inputView = pickerView
            
            cell.addSubview(genderField)
        }
        else if indexPath.row == 6
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.25, y: ch*0.01, width: cw * 0.5, height: ch * 0.06))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            titleLabel.textColor = UIColor.white
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
            
            profileImageView.image = UIImage(named: "sample_prof")
            cell.addSubview(profileImageView)
            profileImageView.layer.borderWidth = 1.0 as CGFloat
            profileImageView.layer.borderColor = C.goldishColor.cgColor
        }
        else if indexPath.row == 7
        {
            let titleLabel = UILabel(frame: CGRect(x: cw*0.05, y: ch*0.01, width: cw * 0.4, height: ch * 0.04))
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            titleLabel.textColor = UIColor.white
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
            
            whatField2.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whatField2.returnKeyType = UIReturnKeyType.done
            whatField2.keyboardType = UIKeyboardType.default
            whatField2.clearButtonMode = UITextFieldViewMode.whileEditing;
            whatField2.placeholder = "Adjective 2"
            whatField2.tintColor = UIColor.black
            whatField2.delegate = self
            whatField2.backgroundColor = UIColor.white
            whatField2.borderStyle = UITextBorderStyle.roundedRect
            
            whatField3.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whatField3.returnKeyType = UIReturnKeyType.done
            whatField3.keyboardType = UIKeyboardType.default
            whatField3.clearButtonMode = UITextFieldViewMode.whileEditing;
            whatField3.placeholder = "Adjective 3"
            whatField3.tintColor = UIColor.black
            whatField3.delegate = self
            whatField3.backgroundColor = UIColor.white
            whatField3.borderStyle = UITextBorderStyle.roundedRect
            
            cell.addSubview(whatField1)
            cell.addSubview(whatField2)
            cell.addSubview(whatField3)
            
            let centerLine = UIView(frame: CGRect(x: cw*0.498, y: 0, width: cw*0.001, height: ch*0.2))
            centerLine.backgroundColor = C.goldishColor
            cell.addSubview(centerLine)
            
            let titleLabel2 = UILabel(frame: CGRect(x: cw*0.55, y: ch*0.01, width: cw * 0.4, height: ch * 0.04))
            titleLabel2.font = UIFont(name: "FuturaPT-Light", size: 16.0)
            titleLabel2.textColor = UIColor.white
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
            
            whoField2.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whoField2.returnKeyType = UIReturnKeyType.done
            whoField2.keyboardType = UIKeyboardType.default
            whoField2.clearButtonMode = UITextFieldViewMode.whileEditing;
            whoField2.placeholder = "Activity 2"
            whoField2.tintColor = UIColor.black
            whoField2.delegate = self
            whoField2.backgroundColor = UIColor.white
            whoField2.borderStyle = UITextBorderStyle.roundedRect
            
            whoField3.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            whoField3.returnKeyType = UIReturnKeyType.done
            whoField3.keyboardType = UIKeyboardType.default
            whoField3.clearButtonMode = UITextFieldViewMode.whileEditing;
            whoField3.placeholder = "Activity 3"
            whoField3.tintColor = UIColor.black
            whoField3.delegate = self
            whoField3.backgroundColor = UIColor.white
            whoField3.borderStyle = UITextBorderStyle.roundedRect
            
            cell.addSubview(whoField1)
            cell.addSubview(whoField2)
            cell.addSubview(whoField3)
            
        }
        else if indexPath.row == 8
        {
            let signUpButton = UIButton(type: .system)
            signUpButton.frame = cell.frame
            signUpButton.backgroundColor = C.goldishColor
            signUpButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            signUpButton.titleLabel?.text = "Create Account"
            signUpButton.setTitleColor(C.darkColor, for: .normal)
            signUpButton.setTitle("Create Account", for: .normal)
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
        if indexPath.row == 7
        {
            return ch*0.25
        }
        if indexPath.row == 6
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
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
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Name must be at least 3 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if emailField.text?.count as Int! == 0 {
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Email field is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if (emailField.text as String!).index(of: "@") == nil
        {
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Email must be a uchicago email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if emailField.text?[(emailField.text as String!).index(of: "@")!...] != "@uchicago.edu" {
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Email must be a uchicago email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if passwordField.text?.count as Int! < 7 {
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Pasword must be at least 7 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if passwordField.text?.count as Int! != passwordField.text?.count as Int! {
            let alert = UIAlertController(title: "Cannot Sign Up", message: "Paswords do not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
//        else if whoField1.text?.count == 0 || whoField2.text?.count == 0 || whoField3.text?.count == 0
//        {
//            let alert = UIAlertController(title: "Cannot Sign Up", message: "Must pick 3 adjectives to describe who you are!", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        else if whatField1.text?.count == 0 || whatField2.text?.count == 0 || whatField3.text?.count == 0
//        {
//            let alert = UIAlertController(title: "Cannot Sign Up", message: "Must pick 3 adjectives to describe who you are!", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                print("fail")
            }else{
                print("sucess")
            }
        print("YAY")
        })
        
}
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }


}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
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
            return newLength <= 16
        }
    }
    
}

class SignUpPickerView : UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var majors = ["Computer Science", "Economics"]
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

