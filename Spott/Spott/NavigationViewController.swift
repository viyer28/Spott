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
import AVFoundation
import AVKit

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
    var helpView: UIView!
    var selected = 2
    var userLocation = CLLocation(latitude: 0, longitude: 0)
    var onboarding = 0
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        mapViewController = MapViewController()
        
        helpView = UIView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h))
        helpView.backgroundColor = .white
        helpView.isHidden = true
        
//        let helpVideoView = UIView(frame: CGRect(x: C.w * 0.15, y: C.h * 0.15, width: C.w * 0.7, height: C.h * 0.7))
//        helpImageView.backgroundColor = C.goldishColor
//        helpView.addSubview(helpImageView)
        self.view.addSubview(helpView)
        
        let filepath: String? = Bundle.main.path(forResource: "tutorial", ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: C.w * 0.15, y: C.h * 0.15, width: C.w * 0.7, height: C.h * 0.7)
        helpView.addSubview(avPlayerController.view)
        avPlayerController.showsPlaybackControls = false
        avPlayerController.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem, queue: nil) { (_) in
            self.avPlayer.seek(to: kCMTimeZero)
            self.avPlayer.play()
        }
        
        helpView.addSubview(avPlayerController.view)
        
        let helpLabel = UILabel(frame: CGRect(x: C.w * 0.1, y: C.h * 0.825, width: C.w * 0.8, height: C.h * 0.1))
        helpLabel.font = UIFont(name: "FuturaPT-Light", size: 14.0)
        helpLabel.numberOfLines = 2
        helpLabel.lineBreakMode = .byWordWrapping
        helpLabel.text = "please reach out to dayo adeosun for user feedback!!! \n be honest and don't be shy :)"
        helpLabel.textAlignment = .center
        helpView.addSubview(helpLabel)
        
        let helpLabel2 = UILabel(frame: CGRect(x: C.w * 0.1, y: C.h * 0.925, width: C.w * 0.8, height: C.h * 0.05))
        helpLabel2.font = UIFont(name: "FuturaPT-Light", size: 12.0)
        helpLabel2.text = "made by brendan, varun and dayo with love <3"
        helpLabel2.textAlignment = .center
        helpView.addSubview(helpLabel2)
        
        let helpLabel3 = UILabel(frame: CGRect(x: C.w * 0.1, y: C.h * 0.95, width: C.w * 0.8, height: C.h * 0.05))
        helpLabel3.font = UIFont(name: "FuturaPT-Light", size: 8.0)
        helpLabel3.text = "map powered by ©MapBox"
        helpLabel3.textAlignment = .center
        helpView.addSubview(helpLabel3)
        
        let helpButton = UIButton(type: UIButtonType.custom) as UIButton
        helpButton.frame = CGRect(x: C.w * 0.11, y: C.h * 0.11, width: C.h * 0.04, height: C.h * 0.04)
        helpButton.setImage(UIImage(named: "helpy"), for: .normal)
        helpButton.subviews.first?.contentMode = .scaleAspectFit
        helpButton.addTarget(self, action: #selector(stopTutorial), for: UIControlEvents.touchUpInside)
        setViewControllers([mapViewController], direction: .forward, animated: false,    completion: nil)
        addNav()
        helpView.addSubview(helpButton)
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
        
        let image1:UIImage = UIImage(named: "home1")!
        let image2:UIImage = UIImage(named: "home2")!
        let image3:UIImage = UIImage(named: "home3")!
        let image4:UIImage = UIImage(named: "home4")!
        let image5:UIImage = UIImage(named: "home5")!
        let image6:UIImage = UIImage(named: "home6")!
        let image7:UIImage = UIImage(named: "home7")!
        let image8:UIImage = UIImage(named: "home8")!
        mapButton.imageView!.animationImages = [image1, image2, image3, image4, image5, image6, image7, image8]
        mapButton.imageView!.animationDuration = 0.8
        mapButton.imageView!.startAnimating()
        
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
            self.mapViewController.textField.isUserInteractionEnabled = true
            self.mapViewController.helpButton.isHidden = false
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
            self.mapViewController.helpButton.isHidden = true
            //self.mapViewController.mapView.isUserInteractionEnabled = false
            selected = 3
            //setViewControllers([peopleViewController], direction: .forward, animated: true, completion: nil)
            self.mapViewController.view.addSubview(peopleViewController.view)
            self.mapViewController.addChildViewController(peopleViewController)
            self.mapViewController.textField.isUserInteractionEnabled = false
            self.mapViewController.mapView.isUserInteractionEnabled = false
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
            self.mapViewController.helpButton.isHidden = true
            //self.mapViewController.mapView.isUserInteractionEnabled = false
            selected = 1
            //setViewControllers([eventsViewController], direction: .reverse, animated: true, completion: nil)
            self.mapViewController.view.addSubview(eventsViewController.view)
            self.mapViewController.addChildViewController(eventsViewController)
            self.mapViewController.textField.isUserInteractionEnabled = false
            self.mapViewController.mapView.isUserInteractionEnabled = false
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
    
    @objc func stopTutorial()
    {
        self.helpView.isHidden = true
        self.spottButton.isHidden = false
        self.eventsButton.isHidden = false
        self.avPlayer.pause()
        self.avPlayer.seek(to: kCMTimeZero)
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
        
        
        if (NSDate().timeIntervalSince(lastUpdate as Date) > 30 || C.user.curLoc != curLoc)
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
        self.mapViewController.helpButton.isHidden = true
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
        self.mapViewController.helpButton.isHidden = false
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
