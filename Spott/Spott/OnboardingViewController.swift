//
//  OnboardingViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 4/5/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage

class OnboardingViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var stage = 0
    var name = ""
    var email = ""
    var textField: UITextField!
    var titleLabel: UILabel!
    var dateFormate = Bool()
    var errorLabel: UILabel!
    var password = ""
    let db = Firestore.firestore()
    var dob: String!
    var bio: String!
    var finishClicked = 0
    var dateButton: UIButton!
    var datePicker: UIDatePicker = UIDatePicker()
    var textView: UITextView!
    var profileImageView: UIImageView!
    override func viewDidLoad() {
        self.view.isUserInteractionEnabled = true
        self.view.frame = CGRect(x: 0, y: 0, width: C.w, height: C.h)
        self.view.backgroundColor = .clear
        
        
        textField = UITextField(frame:CGRect(x: C.w*0.15, y: C.h*0.55, width: C.w*0.7, height: C.h*0.05));
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.next
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.delegate = self
        textField.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocapitalizationType = .none
        self.view.addSubview(textField)
        
        
        textView = UITextView(frame:CGRect(x: C.w*0.15, y: C.h*0.55, width: C.w*0.7, height: C.h*0.1));
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = UIReturnKeyType.next
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.delegate = self
        textView.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textView.autocapitalizationType = .none
        //self.view.addSubview(textView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.3, width: C.w, height: C.h*0.2))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 30.0)
        titleLabel.text = "what's your name"
        self.view.addSubview(titleLabel)
        
        datePicker.datePickerMode = .date
        errorLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.6, width: C.w, height: C.h*0.05))
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        errorLabel.textColor = C.redishColor
        errorLabel.text = ""
        
        C.navigationViewController.mapViewController.mapView.setCenter(C.navigationViewController.userLocation.coordinate, zoomLevel: 1, animated: false)
        
        profileImageView = UIImageView(frame: CGRect(x: C.w*0.25, y: C.h * 0.5 - C.w*0.25, width: C.w * 0.5, height: C.w*0.5))
        profileImageView.image = UIImage(named: "sample_prof")
        profileImageView.layer.borderWidth = 1.0 as CGFloat
        profileImageView.layer.borderColor = C.goldishColor.cgColor
        
        datePicker.frame = CGRect(x: 0 , y: C.h * 0.7, width: C.w, height: C.h*0.3)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.maximumDate = Date()
        textField.becomeFirstResponder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDate = formatter.date(from: "1997/01/01")
        datePicker.date = someDate!
        
        
//
//
//        toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = C.darkColor
//        let doneButton = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextClick))
//        toolBar.setItems([doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
        
        //toolBar.sizeToFit()
        
        self.view.addSubview(errorLabel)
    }
    
    func moveOn()
    {
        if checkIfValid()
        {
            C.navigationViewController.mapViewController.mapView.setCenter(C.navigationViewController.userLocation.coordinate, animated: true)
            errorLabel.text = ""
            if (stage == 0)
            {
                self.name = textField.text!
                textField.text = ""
                titleLabel.text = "what's your email"
            }
            else if (stage == 1)
            {
                self.email = textField.text!
                textField.text = ""
                titleLabel.text = "what's your password"
                textField.isSecureTextEntry = true
            }
            else if stage == 2
            {
                self.password = textField.text!
                textField.text = ""
                titleLabel.text = "reenter your password"
            }
            else if stage == 3
            {
                if textField.text != password
                {
                    textField.text = ""
                    titleLabel.text = "what's your password"
                    errorLabel.text = "your passwords do not match"
                    stage = 1
                }
                else
                {
                    dateButton = UIButton(frame: CGRect(x: C.w*0.85, y: datePicker.frame.minY, width: C.w*0.15, height: C.h*0.05))
                    dateButton.setTitle("next", for: .normal)
                    dateButton.titleLabel?.text = "next"
                    dateButton.setTitleColor(C.darkColor, for: .normal)
                    dateButton.titleLabel?.font = UIFont(name:"FuturaPT-Light", size: 18.0)
                    dateButton.backgroundColor = .white
                    dateButton.layer.cornerRadius = dateButton.frame.width / 10
                    dateButton.addTarget(self, action: #selector(nextStage), for: UIControlEvents.touchUpInside)
                    textField.isSecureTextEntry = false
                    textField.isUserInteractionEnabled = false
                    textField.text = ""
                    titleLabel.text = "when were you born"
                    textField.resignFirstResponder()
                    textField.inputView = datePicker
                    self.view.addSubview(datePicker)
                    self.view.addSubview(dateButton)
                }
            }
            else if stage == 4
            {
                self.dob = textField.text!
                textField.removeFromSuperview()
                self.dateButton.removeFromSuperview()
                self.datePicker.removeFromSuperview()
                self.view.addSubview(textView)
                titleLabel.text = "tell us about yourself"
                textView.becomeFirstResponder()
            }
            else if stage == 5
            {
                self.bio = textView.text!
                
                titleLabel.center = CGPoint(x: C.w*0.5, y: C.h * 0.3)
                textView.resignFirstResponder()
                textView.removeFromSuperview()
                titleLabel.text = "finally, give us your best look"
                
                let cameraRollButton = UIButton(type: .system)
                cameraRollButton.frame = CGRect(x: C.w*0.35, y: C.h*0.5 + C.w * 0.3, width: C.w * 0.3, height: C.h * 0.05)
                cameraRollButton.layer.cornerRadius = cameraRollButton.frame.size.width / 10;
                cameraRollButton.backgroundColor = C.goldishColor
                cameraRollButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
                cameraRollButton.titleLabel?.text = "camera roll"
                cameraRollButton.setTitleColor(C.darkColor, for: .normal)
                cameraRollButton.setTitle("camera roll", for: .normal)
                cameraRollButton.addTarget(self, action: #selector(cameraRollClick), for: UIControlEvents.touchUpInside)
                self.view.addSubview(cameraRollButton)
                
                let finishButton = UIButton(type: .system)
                finishButton.frame = CGRect(x: C.w*0.35, y: C.h*0.575 + C.w * 0.3, width: C.w * 0.3, height: C.h * 0.05)
                finishButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
                finishButton.titleLabel?.text = "finish"
                finishButton.setTitleColor(C.darkColor, for: .normal)
                finishButton.setTitle("finish", for: .normal)
                finishButton.addTarget(self, action: #selector(finishClick), for: UIControlEvents.touchUpInside)
                self.view.addSubview(finishButton)
                
                self.view.addSubview(profileImageView)
            }
            stage += 1
            C.navigationViewController.mapViewController.mapView.setCenter(C.navigationViewController.userLocation.coordinate, zoomLevel: Double(1+2*stage), animated: true)
            //C.navigationViewController.mapViewController.mapView.setZoomLevel(Double(1+2*stage), animated: true)
        }
    }
    
    
    
    func checkIfValid() -> Bool
    {
        print(stage)
        if stage == 0
        {
            if textField.text!.count as Int! < 3 {
                errorLabel.text = "your name must be at least 3 characters"
                return false
            }
        }
        else if stage == 1
        {
            if textField.text?.count as Int! == 0 {
                errorLabel.text = "you must add an email"
                return false
            }
            else if (textField.text as String!).index(of: "@") == nil
            {
                errorLabel.text = "you must a valid email"
                return false
            }
            else if textField.text?[(textField.text as String!).index(of: "@")!...] != "@uchicago.edu" {
                errorLabel.text = "you must a uchicago email"
                return false
            }
        }
        else if stage == 2
        {
            if textField.text?.count as Int! < 7 {
                errorLabel.text = "your password must be at least 7 characters"
                return false
            }
        }
        else if stage == 4
        {
            if textField.text?.count as Int! == 0
            {
                errorLabel.text = "select your date of birth"
                return false
            }
        }
        else if stage == 5
        {
            if textView.text?.count as Int! == 0
            {
                errorLabel.text = "enter your bio"
                return false
            }
        }
        return true
    }
    
    @objc func nextStage() {
        moveOn()
    }
    
    @objc func finishClick()
    {
        if finishClicked == 0
        {
            finishClicked = 1
            Auth.auth().createUser(withEmail: self.email, password: self.password, completion: { (user, error) in
                if error == nil {
                    self.addUserInfo()
                }
                else{
                    self.errorLabel.text = "that email is already used."
                    self.stage = 0
                    self.finishClicked = 0
                    self.moveOn()
                    return
                }
            })
        }
        
    }
    
    func addUserInfo()
    {
        if Auth.auth().currentUser != nil
        {
            let _ = self.db.collection(C.userInfo).addDocument(data: [
                "hometown" : "",
                "name" : self.name,
                "bio" : self.bio,
                "dob" : self.dob,
                "user_id" : Auth.auth().currentUser!.uid,
                "friends" : [],
                "curLoc" : -1,
                "longitude" : 0,
                "latitude" : 0,
                "spotted" : [],
                "profilePicture" : "gs://spott-f60d4.appspot.com/profilePictures/default-profilex3.png"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Added Document succesfully")
                }
            }
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("Recieved documents")
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        C.refid = document.documentID
                        self.uploadProfilePicture(ref: document.documentID)
                        C.userData = document.data()
                        C.updateUser()
                        C.updateLocations()
                        // C.addUserListener()
                        //initialViewController.view.backgroundColor = C.darkColor
                        C.navigationViewController.finishOnboarding()
                        self.removeFromParentViewController()
                        self.view.removeFromSuperview()
                    }
                }
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
        
        let _ = profileRef.putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = "gs://"+metaData!.bucket+"/profilePictures/"+metaData!.name!
                //store downloadURL at database
                C.user.image = self.profileImageView.image!
                C.db.collection(C.userInfo).document(ref).updateData(["profilePicture": downloadURL])
            }
            
        }
    }
    
    @objc func datePickerValueChanged()
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        textField.text = selectedDate
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            //profileImageView.frame = CGRect(x: cw*0.5 - ch * 0.15, y: ch*0.15, width: ch*0.3, height: ch*0.3)
            profileImageView.image = C.resizeImage(image: pickedImage, newWidth: 750)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension OnboardingViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveOn()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 1 {
            //2. this one helps to make sure that user enters only numeric characters and '-' in fields
            let numbersOnly = CharacterSet(charactersIn: "1234567890-")
            
            let Validate = string.rangeOfCharacter(from: numbersOnly.inverted) == nil ? true : false
            if !Validate {
                return false;
            }
            if range.length + range.location > (textField.text?.count)! {
                return false
            }
            let newLength = (textField.text?.count)! + string.characters.count - range.length
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if(text == "\n") {
            moveOn()
            return false
        }
        return numberOfChars < 50;
    }
    
    
    
    
}

