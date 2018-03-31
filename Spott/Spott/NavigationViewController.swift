//
//  File.swift
//  Spott
//
//  Created by Brendan Sanderson on 3/30/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import Firebase
import GEOSwift
class NavigationViewController : UIPageViewController, CLLocationManagerDelegate
{
    var mapButton: UIButton!
    var eventsButton: UIButton!
    var spottButton: UIButton!
    var locationManager:CLLocationManager!
    var lastUpdate = NSDate()
    var peopleViewController = PeopleViewController()
    var eventsViewController = EventsViewController()
    var mapViewController: MapViewController!
    var selected = 2
    static var userLocation = CLLocation(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        mapViewController = MapViewController()
        setViewControllers([mapViewController], direction: .forward, animated: false, completion: nil)
        addNav()
    }
    
    func addNav()
    {
        var mImage = UIImage(named: "MapIcon") as UIImage?
        mImage = mImage?.withRenderingMode(.alwaysTemplate)
        self.spottButton = UIButton(type: UIButtonType.custom) as UIButton
        self.mapButton = UIButton(type: UIButtonType.custom) as UIButton
        self.eventsButton = UIButton(type: UIButtonType.custom) as UIButton
        mapButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        mapButton.center = CGPoint(x: C.w*0.5, y: C.h*0.95)
        mapButton.layer.borderColor = C.goldishColor.cgColor
        mapButton.layer.borderWidth = 1.0
        mapButton.setImage(mImage, for: .normal)
        mapButton.backgroundColor = UIColor.white
        mapButton.imageView?.tintColor = C.goldishColor
        mapButton.layer.cornerRadius = mapButton.frame.width/2
        mapButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        mapButton.clipsToBounds = true
        mapButton.addTarget(self, action: #selector(clickMap), for: UIControlEvents.touchUpInside)
        self.view.addSubview(mapButton)
        
        var eImage = UIImage(named: "EventsIcon") as UIImage?
        eImage = eImage?.withRenderingMode(.alwaysTemplate)
        eventsButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        eventsButton.center = CGPoint(x: C.w*0.25, y: C.h*0.95)
        eventsButton.setImage(eImage, for: .normal)
        eventsButton.layer.borderColor = UIColor.black.cgColor
        eventsButton.layer.borderWidth = 1.0
        eventsButton.backgroundColor = UIColor.white
        eventsButton.imageView?.tintColor = UIColor.black
        eventsButton.layer.cornerRadius = mapButton.frame.width/2
        eventsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        eventsButton.clipsToBounds = true
        eventsButton.addTarget(self, action: #selector(clickEvents), for: UIControlEvents.touchUpInside)
        self.view.addSubview(eventsButton)
        
        var sImage = UIImage(named: "PeopleIcon") as UIImage?
        sImage = sImage?.withRenderingMode(.alwaysTemplate)
        spottButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        spottButton.center = CGPoint(x: C.w*0.75, y: C.h*0.95)
        spottButton.backgroundColor = UIColor.white
        spottButton.layer.borderColor = UIColor.black.cgColor
        spottButton.layer.borderWidth = 1.0
        spottButton.imageView?.tintColor = UIColor.black
        spottButton.layer.cornerRadius = mapButton.frame.width/2
        spottButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        spottButton.setImage(sImage, for: .normal)
        spottButton.clipsToBounds = true
        spottButton.addTarget(self, action: #selector(clickSpott), for: UIControlEvents.touchUpInside)
        self.view.addSubview(spottButton)
        
    }
    
    @objc func clickMap ()
    {
        switch self.selected {
        case 2:
            selected = 2
        default:
            mapButton.imageView?.tintColor = C.goldishColor
            spottButton.imageView?.tintColor = UIColor.black
            eventsButton.imageView?.tintColor =  UIColor.black
            mapButton.layer.borderColor = C.goldishColor.cgColor
            spottButton.layer.borderColor = UIColor.black.cgColor
            eventsButton.layer.borderColor = UIColor.black.cgColor
            if selected == 1
            { setViewControllers([mapViewController], direction: .forward, animated: true, completion: nil) }
            else
            { setViewControllers([mapViewController], direction: .reverse, animated: true, completion: nil) }
            selected = 2
            self.view.bringSubview(toFront: mapButton)
            self.view.bringSubview(toFront: spottButton)
            self.view.bringSubview(toFront: eventsButton)
        }
    }
    
    @objc func clickSpott()
    {
        switch self.selected {
        case 3:
            selected = 3
        default:
            mapButton.imageView?.tintColor = UIColor.black
            spottButton.imageView?.tintColor = C.goldishColor
            eventsButton.imageView?.tintColor = UIColor.black
            mapButton.layer.borderColor = UIColor.black.cgColor
            spottButton.layer.borderColor = C.goldishColor.cgColor
            eventsButton.layer.borderColor = UIColor.black.cgColor
            selected = 3
            setViewControllers([peopleViewController], direction: .forward, animated: true, completion: nil)
            self.view.bringSubview(toFront: mapButton)
            self.view.bringSubview(toFront: spottButton)
            self.view.bringSubview(toFront: eventsButton)
        }
    }
    
    @objc func clickEvents()
    {
        switch self.selected {
        case 1:
            selected = 1
        default:
            mapButton.imageView?.tintColor = UIColor.black
            eventsButton.imageView?.tintColor = C.goldishColor
            spottButton.imageView?.tintColor = UIColor.black
            mapButton.layer.borderColor = UIColor.black.cgColor
            spottButton.layer.borderColor = UIColor.black.cgColor
            eventsButton.layer.borderColor = C.goldishColor.cgColor
            selected = 1
            setViewControllers([eventsViewController], direction: .reverse, animated: true, completion: nil)
            self.view.bringSubview(toFront: mapButton)
            self.view.bringSubview(toFront: spottButton)
            self.view.bringSubview(toFront: eventsButton)
        }
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        NavigationViewController.userLocation = locationManager.location!
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let uLoc:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        NavigationViewController.userLocation = CLLocation(latitude: uLoc.coordinate.latitude, longitude: uLoc.coordinate.longitude)
        
        var curLoc = -1
        if (NSDate().timeIntervalSince(lastUpdate as Date) > 30)
        {
            for feature in C.features
            {
                if (feature.geometries?.first?.contains(Waypoint(latitude: NavigationViewController.userLocation.coordinate.latitude, longitude: NavigationViewController.userLocation.coordinate.longitude)!))!
                {
                    curLoc = feature.properties!["id"] as! Int
                }
            }
            let ref = Firestore.firestore().collection("user_info").document(C.refid)
            lastUpdate = NSDate()
            // Set the "capital" field of the city 'DC'
            ref.updateData([
                "longitude": uLoc.coordinate.longitude,
                "latitude": uLoc.coordinate.latitude,
                "curLoc" : curLoc
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //mapvc.mapView.setRegion(region, animated: false)
        
        // Drop a pin at user's Current Location
        //        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        //        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        //        myAnnotation.title = "Current location"
        //        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}