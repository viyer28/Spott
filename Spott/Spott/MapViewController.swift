//
//  ViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 1/30/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Mapbox

let MapboxAccessToken = "pk.eyJ1IjoiYnJlbmRhbnNhbmRlcnNvbiIsImEiOiJjamQ2cWNubWkxNWNvMndsYjhrdXp1M2F2In0.eci8-9HsaFn0aAEVn-K8Uw"
class MapViewController: UIViewController, MGLMapViewDelegate {
    var mapView:MGLMapView!
    var tabBar:TabBarViewController!
    var profileButton = UIButton(type: UIButtonType.custom) as UIButton
    var friendsButton = UIButton(type: UIButtonType.custom) as UIButton
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MGLAccountManager.setAccessToken(MapboxAccessToken)
        let url = MGLStyle.lightStyleURL(withVersion: 9)
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h), styleURL: url)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        mapView.showsUserLocation = true;
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        

        let image = UIImage(named: "PeopleIcon") as UIImage?
        friendsButton = UIButton(type: UIButtonType.custom) as UIButton
        friendsButton.backgroundColor = UIColor.white
        friendsButton.frame = CGRect(x: C.w*0.9, y: C.w*0.2, width: C.w * 0.07, height: C.w * 0.07)
        friendsButton.imageView?.frame = CGRect(x: C.w*0.9, y: C.w*0.2, width: C.w * 0.05, height: C.w * 0.05)
        friendsButton.imageView?.center = friendsButton.center
        friendsButton.layer.cornerRadius = friendsButton.frame.width/2
        friendsButton.clipsToBounds = true
        friendsButton.setImage(image, for: .normal)
        friendsButton.imageView?.image = image
        friendsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        friendsButton.addTarget(self, action: #selector(showFriends), for: UIControlEvents.touchUpInside)
        self.view.addSubview(friendsButton)
        
        let image1 = UIImage(named: "ProfileIcon") as UIImage?
        profileButton.frame = CGRect(x: C.w*0.9, y: C.w*0.1, width: C.w * 0.07, height: C.w * 0.07)
        profileButton.backgroundColor = UIColor.white
        profileButton.layer.cornerRadius = profileButton.frame.width/2
        profileButton.clipsToBounds = true
        profileButton.backgroundColor = UIColor.white
        profileButton.setImage(image1, for: .normal)
        profileButton.addTarget(self, action: #selector(showProfile), for: UIControlEvents.touchUpInside)
        profileButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        self.view.addSubview(profileButton)
        
        
        self.title = "Map";
        
    }
    override func viewDidAppear(_ animated: Bool) {
        mapView.setCenter(NavigationViewController.userLocation.coordinate, zoomLevel: 15, animated: false)
        updateAnnotations()
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
        {
            var view: MapUserAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "mapUserAnnotation") as? MapUserAnnotationView
            if view == nil {
                view = MapUserAnnotationView(reuseIdentifier: "mapAnnotation")
            }
            return view
        }
        
        
        //    // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        var view: MapAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "mapAnnotation") as? MapAnnotationView
        if view == nil {
            view = MapAnnotationView(reuseIdentifier: "mapAnnotation")
        }
        
        return view
    }
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
        {
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            return UserCalloutView(representedObject: annotation)
            
        }
        return SpottCalloutView(representedObject: annotation)
    }
//    func mapView(_ mapView: MGLMapView, tapOnCalloutForAnnotation annotation: Any)
//    {
//
//    }
//
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    @objc func showFriends ()
    {
        
    }
    
    @objc func showProfile ()
    {
        self.present(ProfileViewController(), animated: true, completion: nil)
    }
    func updateAnnotations()
    {
        if mapView.annotations != nil
        {
            mapView.removeAnnotations(mapView.annotations!)
        }
        for location in C.locations {
            let point = MapAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude:  location.latitude, longitude:  location.longitude)
            point.title = location.name
            point.type = 0
            mapView.addAnnotation(point)
        }
        for friend in C.user.friends {
            let point = MapAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude:  friend.latitude, longitude:  friend.longitude)
            point.title = friend.name
            point.type = 1
            mapView.addAnnotation(point)
        }
    }
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        if let source = style.source(withIdentifier: "composite") {
            let layer = MGLFillExtrusionStyleLayer(identifier: "buildings", source: source)
            layer.sourceLayerIdentifier = "building"
            
            // Filter out buildings that should not extrude.
            layer.predicate = NSPredicate(format: "extrude == 'true' AND height >= 0")
            
            // Set the fill extrusion height to the value for the building height attribute.
            layer.fillExtrusionHeight = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "height", options: nil)
            layer.fillExtrusionBase = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "min_height", options: nil)
            layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.75)
            layer.fillExtrusionColor = MGLStyleValue(rawValue: .white)
            
            // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }

    
}

