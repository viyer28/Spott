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
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapAnnotationView: MGLAnnotationView {
    private var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //self.layer.borderWidth = 3.0 as CGFloat
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [C.eventDarkBlueColor.cgColor, C.eventLightBlueColor.cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 5
        //shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.path = UIBezierPath(roundedRect: CGRect(x: 2.5, y: 2.5, width: self.frame.width-5, height: self.frame.height-5), cornerRadius: self.frame.size.width).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        //shape.cornerRadius = self.layer.cornerRadius
        gradient.mask = shape
        //gradient.cornerRadius = self.layer.cornerRadius
        let gradient2 = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient2.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient2.colors = [C.eventLightBrownColor.cgColor, C.eventDarkBrownColor.cgColor]
        self.layer.insertSublayer(gradient2, at: 0)
        self.layer.insertSublayer(gradient, at: 1)
        //self.clipsToBounds = true
        //self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        //imageView.layer.cornerRadius = imageView.frame.size.width / 2;
//        let pointsLabel = UILabel(frame: CGRect(x:5, y: 5, width: 20, height: 20))
//        pointsLabel.textColor = UIColor.black
//        pointsLabel.textAlignment = .center
        //imageView.clipsToBounds = true;
        //imageView.layer.borderWidth = 3.0 as CGFloat
        //imageView.layer.borderColor = UIColor.white.cgColor
        //self.addSubview(self.imageView)
//        pointsLabel.font = UIFont(name: "FuturaPTLight", size: 4)
//        pointsLabel.textColor = UIColor.white
       // self.addSubview(pointsLabel)
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
    var titleView: UIView!
    var titleLabel: UILabel!
    var friendsLabel: UILabel!
    var potentialsLabel: UILabel!
    var scoreLabel: UILabel!
    var kingLabel: UILabel!
    var populationLabel: UILabel!
    var vw: CGFloat!
    var vh: CGFloat!
    let numFriends = 3
    let numPotentials = 10
    let population = 100
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        backgroundView = UIButton(frame: CGRect(x: 0, y: 0, width: C.w*0.4, height: C.h*0.25))
        backgroundView.layer.cornerRadius = backgroundView.frame.size.width / 10
        backgroundView.backgroundColor = UIColor.blue
        self.addSubview(backgroundView)
        backgroundView.addTarget(self, action: #selector(calloutTapped), for: .touchUpInside)
        vw = backgroundView.frame.width
        vh = backgroundView.frame.height
    
        titleView = UIView(frame: CGRect(x: 0, y: vh*0.1, width: vw*0.7, height: vh*0.2))
        titleView.backgroundColor = UIColor.white
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.titleView.frame
        rectShape.position = self.titleView.center
        rectShape.path = UIBezierPath(roundedRect: self.titleView.bounds, byRoundingCorners: [.topRight , .bottomRight], cornerRadii: CGSize(width: backgroundView.frame.size.width / 10, height: backgroundView.frame.size.width / 10)).cgPath
        
        titleView.layer.mask = rectShape
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: vw * 0.7, height: vh*0.2))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        
        populationLabel = UILabel(frame: CGRect(x: vw*0.02, y: vh*0.3, width: vw*0.68, height: vh*0.2))
        populationLabel.textColor = UIColor.white
        populationLabel.textAlignment = .left
        populationLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
        populationLabel.text = "Population: " + String(population)
        
        friendsLabel = UILabel(frame: CGRect(x: vw*0.02, y: vh*0.45, width: vw*0.48, height: vh*0.1))
        friendsLabel.textColor = UIColor.white
        friendsLabel.textAlignment = .left
        friendsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
        friendsLabel.text = "Friends: " + String(numFriends)
        
        potentialsLabel = UILabel(frame: CGRect(x: vw*0.02, y: vh*0.55, width: vw*0.48, height: vh*0.1))
        potentialsLabel.textColor = UIColor.white
        potentialsLabel.textAlignment = .left
        potentialsLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
        potentialsLabel.text="Potentials: " + String(numPotentials)
        
        titleLabel.text = representedObject.title!
        
        
        let blueGradient = CAGradientLayer()
        blueGradient.frame = backgroundView.bounds
        blueGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        blueGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        blueGradient.colors = [C.eventDarkBlueColor.cgColor, C.eventLightBlueColor.cgColor]
        backgroundView.layer.addSublayer(blueGradient)
        backgroundView.clipsToBounds = true
        
//
//        backgroundView.addTarget(self, action: #selector(SpottCalloutView.calloutTapped), for: .touchUpInside)
//
        
        backgroundView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        backgroundView.addSubview(populationLabel)
        backgroundView.addSubview(friendsLabel)
        backgroundView.addSubview(potentialsLabel)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callout view delegate: present callout
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        view.isUserInteractionEnabled = true
//        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
//            return
//        }
        
        view.addSubview(self)
        
        let frameWidth = backgroundView.bounds.size.width
        let frameHeight = backgroundView.bounds.size.height
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        
    }
    @objc func calloutTapped() {
        var mw = CGFloat(0.0)
        var mh = CGFloat(0.0)
        mw = (self.superview?.frame.width)!
        mh = (self.superview?.frame.height)!
        //self.superview?.addSubview(LocationProfileView(frame: CGRect(x: mw * 0.1, y: mh * 0.1, width: mw * 0.8, height: mh * 0.8)))
    }
    
    func calloutViewTapped(_ calloutView: Any!)
    {
        
    }
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y = newCenter.y - bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }
    
    func dismissCallout(animated: Bool) {
        removeFromSuperview()

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
        
        messagingView = ChatViewController(pv: self)
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
        
//
//        let frameWidth = backgroundView.bounds.size.width
//        let frameHeight = backgroundView.bounds   .size.height
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        
    }
    @objc func calloutTapped() {
        let a = 1
        
    }
    
    private func calloutViewTapped(_ calloutView: Any!)
    {
        
    }
    
    func dismissCallout(animated: Bool) {
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
