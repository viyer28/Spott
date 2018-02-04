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
        
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.backgroundColor = C.darkColor
        self.layer.borderWidth = 3.0 as CGFloat
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
    
//    override var image: UIImage? {
//        get {
//            return self.imageView.image
//        }
//
//        set {
//            //self.imageView.image = newValue
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class SpottCalloutView: UIView, MGLCalloutView {
//    var representedObject: MGLAnnotation
//    
//    var leftAccessoryView: UIView
//    
//    var rightAccessoryView: UIView
//    
//    var delegate: MGLCalloutViewDelegate?
//    
//    required init(representedObject: MGLAnnotation) {
//        super.init(representedObject: representedObject)
//        print(1)
//    }
//    
//    required init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func dismissCallout(animated: Bool) {
//        return
//    }
//    
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        print(1)
//    }

}
