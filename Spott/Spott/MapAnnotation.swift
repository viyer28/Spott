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

class MapAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class MapAnnotationView: MGLAnnotationView {
    private var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = C.darkColor
        self.layer.borderWidth = 3.0 as CGFloat
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.layer.cornerRadius = self.frame.size.width / 2
        //self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        //imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        let pointsLabel = UILabel(frame: CGRect(x:5, y: 5, width: 20, height: 20))
        pointsLabel.textColor = UIColor.black
        pointsLabel.textAlignment = .center
        //imageView.clipsToBounds = true;
        //imageView.layer.borderWidth = 3.0 as CGFloat
        //imageView.layer.borderColor = UIColor.white.cgColor
        //self.addSubview(self.imageView)
        pointsLabel.font = UIFont(name: "FuturaPTLight", size: 4)
        pointsLabel.textColor = UIColor.white
        pointsLabel.text="8"
        self.addSubview(pointsLabel)
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
    var backgroundView: UIView!
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: C.w*0.3, height: C.h*0.2))
        backgroundView.layer.cornerRadius = backgroundView.frame.size.width / 10
        backgroundView.backgroundColor = UIColor.white
        self.addSubview(backgroundView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callout view delegate: present callout
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
//            return
//        }
        print(3)
        view.addSubview(self)
        
        let frameWidth = backgroundView.bounds.size.width
        let frameHeight = backgroundView.bounds.size.height
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        
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

