//
//  leaderboardTableCell.swift
//  spott
//
//  Created by Brendan Sanderson on 5/26/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation

class LeaderTableCell: UITableViewCell {
    var scoreLabel: UILabel!
    var rankLabel: UILabel!
    var nameLabel: UILabel!
    var profileImage: UIImageView!
    var rankImage: UIImageView!
    init(style: UITableViewCellStyle, reuseIdentifier: String?, leader: Leader, row: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let cw = self.frame.width
        let ch = self.frame.height
        
        rankLabel = UILabel(frame: CGRect(x: cw * 0.02, y: 0, width: cw * 0.08, height: ch))
        rankLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        rankLabel.text = String(row+1)
        
        scoreLabel = UILabel(frame: CGRect(x: cw * 0.65, y: 0, width: cw * 0.25, height: ch))
        scoreLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        scoreLabel.text = String(leader.score)
        scoreLabel.textAlignment = .right
        
        nameLabel = UILabel(frame: CGRect(x: cw * 0.1 + 2*ch, y: 0, width: cw * 0.5, height: ch))
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        nameLabel.text = leader.name
        
        profileImage = UIImageView(frame:CGRect(x: cw*0.1 + ch, y: ch*0.1, width: ch*0.8, height: ch*0.8))
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = leader.image
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        self.addSubview(profileImage)
        
        rankImage = UIImageView(frame:CGRect(x: cw*0.1, y: ch*0.1, width: ch*0.8, height: ch*0.8))
        rankImage.contentMode = .scaleAspectFit
        
        if leader.prevRank == -1 || leader.rank == -1
        {
            rankImage.image = UIImage(named: "upupupup")
        }
        else if leader.rank < leader.prevRank
        {
            rankImage.image = UIImage(named: "upupupup")
        }
        else if leader.prevRank < leader.rank
        {
            rankImage.image = UIImage(named: "downdowndown")
        }
        else
        {
            rankImage.image = UIImage(named: "samesame")
        }
        
        self.addSubview(rankImage)
        
        self.addSubview(rankLabel)
        self.addSubview(scoreLabel)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  leaderboardTableCell.swift
//  spott
//
//  Created by Brendan Sanderson on 5/26/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation

class LeaderView: UIView {
    var scoreLabel: UILabel!
    var rankLabel: UILabel!
    var nameLabel: UILabel!
    var profileImage: UIImageView!
    var rankImage: UIImageView!
    init(frame: CGRect, leader: Leader, rank: Int) {
        super.init(frame: frame)
        let cw = self.frame.width
        let ch = self.frame.height
        
        
        self.backgroundColor = C.goldishColor
        
        rankLabel = UILabel(frame: CGRect(x: cw * 0.02, y: 0, width: cw * 0.08, height: ch))
        rankLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        rankLabel.text = String(rank+1)
        if rank == -1
        {
            rankLabel.text = "-"
        }
        
        scoreLabel = UILabel(frame: CGRect(x: cw * 0.7, y: 0, width: cw * 0.25, height: ch))
        scoreLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        scoreLabel.text = String(leader.score)
        scoreLabel.textAlignment = .right
        
        nameLabel = UILabel(frame: CGRect(x: cw * 0.1 + 2*ch, y: 0, width: cw * 0.5, height: ch))
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        nameLabel.text = leader.name
        
        profileImage = UIImageView(frame:CGRect(x: cw*0.1 + ch, y: ch*0.1, width: ch*0.7, height: ch*0.7))
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = leader.image
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        self.addSubview(profileImage)
        
        rankImage = UIImageView(frame:CGRect(x: cw*0.1, y: ch*0.1, width: ch*0.8, height: ch*0.8))
        rankImage.contentMode = .scaleAspectFit
        self.addSubview(rankImage)
        
        if leader.prevRank == -1 || leader.rank == -1
        {
            rankImage.image = UIImage(named: "upupupup")
        }
        else if leader.rank < leader.prevRank
        {
            rankImage.image = UIImage(named: "upupupup")
        }
        else if leader.prevRank < leader.rank
        {
            rankImage.image = UIImage(named: "downdowndown")
        }
        else
        {
            rankImage.image = UIImage(named: "samesame")
        }
        
        
        self.addSubview(rankLabel)
        self.addSubview(scoreLabel)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

