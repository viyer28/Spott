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
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
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
    
//    required init(representedObject: MGLAnnotation) {
//        self.representedObject = representedObject
//        super.init(frame: .zero)
//        self.isUserInteractionEnabled = true
//        self.frame = CGRect(x: 0, y: 0, width: C.w*0.2, height: C.h*0.05)
//
//        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: C.w * 0.2, height: C.h*0.025))
//        titleLabel.textColor = UIColor.black
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
//
//
//        friendsImage = UIImageView(frame: CGRect(x: 0, y: C.h*0.025, width: C.h*0.025, height: C.h*0.025))
//        friendsImage.image = UIImage(named: "PeopleIcon")
//
//
//        friendsLabel = UILabel(frame: CGRect(x: C.h*0.025, y: C.h*0.025, width: C.h*0.025, height: C.h*0.025))
//        friendsLabel.textColor = UIColor.black
//        friendsLabel.textAlignment = .left
//        friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
//        friendsLabel.text = String(numFriends)
//
//        potentialsLabel = UILabel(frame: CGRect(x: C.w*0.2-C.h*0.025, y: C.h*0.025, width: C.h*0.025, height: C.h*0.025))
//        potentialsLabel.textColor = UIColor.black
//        potentialsLabel.textAlignment = .left
//        potentialsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
//        potentialsLabel.text = String(numPotentials)
//
//        potentialsImage = UIImageView(frame: CGRect(x: C.w*0.2-C.h*0.05, y: C.h*0.025, width: C.h*0.025, height: C.h*0.025))
//        potentialsImage.image = UIImage(named: "PeopleIcon")
//
//        titleLabel.text = representedObject.title!
//        self.addSubview(titleLabel)
//        self.addSubview(friendsLabel)
//        self.addSubview(friendsImage)
//        self.addSubview(potentialsImage)
//        self.addSubview(potentialsLabel)
//
//    }
    convenience init (representedObject: MGLAnnotation, location: Location)
    {
        self.init(representedObject: representedObject)
        self.frame = CGRect(x: 0, y: C.h*0.8, width: C.w, height: C.h*0.2)
        self.titleLabel = UILabel(frame: CGRect(x: C.w*0.1, y: 0, width: C.w*0.5, height: C.h*0.1))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 36)
        titleLabel.text = representedObject.title!
        
        friendsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.5, titleLabel.intrinsicContentSize.width + C.w*0.02), y: 0, width: C.w*0.2, height: C.h*0.05))
        friendsLabel.textColor = UIColor.green
        friendsLabel.textAlignment = .left
        friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        friendsLabel.text = String(location.numFriends)
        
        potentialsLabel = UILabel(frame: CGRect(x: C.w*0.1+min(C.w*0.5, titleLabel.intrinsicContentSize.width + C.w*0.02), y: friendsLabel.intrinsicContentSize.height, width: C.w*0.2, height: C.h*0.05))
        potentialsLabel.textColor = UIColor.red
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
    
    // callout view delegate: present callout
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        view.isUserInteractionEnabled = true
////        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
////            return
////        }
//
//        view.addSubview(self)
//
//        let frameWidth = self.bounds.size.width
//        let frameHeight = self.bounds.size.height/2
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
//
//
//    }
    
//    func calloutViewTapped(_ calloutView: Any!)
//    {
//
//    }
//    override var center: CGPoint {
//        set {
//            var newCenter = newValue
//            newCenter.y = newCenter.y - bounds.midY
//            super.center = newCenter
//        }
//        get {
//            return super.center
//        }
//    }

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
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.delegate = self
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h*0.4))
        backgroundView.backgroundColor = UIColor.white
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.backgroundView.frame
        rectShape.position = self.backgroundView.center
        rectShape.path = UIBezierPath(roundedRect: self.backgroundView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: C.h*0.1, height: C.h*0.1)).cgPath
        backgroundView.layer.mask = rectShape
        self.addSubview(backgroundView)
        chatBackgroundView = UIView(frame: CGRect(x: 0, y: C.h*0.1, width: C.w, height: C.h*0.3))
        chatBackgroundView.backgroundColor = UIColor.gray
        
        messagingView = ChatViewController(pv: self, u2: (representedObject as! MapAnnotation).user)
        messagingView.view.frame = chatBackgroundView.frame
        self.parentViewController?.addChildViewController(messagingView)
        self.addSubview(chatBackgroundView)
        self.addSubview(messagingView.view)
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
        frame = CGRect(x: 0, y: C.h*0.6, width: C.w, height: C.h*0.4)
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
