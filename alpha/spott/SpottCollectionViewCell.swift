//
//  SpottCollectionViewCell.swift
//  spott
//
//  Created by Varun Iyer on 8/2/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SpottCollectionViewCell: UICollectionViewCell {
    
    var firstName: String = ""
    var propic: UIImageView!
    var friends: [User]?
    var profileMask: UIImageView!
    var nameLabel: UILabel!
    var mutualsLabel: UILabel!
    var mutualsPill: UIImageView!
    var crossedPathsLabel: UILabel!
    
    struct CellViewData {
        let fName: String
        let ppic: UIImage!
        let friends: [User]?
    }
    
    var cellViewData : CellViewData? {
        didSet {
            firstName = (cellViewData?.fName)!
            propic.image = (cellViewData?.ppic)!
            friends = (cellViewData?.friends)!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        propic = UIImageView(image: #imageLiteral(resourceName: "spott-propic"))
        propic.contentMode = .scaleAspectFill
        addSubview(propic)
        propic.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width)
        }
    
        profileMask = UIImageView(image: #imageLiteral(resourceName: "profilemask"))
        profileMask.contentMode = .scaleAspectFill
        addSubview(profileMask)
        profileMask.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(5)
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width)
        }
    
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.addCharactersSpacing(spacing: 5, text: "tay")
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 45)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(45)
            make.bottom.equalTo(self.snp.bottom).offset(-75)
        }
    
        mutualsPill = UIImageView(image: #imageLiteral(resourceName: "mutuals-pill"))
        mutualsPill.contentMode = .scaleAspectFit
        addSubview(mutualsPill)
        mutualsPill.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(25)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
    
        mutualsLabel = UILabel()
        mutualsLabel.textAlignment = .center
        mutualsLabel.textColor = .white
        mutualsLabel.addCharactersSpacing(spacing: 2, text: "11 mutuals")
        mutualsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
        addSubview(mutualsLabel)
        mutualsLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(10)
            make.centerY.equalTo(self.mutualsPill.snp.centerY)
        }
    
        crossedPathsLabel = UILabel()
        crossedPathsLabel.textAlignment = .center
        crossedPathsLabel.addCharactersSpacing(spacing: 2, text: "you've crossed paths 5 times")
        crossedPathsLabel.font = UIFont(name: "FuturaPT-Light", size: 10)
        addSubview(crossedPathsLabel)
        crossedPathsLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(10)
            make.top.equalTo(self.mutualsPill.snp.bottom).offset(10)
        }
    
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpottCollectionViewCell.CellViewData {
    init(user: User) {
        fName = user.firstName
        ppic = user.propic
        friends = user.friends
    }
}
