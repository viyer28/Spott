//
//  MapAnnotation.swift
//  spott
//
//  Created by Varun Iyer on 8/13/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import Mapbox
import MapKit

class MapAnnotation: MGLPointAnnotation {
    var type: Int? // if type == 0, location; if type == 1, friend
    var user: User!
    var location: Location!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationAnnotationView: MGLAnnotationView {
    var locationImageView: UIImageView!
    var percent: CGFloat!
    var location: Location!
    
    convenience init (reuseIdentifier: String?, location: Location)
    {
        self.init(reuseIdentifier: reuseIdentifier)
        self.location = location
        //review this
        self.percent = min(3*CGFloat(location.numPopulation) / CGFloat(B.totalPopulation) * 100,100)
        self.frame = CGRect(x: 0, y: 0, width: Int(20 + (percent/5.0)), height: Int(20 + (percent/5.0)))
        
        self.locationImageView = UIImageView(frame: self.frame)
        locationImageView.contentMode = .scaleAspectFit
        self.locationImageView.image = UIImage(named: "flame\(location.type)")
        locationImageView.alpha = 1 //review
        self.addSubview(locationImageView)
    }
    
    override init (reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FriendAnnotationView: MGLAnnotationView {
    var friendImageView: UIImageView!
    var friend: User!
    
    convenience init(reuseIdentifier: String, user: User)
    {
        self.init(reuseIdentifier: reuseIdentifier)
        self.friend = user
        self.friendImageView.image = user.propic
        self.friendImageView.contentMode = .scaleAspectFit
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.backgroundColor = .clear
        friendImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        friendImageView.image = #imageLiteral(resourceName: "spott-propic")
        friendImageView.contentMode = .scaleAspectFit
        self.addSubview(friendImageView)
        self.layer.borderWidth = 2.0 as CGFloat
        self.layer.borderColor = B.goldishColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationCalloutView: UIView, MGLCalloutView {
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    weak var delegate: MGLCalloutViewDelegate?
    var representedObject: MGLAnnotation
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    
    var backgroundView: UIView!
    var titleLabel: UILabel!
    var populationLabel: UILabel!
    
    convenience init (representedObject: MGLAnnotation, location: Location)
    {
        self.init(representedObject: representedObject)
        self.frame = CGRect(x: 0, y: B.h*0.75, width: B.w, height: B.h*0.25)
        
        self.populationLabel = UILabel()
        populationLabel.textColor = B.goldishColor
        populationLabel.textAlignment = .center
        populationLabel.font = UIFont(name: "FuturaPT-Light", size: 64)
        populationLabel.text = String(location.numPopulation)
        self.addSubview(populationLabel)
        populationLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        self.titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 42)
        titleLabel.text = representedObject.title!
        self.addSubview(populationLabel)
        titleLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.populationLabel.snp.top).offset(10)
        }
    }
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
    }
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)
    }
    
    func dismissCallout(animated: Bool) {
        removeFromSuperview()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FriendCalloutView: UIView, MGLCalloutView, MGLCalloutViewDelegate {
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    var representedObject: MGLAnnotation
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    
    var backgroundView: UIView!
    var user: User!
    var nameLabel: UILabel!
    var profileImageView: UIImageView!
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        self.user = (representedObject as! MapAnnotation).user
        self.delegate = self
        
        self.frame = CGRect(x: 0, y: B.h*0.75, width: B.w, height: B.h*0.25)
        
        self.profileImageView = UIImageView(image: user.propic)
        profileImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints{ (make) in
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        self.nameLabel = UILabel()
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 42)
        nameLabel.text = String(user.firstName)
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.profileImageView.snp.top).offset(10)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)
    }
    
    func dismissCallout(animated: Bool) {
        removeFromSuperview()
    }
}

class EmptyCalloutView: UIView, MGLCalloutView, MGLCalloutViewDelegate {
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)
    }
    
    var representedObject: MGLAnnotation
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    var user: User!
    var delegate: MGLCalloutViewDelegate?
    
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissCallout(animated: Bool) {
    }
    
}
