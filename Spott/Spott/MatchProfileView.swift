//
//  MatchViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/16/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit

class MatchProfileView : UIView, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView
    var tw = C.w * 0.8
    var th = C.h * 0.8
    var user = User()
    var type = 0
    let editButton = UIButton(type: UIButtonType.custom) as UIButton
    let logoutButton = UIButton(type: UIButtonType.custom) as UIButton
    var friendsCollectionView: UICollectionView!
    var statusTextView: UITextView!
    convenience init (user: User)
    {
        self.init(frame: CGRect(x: 0, y: 0, width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3))
        self.user = user
    }
    
    convenience init (user: User, t: Int)
    {
        self.init(frame: CGRect(x: 0, y: 0, width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3))
        self.user = user
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
        var rows = 3 + self.type + self.user.statuses.count
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
            let profileImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: tw, height: tw))
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
                let settingsButton   = UIButton(type: UIButtonType.custom) as UIButton
                settingsButton.frame = CGRect(x: tw*0.85, y: th*0.05, width: tw * 0.1, height: tw * 0.1)
                settingsButton.setImage(UIImage(named: "edit"), for: .normal)
                settingsButton.addTarget(self, action: #selector(goToSettings), for: UIControlEvents.touchUpInside)
                self.addSubview(settingsButton)
                
                let logoutButton   = UIButton(type: UIButtonType.custom) as UIButton
                logoutButton.frame = CGRect(x: tw*0.05, y: th*0.05, width: tw * 0.1, height: tw * 0.1)
                logoutButton.setImage(UIImage(named: "logout"), for: .normal)
                logoutButton.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
                self.addSubview(logoutButton)
            }
            
            
            let nameLabel = UILabel(frame: CGRect(x: tw*0.02, y: tw*0.75, width: tw * 0.48, height: tw * 0.2))
            nameLabel.font = UIFont(name: "FuturaPT-Light", size: 28.0)
            nameLabel.text = self.user.name.lowercased()
            cell.addSubview(nameLabel)
            
//            let levelLabel = UILabel(frame: CGRect(x: tw*0.03, y: tw*0.83, width: tw * 0.28, height: tw * 0.08))
//            levelLabel.textColor = C.goldishColor
//            levelLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
//            levelLabel.text="lvl \(self.user.level)"
            //cell.addSubview(levelLabel)
            
//            let majorLabel = UILabel(frame: CGRect(x: tw*0.05, y: tw*0.925, width: tw * 0.45, height: tw * 0.05))
//            majorLabel.textColor = C.blueishColor
//            majorLabel.font = UIFont(name: "FuturaPT-Light", size: 10.0)
//            majorLabel.text = self.user.major.lowercased()
//            cell.addSubview(majorLabel)
//
//            let locationLabel = UILabel(frame: CGRect(x: tw*0.6, y: tw*0.925, width: tw * 0.2, height: tw * 0.05))
//            locationLabel.textColor = C.blueishColor
//            locationLabel.font = UIFont(name: "FuturaPT-Light", size: 10.0)
//            locationLabel.text = self.user.hometown.lowercased()
//            cell.addSubview(locationLabel)
            
//            let ageLabel = UILabel(frame: CGRect(x: tw*0.9, y: tw*0.925, width: tw * 0.05, height: tw * 0.05))
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
                nameLabel.frame = CGRect(x: tw*0.02, y: tw*0.8, width: tw * 0.48, height: tw * 0.2)
            }
            
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
            
            
            let bioTextView = UITextView(frame: CGRect(x: tw*0.05, y: th*0.03, width: tw*0.9, height: th*0.1))
            bioTextView.backgroundColor = .clear
            bioTextView.textColor = C.blueishColor
            bioTextView.font = UIFont(name: "FuturaPT-Light", size: 14)
            bioTextView.text = self.user.bio
            
            bioTextView.isEditable = false
            
            if type == -1 || user.business == 1
            {
                whoIAmLabel.text = "menu"
                bioTextView.frame = CGRect(x: tw*0.05, y: th*0.03, width: tw*0.9, height: th*0.24)
            }
            cell.addSubview(bioTextView)
        }
        else if (indexPath.row == 3 && type == 1) || (indexPath.row == 2 && type == 1)
        {
            statusTextView = UITextView(frame: CGRect(x: tw * 0.1, y: th * 0.01, width: tw * 0.8, height: th * 0.09))
            statusTextView.keyboardType = UIKeyboardType.default
            statusTextView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            statusTextView.returnKeyType = UIReturnKeyType.done
            statusTextView.layer.cornerRadius = statusTextView.frame.size.width / 25
            statusTextView.autocorrectionType = UITextAutocorrectionType.no
            statusTextView.delegate = self
            statusTextView.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            statusTextView.autocapitalizationType = .none
            cell.addSubview(statusTextView)
            
            let postButton = UIButton(type: UIButtonType.custom) as UIButton
            postButton.frame = CGRect(x: tw * 0.45, y: th * 0.15 - tw * 0.1, width: tw * 0.1, height: tw * 0.1 * 0.875)
            postButton.setImage(UIImage(named: "brush"), for: .normal)
//            postButton.layer.cornerRadius = postButton.frame.size.width / 10;
//            postButton.backgroundColor = C.goldishColor
//            postButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 12.0)
//            postButton.titleLabel?.text = "post"
//            postButton.setTitleColor(.white, for: .normal)
//            postButton.setTitle("post", for: .normal)
            postButton.addTarget(self, action: #selector(postStatus), for: UIControlEvents.touchUpInside)
            cell.addSubview(postButton)
        }
        else
        {
            let statusLabel = UILabel(frame: CGRect(x: tw*0.05, y: th*0.025, width: tw*0.9, height: th*0.1))
            statusLabel.numberOfLines = 2
            statusLabel.textColor = C.darkColor
            statusLabel.font = UIFont(name: "FuturaPT-Light", size: 14)
            statusLabel.text = self.user.statuses[self.user.statuses.count - 1 - indexPath.row + 3 + type].text
            cell.addSubview(statusLabel)
            
            
            let dateLabel = UILabel(frame: CGRect(x: tw*0.47, y: th*0.11, width: tw*0.5, height: th*0.03))
            dateLabel.textColor = .gray
            dateLabel.textAlignment = .right
            dateLabel.font = UIFont(name: "FuturaPT-Light", size: 10)
            
            let timeString = self.timeAgoSince(self.user.statuses[self.user.statuses.count - 1 - indexPath.row + 3 + type].time)
            dateLabel.text = timeString
            cell.addSubview(dateLabel)
        }
        return cell
    }
    
    @objc func goToSettings()
    {
        //self.isHidden = true
        self.addSubview(EditableMatchProfileView(user: self.user, t: 1, pv: self))
    }
    
    @objc func logout()
    {
        let alert = UIAlertController(title: "logout", message: "do you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: {(alert: UIAlertAction!) in self.reallyLogout()}))
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: nil))
        self.parentViewController!.present(alert, animated: true, completion: nil)
    }
    
    func reallyLogout()
    {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    @objc func postStatus()
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let dateString = dateFormatter.string(from: Date())
        var statusesDict: [Dictionary<String, Any>] = []
        if C.userData["statuses"] != nil
        {
            statusesDict = C.userData["statuses"]  as! [Dictionary<String, Any>]
        }
        let status = ["text": statusTextView.text!, "time": dateString]
        statusesDict.append(status)
        C.userData["statuses"] = statusesDict
        C.parseStatuses(statusDict: statusesDict, u: C.user)
        statusTextView.text = ""
        C.db.collection("user_info2").document(C.refid).updateData(["statuses":statusesDict])
        self.tableView.reloadData()
        
    }
}


extension MatchProfileView : UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    public func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y -= C.h * 0.175
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.center = CGPoint(x: C.w * 0.5, y: C.h * 0.5)
        }
    }
    

}

extension MatchProfileView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if(text == "\n") {
            self.statusTextView.resignFirstResponder()
        }
        return numberOfChars < 50;
    }
}
