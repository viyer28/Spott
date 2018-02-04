
//
//  ProfileViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var top: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        top = self.navigationController!.navigationBar.frame.size.height
        self.title = "Profile";
        let profileImageView = UIImageView(frame:CGRect(x: C.w*0.1, y: C.w*0.1 + top, width: C.w*0.3, height: C.w*0.3))
        print(profileImageView.frame)
        profileImageView.image = UIImage(named: "sample_prof")
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = true;
        profileImageView.layer.borderWidth = 3.0 as CGFloat
        profileImageView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(profileImageView)
        
        let nameLabel = UILabel(frame: CGRect(x: C.w*0.55, y: top + C.w * 0.125, width: C.w * 0.3, height: C.w * 0.1))
        nameLabel.textColor = UIColor.gray
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Arial", size: 17)
        nameLabel.text="Griffin Moon"
        view.addSubview(nameLabel)
        
        let connectsLabel = UILabel(frame: CGRect(x: C.w*0.55, y: top + C.w * 0.2, width: C.w * 0.3, height: C.w * 0.1))
        connectsLabel.textColor = UIColor.gray
        connectsLabel.textAlignment = .center
        connectsLabel.font = UIFont(name: "Arial", size: 12)
        connectsLabel.text="Connects:"
        view.addSubview(connectsLabel)
        
        let numConnectsLabel = UILabel(frame: CGRect(x: C.w*0.55, y: top + C.w * 0.25, width: C.w * 0.3, height: C.w * 0.1))
        numConnectsLabel.textColor = UIColor.gray
        numConnectsLabel.textAlignment = .center
        numConnectsLabel.font = UIFont(name: "Arial", size: 16)
        numConnectsLabel.text="465"
        view.addSubview(numConnectsLabel)
        
        let levelLabel = UILabel(frame: CGRect(x: C.w*0.45, y: top + C.w * 0.3, width: C.w * 0.2, height: C.w * 0.1))
        levelLabel.textColor = UIColor.gray
        levelLabel.textAlignment = .center
        levelLabel.font = UIFont(name: "Arial", size: 16)
        levelLabel.text="Level: 1"
        view.addSubview(levelLabel)
        
        let expBar = UIProgressView(frame: CGRect(x: C.w*0.65, y: top + C.w * 0.35, width: C.w * 0.2, height: C.w * 0.1))
        expBar.progress = 1.0/2.0
        expBar.progressTintColor = UIColor.orange
        expBar.trackTintColor = UIColor.black
        view.addSubview(expBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

