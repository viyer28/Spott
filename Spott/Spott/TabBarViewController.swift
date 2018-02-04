//
//  TabBarViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 1/30/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
class TabBarViewController: UITabBarController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    let feednc = UINavigationController(rootViewController: FeedViewController())
    let eventsnc = UINavigationController(rootViewController: EventsViewController())
    let mapnc = UINavigationController(rootViewController: MapViewController())
    let peoplenc = UINavigationController(rootViewController: PeopleViewController())
    let profilenc = UINavigationController(rootViewController: ProfileViewController())
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var mapvc: MapViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = C.darkColor
        mapvc = (mapnc.viewControllers[0] as! MapViewController)
        viewControllers = [feednc, eventsnc, mapnc, peoplenc, profilenc]
        feednc.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "FeedIcon"), tag: 1)
        eventsnc.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "EventsIcon"), tag: 1)
        mapnc.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "MapIcon"), tag: 1)
        peoplenc.tabBarItem = UITabBarItem(title: "People", image: UIImage(named: "PeopleIcon"), tag: 1)
        profilenc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ProfileIcon"), tag: 1)
        determineCurrentLocation()
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
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
