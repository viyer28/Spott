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
    
    convenience init (user: User)
    {
        self.init(frame: CGRect(x: 0, y: 0, width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3))
        self.user = user
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        
        if indexPath.row == 0
        {
            let profileImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: tw, height: tw))
            profileImageView.image = UIImage(named: C.user.profilePictureURL)
            let view = UIView(frame: profileImageView.frame)
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: tw, height: tw)
            gradient.locations = [0.6, 1.0]
            gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
            profileImageView.addSubview(view)
            view.layer.insertSublayer(gradient, at: 0)
            cell.addSubview(profileImageView)
            
            let nameLabel = UILabel(frame: CGRect(x: tw*0.02, y: tw*0.7, width: tw * 0.28, height: tw * 0.13))
            nameLabel.font = UIFont(name: "FuturaPT-Light", size: 28.0)
            nameLabel.text = self.user.name
            cell.addSubview(nameLabel)
            
            let levelLabel = UILabel(frame: CGRect(x: tw*0.03, y: tw*0.83, width: tw * 0.28, height: tw * 0.08))
            levelLabel.textColor = C.goldishColor
            levelLabel.font = UIFont(name: "FuturaPT-Light", size: 20.0)
            levelLabel.text="lvl \(self.user.level)"
            cell.addSubview(levelLabel)
            
            let majorLabel = UILabel(frame: CGRect(x: tw*0.05, y: tw*0.925, width: tw * 0.45, height: tw * 0.05))
            majorLabel.textColor = C.blueishColor
            majorLabel.font = UIFont(name: "FuturaPT-Light", size: 10.0)
            majorLabel.text = self.user.major
            cell.addSubview(majorLabel)
            
            let locationLabel = UILabel(frame: CGRect(x: tw*0.6, y: tw*0.925, width: tw * 0.2, height: tw * 0.05))
            locationLabel.textColor = C.blueishColor
            locationLabel.font = UIFont(name: "FuturaPT-Light", size: 10.0)
            locationLabel.text = self.user.hometown
            cell.addSubview(locationLabel)
            
            let ageLabel = UILabel(frame: CGRect(x: tw*0.9, y: tw*0.925, width: tw * 0.05, height: tw * 0.05))
            ageLabel.textColor = C.blueishColor
            ageLabel.font = UIFont(name: "FuturaPT-Light", size: 10.0)
            ageLabel.text = "\(self.user.age)"
            cell.addSubview(ageLabel)
            
        }
        else if indexPath.row == 1
        {
            let numFriendsLabel = UILabel(frame: CGRect(x: 0, y: th*0.025, width: tw * 0.24, height: th * 0.05))
            numFriendsLabel.numberOfLines = 0
            numFriendsLabel.baselineAdjustment = .alignCenters
            numFriendsLabel.textColor = C.blueishColor
            numFriendsLabel.textAlignment = .right
            numFriendsLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            numFriendsLabel.text = "\(self.user.numFriends)"
            cell.addSubview(numFriendsLabel)
            
            let friendsLabel = UILabel(frame: CGRect(x: tw*0.26, y: th*0.025, width: tw * 0.18, height: th * 0.05))
            friendsLabel.numberOfLines = 2
            friendsLabel.baselineAdjustment = .alignCenters
            friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 8.0)
            friendsLabel.text = "friends in common"
            cell.addSubview(friendsLabel)
            
            if self.user.friends.count > 0
            {
                let friendImage1 = UIImageView(frame:CGRect(x: tw * 0.45, y: th*0.02, width: th * 0.06, height: th * 0.06))
                friendImage1.layer.cornerRadius = friendImage1.frame.size.width / 2;
                friendImage1.clipsToBounds = true;
                friendImage1.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage1)
            }
            if self.user.friends.count > 1
            {
                let friendImage2 = UIImageView(frame:CGRect(x: tw * 0.475 + th * 0.06, y: th*0.02 , width: th * 0.06, height: th * 0.06))
                friendImage2.layer.cornerRadius = friendImage2.frame.size.width / 2;
                friendImage2.clipsToBounds = true;
                friendImage2.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage2)
            }
            if self.user.friends.count > 2
            {
                let friendImage3 = UIImageView(frame:CGRect(x: tw * 0.5 + th * 0.12, y: th*0.02 , width: th * 0.06, height: th * 0.06))
                friendImage3.layer.cornerRadius = friendImage3.frame.size.width / 2;
                friendImage3.clipsToBounds = true;
                friendImage3.image = UIImage(named: "sample_prof")
                cell.addSubview(friendImage3)
            }
            if self.user.friends.count > 3
            {
                let dotLabel = UILabel(frame:CGRect(x: tw * 0.55 + th * 0.18, y: th*0.02 , width: th * 0.06, height: th * 0.06))
                dotLabel.textColor = UIColor.black
                dotLabel.textAlignment = .left
                dotLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                dotLabel.text="..."
                cell.addSubview(dotLabel)
            }
        }
        else if indexPath.row == 2
        {
            let centerLine = UIView(frame: CGRect(x: tw*0.498, y: 0, width: tw*0.001, height: th*0.2))
            centerLine.backgroundColor = C.goldishColor
            cell.addSubview(centerLine)
            
            let whoIAmLabel = UILabel(frame: CGRect(x: tw*0.05, y: th*0.01, width: tw*0.35, height: th*0.05))
            whoIAmLabel.textColor = UIColor.black
            whoIAmLabel.text = "who i am"
            whoIAmLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
            cell.addSubview(whoIAmLabel)
            
            let whoIAmTraitsLabel = UILabel(frame: CGRect(x: tw*0.15, y: th*0.05, width: tw*0.35, height: th*0.10))
            whoIAmTraitsLabel.numberOfLines = 3
            whoIAmTraitsLabel.textColor = C.blueishColor
            whoIAmTraitsLabel.text = "adventurous\nintroverted\nconfident"
            whoIAmTraitsLabel.font = UIFont(name: "FuturaPT-Light", size: 11)
            cell.addSubview(whoIAmTraitsLabel)
            
            let whatIDoLabel = UILabel(frame: CGRect(x: tw*0.55, y: th*0.01, width: tw*0.35, height: th*0.05))
            whatIDoLabel.text = "what i do"
            whatIDoLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
            cell.addSubview(whatIDoLabel)
            
            let whatIDoTraitsLabel = UILabel(frame: CGRect(x: tw*0.65, y: th*0.05, width: tw*0.35, height: th*0.10))
            whatIDoTraitsLabel.numberOfLines = 3
            whatIDoTraitsLabel.textColor = C.blueishColor
            whatIDoTraitsLabel.text = "snowboard\ntennis\nprogram"
            whatIDoTraitsLabel.font = UIFont(name: "FuturaPT-Light", size: 11)
            cell.addSubview(whatIDoTraitsLabel)
        }
        //cell.textLabel!.text = "foo"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return tw
        }
        if indexPath.row == 1
        {
            return C.h * 0.1 * 0.8
        }
        else
        {
            return C.h * 0.2 * 0.8
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return th*0.5
        }
        else
        {
            return th*0.2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


