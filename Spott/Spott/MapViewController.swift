//
//  ViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 1/30/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit
import MapKit

import Mapbox
let MapboxAccessToken = "pk.eyJ1IjoiYnJlbmRhbnNhbmRlcnNvbiIsImEiOiJjamQ2cWNubWkxNWNvMndsYjhrdXp1M2F2In0.eci8-9HsaFn0aAEVn-K8Uw"
class MapViewController: UIViewController, MGLMapViewDelegate {
    var mapView:MGLMapView!
    var tabBar:TabBarViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        MGLAccountManager.setAccessToken(MapboxAccessToken)
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h), styleURL: url)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        mapView.showsUserLocation = true;
        self.title = "Map";
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude:  41.792212, longitude:  -87.599573)
        point.title = "Regenstein Library"
        mapView.addAnnotation(point)
        //mapView.addAnnotation(myAnnotation)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        mapView.setCenter(TabBarViewController.userLocation.coordinate, zoomLevel: 15, animated: false)
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        //    // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        var view: MapAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "mapAnnotation") as? MapAnnotationView
        if view == nil {
            view = MapAnnotationView(reuseIdentifier: "mapAnnotation")
        }
        return view
    }
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        return SpottCalloutView(representedObject: annotation)
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout.
        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }

}

