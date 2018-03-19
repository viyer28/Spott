
//
//  ProfileViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    var top: CGFloat!
    var friends = 123
    var age = 21
    var location = "Chicago, IL"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false;
        self.tableView.separatorColor = C.goldishColor
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.rowHeight = C.h*0.5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        
        if indexPath.row == 0
        {
            let profileImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: C.w, height: C.w))
            profileImageView.image = UIImage(named: C.user.profilePictureURL)
            let view = UIView(frame: profileImageView.frame)
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: C.w, height: C.w)
            gradient.locations = [0.6, 1.0]
            gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
            profileImageView.addSubview(view)
            view.layer.insertSublayer(gradient, at: 0)
            cell.addSubview(profileImageView)
            
            let nameLabel = UILabel(frame: CGRect(x: C.w*0.02, y: C.w*0.75, width: C.w * 0.28, height: C.w * 0.08))
            nameLabel.font = UIFont(name: "FuturaPT-Light", size: 32.0)
            nameLabel.text=C.user.name
            cell.addSubview(nameLabel)
            
            let levelLabel = UILabel(frame: CGRect(x: C.w*0.03, y: C.w*0.83, width: C.w * 0.28, height: C.w * 0.08))
            levelLabel.textColor = C.goldishColor
            levelLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            levelLabel.text = "\(C.user.level)"
            cell.addSubview(levelLabel)
            
            let majorLabel = UILabel(frame: CGRect(x: C.w*0.05, y: C.w*0.925, width: C.w * 0.45, height: C.w * 0.05))
            majorLabel.textColor = C.blueishColor
            majorLabel.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            majorLabel.text = C.user.major
            cell.addSubview(majorLabel)
            
            let locationLabel = UILabel(frame: CGRect(x: C.w*0.6, y: C.w*0.925, width: C.w * 0.2, height: C.w * 0.05))
            locationLabel.textColor = C.blueishColor
            locationLabel.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            locationLabel.text = location
            cell.addSubview(locationLabel)
            
            let ageLabel = UILabel(frame: CGRect(x: C.w*0.9, y: C.w*0.925, width: C.w * 0.05, height: C.w * 0.05))
            ageLabel.textColor = C.blueishColor
            ageLabel.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            ageLabel.text = "\(C.user.age)"
            cell.addSubview(ageLabel)

        }
        else if indexPath.row == 1
        {
            let numFriendsLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.025, width: C.w * 0.24, height: C.h * 0.05))
            numFriendsLabel.numberOfLines = 0
            numFriendsLabel.baselineAdjustment = .alignCenters
            numFriendsLabel.textColor = C.blueishColor
            numFriendsLabel.textAlignment = .right
            numFriendsLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            numFriendsLabel.text = "\(C.user.numFriends)"
            cell.addSubview(numFriendsLabel)
            
            let friendsLabel = UILabel(frame: CGRect(x: C.w*0.26, y: C.h*0.025, width: C.w * 0.18, height: C.h * 0.05))
            friendsLabel.numberOfLines = 0
            friendsLabel.baselineAdjustment = .alignCenters
            friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            friendsLabel.text="friends"
            cell.addSubview(friendsLabel)
        
            if C.user.numFriends > 0
            {
                let friendImage1 = UIImageView(frame:CGRect(x: C.w * 0.45, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage1.layer.cornerRadius = friendImage1.frame.size.width / 2;
                friendImage1.clipsToBounds = true;
                friendImage1.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage1)
            }
            if C.user.numFriends > 1
            {
                let friendImage2 = UIImageView(frame:CGRect(x: C.w * 0.475 + C.h * 0.06, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage2.layer.cornerRadius = friendImage2.frame.size.width / 2;
                friendImage2.clipsToBounds = true;
                friendImage2.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage2)
            }
            if C.user.numFriends > 2
            {
                let friendImage3 = UIImageView(frame:CGRect(x: C.w * 0.5 + C.h * 0.12, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage3.layer.cornerRadius = friendImage3.frame.size.width / 2;
                friendImage3.clipsToBounds = true;
                friendImage3.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage3)
            }
            if C.user.numFriends > 3
            {
                let dotLabel = UILabel(frame: CGRect(x: C.w * 0.525 + C.h * 0.18, y: C.h * 0.025, width: C.h * 0.05, height: C.h * 0.05))
                dotLabel.textColor = UIColor.black
                dotLabel.textAlignment = .left
                dotLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                dotLabel.text="..."
                cell.addSubview(dotLabel)
            }
        }
        else if indexPath.row == 2
        {
            let centerLine = UIView(frame: CGRect(x: C.w*0.498, y: 0, width: C.w*0.001, height: C.h*0.2))
            centerLine.backgroundColor = C.goldishColor
            cell.addSubview(centerLine)
            
            let whoIAmLabel = UILabel(frame: CGRect(x: C.w*0.05, y: C.h*0.01, width: C.w*0.2, height: C.h*0.05))
            whoIAmLabel.textColor = UIColor.black
            whoIAmLabel.text = "who i am"
            whoIAmLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
            cell.addSubview(whoIAmLabel)
            
            let whoIAmTraitsLabel = UILabel(frame: CGRect(x: C.w*0.15, y: C.h*0.05, width: C.w*0.35, height: C.h*0.10))
            whoIAmTraitsLabel.numberOfLines = 3
            whoIAmTraitsLabel.textColor = C.blueishColor
            whoIAmTraitsLabel.text = "adventurous\nintroverted\nconfident"
            whoIAmTraitsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
            cell.addSubview(whoIAmTraitsLabel)
            
            let whatIDoLabel = UILabel(frame: CGRect(x: C.w*0.55, y: C.h*0.01, width: C.w*0.2, height: C.h*0.05))
            whatIDoLabel.text = "what i do"
            whatIDoLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
            cell.addSubview(whatIDoLabel)
            
            let whatIDoTraitsLabel = UILabel(frame: CGRect(x: C.w*0.65, y: C.h*0.05, width: C.w*0.35, height: C.h*0.10))
            whatIDoTraitsLabel.numberOfLines = 3
            whatIDoTraitsLabel.textColor = C.blueishColor
            whatIDoTraitsLabel.text = "snowboard\ntennis\nprogram"
            whatIDoTraitsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
            cell.addSubview(whatIDoTraitsLabel)
        }
        else
        {
            cell.frame=CGRect(x: 0, y: 0, width: C.w, height: C.h*0.2)
        }
        //cell.textLabel!.text = "foo"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return C.w
        }
        else if indexPath.row == 1
        {
            return C.h*0.1
        }
        else
        {
            return C.h*0.2
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return C.h*0.5
        }
        else
        {
            return C.h*0.2
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

