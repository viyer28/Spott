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
import Firebase
class TabBarViewController: UITabBarController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    let eventsnc = UINavigationController(rootViewController: EventsViewController())
    let peoplevc = PeopleViewController()
    var lastUpdate = NSDate()
    var mapvc = MapViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBar.unselectedItemTintColor = UIColor.clear
        self.tabBar.backgroundColor = UIColor.clear
        self.tabBar.barTintColor = UIColor.clear
        viewControllers = [eventsnc, mapvc, peoplevc]
        //feednc.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "FeedIcon"), tag: 1)
        eventsnc.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "EventsIcon"), tag: 1)
        mapvc.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "MapIcon"), tag: 1)
        peoplevc.tabBarItem = UITabBarItem(title: "People", image: UIImage(named: "PeopleIcon"), tag: 1)
        //profilevc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ProfileIcon"), tag: 1)
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
        let uLoc:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        //self.userLocation = CLLocation(latitude: uLoc.coordinate.latitude, longitude: uLoc.coordinate.longitude)
        
        
        if (NSDate().timeIntervalSince(lastUpdate as Date) > 30)
        {
            let ref = Firestore.firestore().collection("user_info").document(C.refid)
            lastUpdate = NSDate()
            // Set the "capital" field of the city 'DC'
            ref.updateData([
                "longitude": uLoc.coordinate.longitude,
                "latitude": uLoc.coordinate.latitude
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
