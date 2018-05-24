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
    var userLocation = CLLocation(latitude: 0, longitude: 0)
    var onboarding = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        mapViewController = MapViewController()
        setViewControllers([mapViewController], direction: .forward, animated: false, completion: nil)
        addNav()
        if (onboarding == 1)
        {
            startOnboarding()
        }
    }
    
    func addNav()
    {
        self.spottButton = UIButton(type: UIButtonType.custom) as UIButton
        self.mapButton = UIButton(type: UIButtonType.custom) as UIButton
        self.eventsButton = UIButton(type: UIButtonType.custom) as UIButton
        
        mapButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.15, height: C.w * 0.15)
        mapButton.center = CGPoint(x: C.w*0.5, y: C.h*0.95)
        mapButton.setImage(UIImage(named: "centerUser"), for: .normal)
        mapButton.subviews.first?.contentMode = .scaleAspectFit
        mapButton.addTarget(self, action: #selector(clickMap), for: UIControlEvents.touchUpInside)
        
        
        
        eventsButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.075, height: C.w * 0.075)
        eventsButton.center = CGPoint(x: C.w*0.25, y: C.h*0.95)
        eventsButton.setImage(UIImage(named: "eventsIcon"), for: .normal)
        eventsButton.imageView?.contentMode = .scaleAspectFit
        eventsButton.addTarget(self, action: #selector(clickEvents), for: UIControlEvents.touchUpInside)
        
        spottButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        spottButton.center = CGPoint(x: C.w*0.75, y: C.h*0.95)
        spottButton.setImage(UIImage(named: "connectionIcon"), for: .normal)
        spottButton.imageView?.contentMode = .scaleAspectFit
        spottButton.addTarget(self, action: #selector(clickSpott), for: UIControlEvents.touchUpInside)
        if C.user.business == 0
        {
            self.view.addSubview(eventsButton)
            self.view.addSubview(mapButton)
            self.view.addSubview(spottButton)
        }
        mapButton.isHidden = true
        
    }
    
    @objc func clickMap ()
    {
        switch self.selected {
        case 2:
            selected = 2
        default:
//            mapButton.imageView?.tintColor = UIColor.black
//            mapButton.backgroundColor = C.goldishColor
//            spottButton.imageView?.tintColor = C.goldishColor
//            spottButton.backgroundColor = UIColor.black
//            eventsButton.imageView?.tintColor = C.goldishColor
//            eventsButton.backgroundColor = UIColor.black
            eventsButton.isHidden = false
            spottButton.isHidden = false
            mapButton.isHidden = true
            self.mapViewController.mapView.isUserInteractionEnabled = true
            if selected == 1
            {
                eventsViewController.view.removeFromSuperview()
                eventsViewController.removeFromParentViewController()
                
            }
            else
            { //setViewControllers([mapViewController], direction: .reverse, animated: true, completion: nil)
                peopleViewController.view.removeFromSuperview()
                peopleViewController.removeFromParentViewController()
            }
            selected = 2
            self.mapViewController.updateAnnotations()
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
            self.mapViewController.deselectCallouts()
            eventsButton.isHidden = true
            spottButton.isHidden = true
            mapButton.isHidden = false
            //self.mapViewController.mapView.isUserInteractionEnabled = false
            selected = 3
            //setViewControllers([peopleViewController], direction: .forward, animated: true, completion: nil)
            self.mapViewController.view.addSubview(peopleViewController.view)
            self.mapViewController.addChildViewController(peopleViewController)
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
            self.mapViewController.deselectCallouts()
            eventsButton.isHidden = true
            spottButton.isHidden = true
            mapButton.isHidden = false
            self.mapViewController.mapView.isUserInteractionEnabled = false
            selected = 1
            //setViewControllers([eventsViewController], direction: .reverse, animated: true, completion: nil)
            self.mapViewController.mapView.addSubview(eventsViewController.view)
            self.mapViewController.addChildViewController(eventsViewController)
            self.view.bringSubview(toFront: mapButton)
            self.view.bringSubview(toFront: spottButton)
            self.view.bringSubview(toFront: eventsButton)
        }
    }
    
    func determineCurrentLocation()
    {
        if locationManager == nil
        {
            locationManager = CLLocationManager()
        }
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if locationManager.location != nil{
            self.userLocation = locationManager.location!
        }
        findUserLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func findUserLocation()
    {
        let loc = C.user.curLoc
        for feature in C.features
        {
            if (feature.geometries?.first?.contains(Waypoint(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)!))!
            {
                C.user.curLoc = feature.properties!["id"] as! Int
            }
        }
        if Auth.auth().currentUser != nil && loc != C.user.curLoc
        {
            let ref = Firestore.firestore().collection(C.userInfo).document(C.refid)
            ref.updateData([
                "curLoc" : C.user.curLoc,
                "longitude": userLocation.coordinate.longitude,
                "latitude": userLocation.coordinate.latitude
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        C.updateUsersLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let uLoc:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        self.userLocation = CLLocation(latitude: uLoc.coordinate.latitude, longitude: uLoc.coordinate.longitude)
        
        
        var curLoc = -1
        
        for feature in C.features
        {
            if (feature.geometries?.first?.contains(Waypoint(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)!))!
            {
                curLoc = feature.properties!["id"] as! Int
            }
        }
        
        
        if (NSDate().timeIntervalSince(lastUpdate as Date) > 10 || C.user.curLoc != curLoc)
        {
            C.user.curLoc = curLoc
            C.updateUsersLocation()
            C.updateFriendsLocations()
            if Auth.auth().currentUser != nil
            {
                let ref = Firestore.firestore().collection(C.userInfo).document(C.refid)
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
            
        }
        
        if (NSDate().timeIntervalSince(C.lastLocationUpdate as Date) > 30)
        {
            C.updateLocations()
            C.lastLocationUpdate = NSDate()
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
    
    func startOnboarding()
    {
        self.eventsButton.isHidden = true
        self.spottButton.isHidden = true
        self.mapButton.isHidden = true
        self.mapViewController.textField.isHidden = true
        self.mapViewController.mapView.setCenter(self.userLocation.coordinate, animated: false)
        self.mapViewController.view.isUserInteractionEnabled = false
        determineCurrentLocation()
        while locationManager.location == nil
        {
            
        }
        self.userLocation = locationManager.location!
        C.navigationViewController.mapViewController.mapView.setCenter(C.navigationViewController.userLocation.coordinate, zoomLevel: 1, animated: false)
        let onboardingViewController = OnboardingViewController()
        self.view.addSubview(onboardingViewController.view)
        self.addChildViewController(onboardingViewController)
    }
    func finishOnboarding()
    {
        self.eventsButton.isHidden = false
        self.spottButton.isHidden = false
        self.mapButton.isHidden = false
        self.mapViewController.textField.isHidden = false
        self.mapViewController.view.isUserInteractionEnabled = true
        self.mapViewController.mapView.zoomLevel = 1
        self.mapViewController.mapView.setCenter(C.navigationViewController.userLocation.coordinate, zoomLevel: 15, animated: false)
        self.onboarding = 0
        
    }
}
