//
//  MatchViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/16/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class EditableMatchProfileView : UIView, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var tableView: UITableView
    var tw = C.w * 0.8
    var th = C.h * 0.8
    var user = User()
    var type = 0
    let editButton = UIButton(type: UIButtonType.custom) as UIButton
    let logoutButton = UIButton(type: UIButtonType.custom) as UIButton
    var friendsCollectionView: UICollectionView!
    var statusTextView: UITextView!
    var nameTextField: UITextField!
    var ageTextField: UITextField!
    var parentPV: MatchProfileView!
    var profileImageView: UIImageView!
    var bioTextView: UITextView!
    var picChanged = 0
    
    convenience init (user: User, t: Int, pv: MatchProfileView)
    {
        self.init(frame: CGRect(x: 0, y: 0, width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3))
        self.user = user
        self.parentPV = pv
        self.type = t
    }
    
    override init (frame : CGRect) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame : frame)
        
        self.layer.borderWidth = 1.0 as CGFloat
        self.layer.borderColor = C.goldishColor.cgColor
        self.tableView.backgroundColor = UIColor.white
        tableView.allowsSelection = false;
        self.tableView.separatorColor = C.goldishColor
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 3 + self.type
        if self.type == 1
        {
            rows -= self.user.business
        }
        return rows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        
        if indexPath.row == 0
        {
            profileImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: tw, height: tw))
            profileImageView.image = self.user.image
            let view = UIView(frame: profileImageView.frame)
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: tw, height: tw)
            gradient.locations = [0.6, 1.0]
            gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
            profileImageView.addSubview(view)
            view.layer.insertSublayer(gradient, at: 0)
            cell.addSubview(profileImageView)
            
            if type == 1
            {
                let acceptButton = UIButton(type: UIButtonType.custom) as UIButton
                acceptButton.frame = CGRect(x: tw*0.85, y: th*0.75, width: tw * 0.1, height: tw * 0.1)
                acceptButton.setImage(UIImage(named: "accept"), for: .normal)
                acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
                self.addSubview(acceptButton)
                
                let denyButton   = UIButton(type: UIButtonType.custom) as UIButton
                denyButton.frame = CGRect(x: tw*0.05, y: th*0.75, width: tw * 0.1, height: tw * 0.1)
                //denyButton.setImage(UIImage(named: "settingsIcon"), for: .normal)
                denyButton.setImage(UIImage(named: "deny"), for: .normal)
                denyButton.addTarget(self, action: #selector(deny), for: .touchUpInside)
                self.addSubview(denyButton)
            }
            
            
            nameTextField = UITextField(frame: CGRect(x: tw*0.02, y: tw*0.8, width: tw * 0.48, height: tw * 0.1))
            nameTextField.font = UIFont(name: "FuturaPT-Light", size: 28.0)
            nameTextField.text = self.user.name.lowercased()
            nameTextField.keyboardType = UIKeyboardType.default
            nameTextField.returnKeyType = UIReturnKeyType.done
            nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            nameTextField.autocorrectionType = UITextAutocorrectionType.no
            nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            nameTextField.delegate = self
            nameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            nameTextField.borderStyle = UITextBorderStyle.roundedRect
            nameTextField.autocapitalizationType = .none
            cell.addSubview(nameTextField)
            
            let ageLabel = UILabel(frame: CGRect(x: tw*0.05, y: tw*0.925, width: tw * 0.2, height: tw * 0.05))
            ageLabel.textColor = C.blueishColor
            ageLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
            ageLabel.text = "\(self.user.age!)"
            
            let ageWordLabel = UILabel(frame: CGRect(x: tw*0.07 + ageLabel.intrinsicContentSize.width, y: tw*0.925, width: tw * 0.2, height: tw * 0.05))
            ageWordLabel.textColor = .black
            ageWordLabel.font = UIFont(name: "FuturaPT-Light", size: 14.0)
            ageWordLabel.text = "years"
            if type != -1 && user.business == 0
            {
                cell.addSubview(ageLabel)
                cell.addSubview(ageWordLabel)
            }
            else
            {
                nameTextField.frame = CGRect(x: tw*0.02, y: tw*0.8, width: tw * 0.48, height: tw * 0.2)
            }
            
            let changePicButton = UIButton(type: UIButtonType.custom) as UIButton
            changePicButton.frame = CGRect(x: tw*0.85, y: tw*0.8, width: tw * 0.1, height: tw * 0.1)
            changePicButton.setImage(UIImage(named: "brush"), for: .normal)
            changePicButton.addTarget(self, action: #selector(changePic), for: UIControlEvents.touchUpInside)
            cell.addSubview(changePicButton)
            
        }
        else if indexPath.row == 1 && (self.type != -1 && self.user.business != 1)
        {
            let numFriendsLabel = UILabel(frame: CGRect(x: 0, y: th*0.025, width: tw * 0.14, height: th * 0.05))
            numFriendsLabel.numberOfLines = 0
            numFriendsLabel.baselineAdjustment = .alignCenters
            numFriendsLabel.textColor = C.blueishColor
            numFriendsLabel.textAlignment = .right
            numFriendsLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            numFriendsLabel.text = "\(self.user.friends.count)"
            cell.addSubview(numFriendsLabel)
            
            let friendsLabel = UILabel(frame: CGRect(x: tw*0.16, y: th*0.025, width: tw * 0.18, height: th * 0.05))
            friendsLabel.baselineAdjustment = .alignCenters
            friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 8.0)
            if type == 0
            {
                friendsLabel.numberOfLines = 2
                friendsLabel.text = "friends in common"
            }
            else if type == 1
            {
                friendsLabel.text = "friends"
            }
            cell.addSubview(friendsLabel)
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: tw*0.025, bottom: 0, right: tw*0.025)
            flowLayout.itemSize = CGSize(width: th * 0.06, height: th*0.06)
            friendsCollectionView = UICollectionView(frame: CGRect(x: tw * 0.25, y: th*0.02, width: tw * 0.7, height: th * 0.06), collectionViewLayout: flowLayout)
            friendsCollectionView.backgroundColor = .white
            friendsCollectionView.showsHorizontalScrollIndicator = false
            self.friendsCollectionView.delegate = self;
            self.friendsCollectionView.dataSource = self;
            cell.addSubview(self.friendsCollectionView)
            self.friendsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        }
        else if (indexPath.row == 2 && (self.type != -1 && self.user.business != 1)) || indexPath.row == 1
        {
            let whoIAmLabel = UILabel(frame: CGRect(x: tw*0.05, y: th*0.01, width: tw*0.35, height: th*0.03))
            whoIAmLabel.textColor = UIColor.black
            whoIAmLabel.text = "bio"
            whoIAmLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
            cell.addSubview(whoIAmLabel)
            
            
            bioTextView = UITextView(frame: CGRect(x: tw*0.05, y: th*0.03, width: tw*0.9, height: th*0.1))
            bioTextView.backgroundColor = .clear
            bioTextView.textColor = C.blueishColor
            bioTextView.font = UIFont(name: "FuturaPT-Light", size: 14)
            bioTextView.delegate = self
            bioTextView.text = self.user.bio
            bioTextView.keyboardType = UIKeyboardType.default
            bioTextView.returnKeyType = UIReturnKeyType.done
            bioTextView.autocorrectionType = UITextAutocorrectionType.no
            
            
            if user.business == 1
            {
                whoIAmLabel.text = "menu"
                bioTextView.frame = CGRect(x: tw*0.05, y: th*0.03, width: tw*0.9, height: th*0.24)
            }
            cell.addSubview(bioTextView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return tw
        }
        if indexPath.row == 1 && (type != -1 && user.business == 0)
        {
            return C.h * 0.1 * 0.8
        }
        else if indexPath.row == 1
        {
            return C.h * 0.3 * 0.8
        }
        else
        {
            return C.h * 0.15 * 0.8
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return th*0.5
        }
        else
        {
            return th*0.15
        }
    }
    
    @objc func accept()
    {
        if picChanged == 1
        {
            C.user.image = self.profileImageView.image!
            self.uploadProfilePicture(ref: C.refid)
        }
        if C.user.bio != self.bioTextView.text || C.user.name != self.nameTextField.text
        {
            C.user.bio = self.bioTextView.text
            C.user.name = self.nameTextField.text
            C.db.collection(C.userInfo).document(C.refid).updateData(
                ["bio": self.bioTextView.text,
                    "name": self.nameTextField.text])
        }
        self.parentPV.tableView.reloadData()
        self.removeFromSuperview()
    }
    
    @objc func deny()
    {
        self.parentPV.isHidden = false
        self.removeFromSuperview()
    }
    
    @objc func changePic() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.parentViewController?.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            //profileImageView.frame = CGRect(x: cw*0.5 - ch * 0.15, y: ch*0.15, width: ch*0.3, height: ch*0.3)
            profileImageView.image = C.resizeImage(image: pickedImage, newWidth: 750)
            picChanged = 1
        }
        
        parentViewController!.dismiss(animated: true, completion: nil)
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
}


extension EditableMatchProfileView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.user.friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) //as! CustomCell
        cell.frame = CGRect(x: cell.frame.minX, y: 0, width: th * 0.6, height: th * 0.6)
        
        let friendImage = UIImageView(frame:CGRect(x: 0, y: 0, width: th * 0.06, height: th * 0.06))
        friendImage.layer.cornerRadius = friendImage.frame.size.width / 2;
        friendImage.clipsToBounds = true;
        friendImage.image = self.user.friends[indexPath.section].image
        cell.addSubview(friendImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isHidden = true
        let f = C.user.friends[indexPath.section]
        for a in C.navigationViewController.mapViewController.mapView.annotations!
        {
            if a.isKind(of: MapAnnotation.self) && f.id == (a as! MapAnnotation).user.id
            {
                for a in C.navigationViewController.mapViewController.mapView.selectedAnnotations
                {
                    C.navigationViewController.mapViewController.mapView.deselectAnnotation(a, animated: false)
                }
                C.navigationViewController.mapViewController.mapView.setCenter(CLLocationCoordinate2D(latitude: a.coordinate.latitude, longitude: a.coordinate.longitude), animated: true)
                return
            }
        }
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        self.parentPV.center = CGPoint(x: C.w * 0.5, y: C.h * 0.325)
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        self.parentPV.center = CGPoint(x: C.w * 0.5, y: C.h * 0.5)
    }
    
}

extension EditableMatchProfileView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if(text == "\n") {
            self.bioTextView.resignFirstResponder()
        }
        return numberOfChars < 50;
    }
}

extension EditableMatchProfileView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


