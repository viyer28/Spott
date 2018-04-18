//
//  MapAnnotation.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Mapbox

class MapAnnotation : MGLPointAnnotation {
    var type: Int?
    var user: User!
    var location: Location!
    var move = 1
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapAnnotationView: MGLAnnotationView {
    private var imageView: UIImageView!
    var percent: CGFloat!
    var location: Location!
    var borderView = UIView()
    convenience init (reuseIdentifier: String?, location: Location)
    {
        self.init(reuseIdentifier: reuseIdentifier)
        self.location = location
        self.percent = min(3*CGFloat(location.numPopulation) / CGFloat(C.totalPopulation) * 100,100)
        self.frame = CGRect(x: 0, y: 0, width: Int(5 + (percent/5.0)), height: Int(5 + (percent/5.0)))
        self.borderView.frame  = self.frame
        self.layer.cornerRadius = self.frame.size.width / 2
        self.borderView.layer.cornerRadius = self.borderView.frame.width / 2
        self.clipsToBounds = true
        
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //self.layer.borderWidth = 3.0 as CGFloat
        self.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        self.borderView.frame = self.frame
        self.borderView.layer.cornerRadius = self.borderView.frame.width/2
        self.layer.borderColor = C.darkColor.cgColor
        self.layer.borderWidth = 1  
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.backgroundColor = C.darkColor
        self.borderView.backgroundColor = UIColor.clear
        self.addSubview(borderView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        drawSlice(rect: rect, startPercent: 0, endPercent: percent, color: C.goldishColor)
    }
    
    func drawSlice(rect: CGRect, startPercent: CGFloat, endPercent: CGFloat, color: UIColor) {
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = startPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let endAngle = endPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        color.setFill()
        path.fill()
    }
}

class UserAtLocationAnnotationView: MGLAnnotationView
{
    var user: User!
    convenience init(reuseIdentifier: String, user: User)
    {
        self.init(reuseIdentifier: reuseIdentifier)
        self.user = user
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapUserAnnotationView: MGLAnnotationView {
    private var imageView: UIImageView!
    var user : User!
    var img: UIImageView!
    convenience init(reuseIdentifier: String, user: User)
    {
        self.init(reuseIdentifier: reuseIdentifier)
        self.user = user
        self.img.image = user.image
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //self.layer.borderWidth = 3.0 as CGFloat
        self.frame = CGRect(x: 0, y: 0, width: C.w*0.075, height: C.w*0.075)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        img = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        img.image = UIImage(named: "sample_prof")
        self.addSubview(img)
        self.layer.borderWidth = 2.0 as CGFloat
        self.layer.borderColor = C.goldishColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpottCalloutView: UIView, MGLCalloutView {
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    var representedObject: MGLAnnotation
    var backgroundView: UIButton!
    var potentialsImage: UIImageView!
    var titleView: UIView!
    var titleLabel: UILabel!
    var friendsLabel: UILabel!
    var friendsImage: UIImageView!
    var potentialsLabel: UILabel!
    
    convenience init (representedObject: MGLAnnotation, location: Location)
    {
        self.init(representedObject: representedObject)
        self.frame = CGRect(x: 0, y: C.h*0.8, width: C.w, height: C.h*0.2)
        self.titleLabel = UILabel(frame: CGRect(x: C.w*0.1, y: 0, width: C.w*0.8, height: C.h*0.1))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 36)
        titleLabel.text = representedObject.title!
        
        friendsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.8, titleLabel.intrinsicContentSize.width + C.w*0.02), y: 0, width: C.w*0.2, height: C.h*0.05))
        friendsLabel.textColor = C.greenishColor
        friendsLabel.textAlignment = .left
        friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        friendsLabel.text = String(location.numFriends)
        
        potentialsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.8, titleLabel.intrinsicContentSize.width + C.w*0.02), y: friendsLabel.intrinsicContentSize.height, width: C.w*0.2, height: C.h*0.05))
        potentialsLabel.textColor = C.redishColor
        potentialsLabel.textAlignment = .left
        potentialsLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        potentialsLabel.text = String(location.numPotentials)
        
        self.addSubview(titleLabel)
        self.addSubview(friendsLabel)
        self.addSubview(potentialsLabel)
        
    }
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        
    }
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        view.addSubview(self)
    }
    
    func dismissCallout(animated: Bool) {
        removeFromSuperview()
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class UserCalloutView: UIView, MGLCalloutView, MGLCalloutViewDelegate {
    
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    var representedObject: MGLAnnotation
    var backgroundView: UIView!
    var chatBackgroundView: UIView!
    var vw: CGFloat!
    var vh: CGFloat!
    let numFriends = 3
    let numPotentials = 10
    let population = 100
    var messagingView: ChatViewController!
    var nameLabel: UILabel!
    var locationLabel: UILabel!
    

    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.delegate = self
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h*0.35))
        backgroundView.backgroundColor = UIColor.white
        //let rectShape = CAShapeLayer()
//        rectShape.bounds = self.backgroundView.frame
//        rectShape.position = self.backgroundView.center
//        rectShape.path = UIBezierPath(roundedRect: self.backgroundView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: C.h*0.1, height: C.h*0.1)).cgPath
//        backgroundView.layer.mask = rectShape
        backgroundView.layer.cornerRadius = backgroundView.frame.width/15.0
        self.addSubview(backgroundView)
        chatBackgroundView = UIView(frame: CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.3))
        chatBackgroundView.backgroundColor = UIColor.gray
        
        let centerLine = UIView(frame: CGRect(x: 0, y: C.h*0.05-1, width: C.w, height: 1))
        centerLine.backgroundColor = C.goldishColor
        backgroundView.addSubview(centerLine)
        
        self.nameLabel = UILabel(frame: CGRect(x: C.w*0.1, y: 0, width: C.w*0.4, height: C.h*0.05))
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
        nameLabel.text = representedObject.title!
        
        self.locationLabel = UILabel(frame: CGRect(x: C.w*0.5, y: 0, width: C.w*0.4, height: C.h*0.05))
        locationLabel.textColor = UIColor.black
        locationLabel.textAlignment = .right
        locationLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
        if (representedObject as! MapAnnotation).location != nil
        {
            locationLabel.text = (representedObject as! MapAnnotation).location.displayName
            self.addSubview(locationLabel)
        }
        
        messagingView = ChatViewController(pv: self, u2: (representedObject as! MapAnnotation).user)
        messagingView.view.frame = chatBackgroundView.frame
        self.parentViewController?.addChildViewController(messagingView)
        self.addSubview(chatBackgroundView)
        self.addSubview(messagingView.view)
        self.addSubview(nameLabel)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callout view delegate: present callout
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        //        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
        //            return
        //        }
        view.isUserInteractionEnabled = true
        frame = CGRect(x: 0, y: C.h*0.575, width: C.w, height: C.h*0.35)
        view.addSubview(self)
    }
        
//
//        let frameWidth = backgroundView.bounds.size.width
//        let frameHeight = backgroundView.bounds   .size.height
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
    func dismissCallout(animated: Bool) {
        C.navigationViewController.eventsButton.isHidden = false
        C.navigationViewController.spottButton.isHidden = false
        C.navigationViewController.mapViewController.centerButton.isHidden = false
        removeFromSuperview()
    }
    
}


class UserAtLocCalloutView: UIView, MGLCalloutView, MGLCalloutViewDelegate {
    
    let dismissesAutomatically: Bool = true
    let isAnchoredToAnnotation: Bool = false
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    var representedObject: MGLAnnotation
    var backgroundView: UIView!
    var chatBackgroundView: UIView!
    var vw: CGFloat!
    var vh: CGFloat!
    let numFriends = 3
    let numPotentials = 10
    let population = 100
    var messagingView: ChatViewController!
    var nameLabel: UILabel!
    
    var potentialsImage: UIImageView!
    var titleView: UIView!
    var titleLabel: UILabel!
    var friendsLabel: UILabel!
    var friendsImage: UIImageView!
    var potentialsLabel: UILabel!
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.delegate = self
        backgroundView = UIView(frame: CGRect(x: 0, y: C.h*0.1, width: C.w, height: C.h*0.35))
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = backgroundView.frame.width / 15.0
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.backgroundView.frame
//        rectShape.position = self.backgroundView.center
//        rectShape.path = UIBezierPath(roundedRect: self.backgroundView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: C.h*0.1, height: C.h*0.1)).cgPath
//        backgroundView.layer.mask = rectShape
        self.addSubview(backgroundView)
        chatBackgroundView = UIView(frame: CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.3))
        chatBackgroundView.backgroundColor = UIColor.gray
        
        let centerLine = UIView(frame: CGRect(x: 0, y: C.h*0.05-1, width: C.w, height: 1))
        centerLine.backgroundColor = C.goldishColor
        backgroundView.addSubview(centerLine)
        
        messagingView = ChatViewController(pv: self, u2: (representedObject as! MapAnnotation).user)
        messagingView.view.frame = chatBackgroundView.frame
        self.parentViewController?.addChildViewController(messagingView)
        self.addSubview(chatBackgroundView)
        self.addSubview(messagingView.view)
        
        self.nameLabel = UILabel(frame: CGRect(x: C.w*0.1, y: 0, width: C.w*0.8, height: C.h*0.05))
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "FuturaPT-Light", size: 18)
        nameLabel.text = representedObject.title!
        backgroundView.addSubview(nameLabel)
        self.titleLabel = UILabel(frame: CGRect(x: C.w*0.1, y: 0, width: C.w*0.5, height: C.h*0.1))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 36)
        titleLabel.text = (representedObject as! MapAnnotation).location.displayName
        
        friendsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.5,titleLabel.intrinsicContentSize.width + C.w*0.02), y: 0, width: C.w*0.2, height: C.h*0.05))
        friendsLabel.textColor = C.greenishColor
        friendsLabel.textAlignment = .left
        friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        friendsLabel.text = String((representedObject as! MapAnnotation).location.numFriends)
        
        potentialsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.5, titleLabel.intrinsicContentSize.width + C.w*0.02), y: friendsLabel.intrinsicContentSize.height, width: C.w*0.2, height: C.h*0.05))
        potentialsLabel.textColor = C.redishColor
        potentialsLabel.textAlignment = .left
        potentialsLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        potentialsLabel.text = String((representedObject as! MapAnnotation).location.numPotentials)
        
        self.addSubview(titleLabel)
        self.addSubview(friendsLabel)
        self.addSubview(potentialsLabel)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callout view delegate: present callout
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        //        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
        //            return
        //        }
        view.isUserInteractionEnabled = true
        frame = CGRect(x: 0, y: C.h*0.45, width: C.w, height: C.h*0.45)
        view.addSubview(self)
    }
    
    //
    //        let frameWidth = backgroundView.bounds.size.width
    //        let frameHeight = backgroundView.bounds   .size.height
    //        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
    //        let frameOriginY = rect.origin.y - frameHeight
    //        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
    func dismissCallout(animated: Bool) {
        C.navigationViewController.eventsButton.isHidden = false
        C.navigationViewController.spottButton.isHidden = false
        C.navigationViewController.mapViewController.centerButton.isHidden = false
        removeFromSuperview()
    }
    
}



extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class EmptyCalloutView: UIView, MGLCalloutView, MGLCalloutViewDelegate {
    var representedObject: MGLAnnotation
    
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    
    var delegate: MGLCalloutViewDelegate?
    
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callout view delegate: present callout
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        
    }
    
    func dismissCallout(animated: Bool) {
    }
    
}
