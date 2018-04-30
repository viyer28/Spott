
//
//  ProfileViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var top: CGFloat!
    var friends = 123
    var age = 21
    var location = "Chicago, IL"
    var tableView: UITableView!
    let centerButton = UIButton(type: UIButtonType.custom) as UIButton
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.head
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h))
        self.tableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false;
        self.tableView.separatorColor = C.goldishColor
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.rowHeight = C.h*0.5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        centerButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        centerButton.center = CGPoint(x: C.w*0.5, y: C.h*0.9)
        centerButton.setImage(UIImage(named: "centerUser"), for: .normal)
        centerButton.addTarget(self, action: #selector(backClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(tableView)
        self.view.addSubview(centerButton)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        C.updateUserFriends()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        
        if indexPath.row == 0
        {
            
            let profileImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: C.w, height: C.w))
            profileImageView.image = C.user.image
            let view = UIView(frame: profileImageView.frame)
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: C.w, height: C.w)
            gradient.locations = [0.6, 1.0]
            gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
            profileImageView.addSubview(view)
            view.layer.insertSublayer(gradient, at: 0)
            cell.addSubview(profileImageView)
            
            let nameLabel = UILabel(frame: CGRect(x: C.w*0.02, y: C.w*0.75, width: C.w * 0.48, height: C.w * 0.2))
            nameLabel.font = UIFont(name: "FuturaPT-Light", size: 32.0)
            nameLabel.text=C.user.name.lowercased()
            cell.addSubview(nameLabel)
            
//            let levelLabel = UILabel(frame: CGRect(x: C.w*0.03, y: C.w*0.83, width: C.w * 0.28, height: C.w * 0.08))
//            levelLabel.textColor = C.goldishColor
//            levelLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
//            levelLabel.text = "Lvl: \(C.user.level!)"
//            cell.addSubview(levelLabel)
            
            let majorLabel = UILabel(frame: CGRect(x: C.w*0.05, y: C.w*0.925, width: C.w * 0.45, height: C.w * 0.07))
            majorLabel.textColor = C.blueishColor
            majorLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
            majorLabel.text = C.user.major.lowercased()
            cell.addSubview(majorLabel)
            
            let locationLabel = UILabel(frame: CGRect(x: C.w*0.5, y: C.w*0.925, width: C.w * 0.3, height: C.w * 0.07))
            locationLabel.textColor = C.blueishColor
            locationLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
            locationLabel.text = C.user.hometown.lowercased()
            cell.addSubview(locationLabel)
            
            let ageLabel = UILabel(frame: CGRect(x: C.w*0.05, y: C.w*0.925, width: C.w * 0.1, height: C.w * 0.05))
            ageLabel.textColor = C.blueishColor
            ageLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
            ageLabel.text = "\(C.user.age!)"
            cell.addSubview(ageLabel)
            

            let image = UIImage(named: "settingsIcon") as UIImage?
            let settingsButton   = UIButton(type: UIButtonType.custom) as UIButton
            settingsButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
            settingsButton.setImage(image, for: .normal)
             settingsButton.addTarget(self, action: #selector(goToSettings), for: UIControlEvents.touchUpInside)
            self.view.addSubview(settingsButton)
            
            let backButton = UIButton(frame: CGRect(x: C.w*0.05, y: C.w * 0.1, width: C.w * 0.1, height:  C.w * 0.1))
            backButton.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 28.0)
            backButton.titleLabel?.text = "<"
            backButton.setTitleColor(C.goldishColor, for: .normal)
            backButton.setTitle("<", for: .normal)
            backButton.addTarget(self, action: #selector(backClick), for: UIControlEvents.touchUpInside)
            //self.view.addSubview(backButton)
            
        }
        else if indexPath.row == 1
        {
            
            let friendsLabel = UILabel(frame: CGRect(x: C.w*0.06, y: C.h*0.025, width: C.w * 0.18, height: C.h * 0.05))
            friendsLabel.numberOfLines = 0
            friendsLabel.baselineAdjustment = .alignCenters
            friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 12.0)
            friendsLabel.text="friends"
            cell.addSubview(friendsLabel)
            
//            let numFriendsLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.025, width: C.w * 0.24, height: C.h * 0.05))
            let numFriendsLabel = UILabel(frame: CGRect(x: C.w*0.1 + friendsLabel.intrinsicContentSize.width, y: C.h*0.025, width: C.w * 0.2, height: C.h * 0.05))
            numFriendsLabel.numberOfLines = 0
            numFriendsLabel.baselineAdjustment = .alignCenters
            numFriendsLabel.textColor = C.blueishColor
            numFriendsLabel.font = UIFont(name: "FuturaPT-Light", size: 24.0)
            numFriendsLabel.text = "\(C.user.friends.count)"
            cell.addSubview(numFriendsLabel)
            
            //let friendsLabel = UILabel(frame: CGRect(x: C.w*0.26, y: C.h*0.025, width: C.w * 0.18, height: C.h * 0.05))
            var friendImage1: UIImageView!
            var friendImage2: UIImageView!
            var friendImage3: UIImageView!
            if C.user.friends.count > 0
            {
                friendImage1 = UIImageView(frame:CGRect(x: numFriendsLabel.frame.minX + numFriendsLabel.intrinsicContentSize.width + C.w*0.05, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage1.layer.cornerRadius = friendImage1.frame.size.width / 2;
                friendImage1.clipsToBounds = true;
                friendImage1.image = C.user.friends[0].image
                cell.addSubview(friendImage1)
            }
            if C.user.friends.count > 1
            {
                friendImage2 = UIImageView(frame:CGRect(x: friendImage1.frame.maxX + C.w*0.05, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage2.layer.cornerRadius = friendImage2.frame.size.width / 2;
                friendImage2.clipsToBounds = true;
                friendImage2.image = C.user.friends[1].image
                cell.addSubview(friendImage2)
            }
            if C.user.friends.count > 2
            {
                friendImage3 = UIImageView(frame:CGRect(x: friendImage2.frame.maxX + C.w*0.05, y: C.h * 0.02, width: C.h * 0.06, height: C.h * 0.06))
                friendImage3.layer.cornerRadius = friendImage3.frame.size.width / 2;
                friendImage3.clipsToBounds = true;
                friendImage3.image = C.user.friends[2].image
                cell.addSubview(friendImage3)
            }
            if C.user.friends.count > 3
            {
                let dotLabel = UILabel(frame: CGRect(x: friendImage3.frame.maxX + C.w*0.05, y: C.h * 0.025, width: C.h * 0.05, height: C.h * 0.05))
                dotLabel.textColor = UIColor.black
                dotLabel.textAlignment = .left
                dotLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                dotLabel.text="..."
                cell.addSubview(dotLabel)
            }
        }
        else if indexPath.row == 2
        {
            let centerLine = UIView(frame: CGRect(x: C.w*0.5 - 1, y: 0, width: 1, height: C.h*0.2))
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
            whoIAmTraitsLabel.text = "\(C.user.whoIam[0])\n\(C.user.whoIam[1])\n\(C.user.whoIam[2])"
            whoIAmTraitsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
            cell.addSubview(whoIAmTraitsLabel)
            
            let whatIDoLabel = UILabel(frame: CGRect(x: C.w*0.55, y: C.h*0.01, width: C.w*0.2, height: C.h*0.05))
            whatIDoLabel.text = "what i do"
            whatIDoLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
            cell.addSubview(whatIDoLabel)
            
            let whatIDoTraitsLabel = UILabel(frame: CGRect(x: C.w*0.65, y: C.h*0.05, width: C.w*0.35, height: C.h*0.10))
            whatIDoTraitsLabel.numberOfLines = 3
            whatIDoTraitsLabel.textColor = C.blueishColor
            whatIDoTraitsLabel.text = "\(C.user.whatIDo[0])\n\(C.user.whatIDo[1])\n\(C.user.whatIDo[2])"
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return C.h*0.5
        }
        else
        {
            return C.h*0.2
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    @objc func backClick()
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func goToSettings ()
    {
        let initialViewController = SettingsViewController()
        //initialViewController.view.backgroundColor = C.darkColor
        self.present(initialViewController, animated: false, completion: nil)
    }
    
}

