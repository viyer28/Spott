//
//  MapViewController.swift
//  spott
//
//  Created by Varun Iyer on 7/19/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    var mapView: MGLMapView!
    var locationManager: CLLocationManager!
    var welcomeViewController = WelcomeViewController()
    var tutorialViewController = TutorialViewController()
    var searchViewController = SearchViewController()
    var spottViewController = SpottViewController()
    var userAnnotationView: UserLocationAnnotationView!
    var userLocation = CLLocation(latitude: 0, longitude: 0)
    
    var button: UIButton!
    var spottButton: UIButton!
    var searchButton: UIButton!
    
    var welcomeImg: UIImageView!
    
    var zoom: Bool!
    
    var blurView: UIVisualEffectView!
    
    var searchBlurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        B.welcome = true
        zoom = false
        
        let url = URL(string: "mapbox://styles/spottiyer/cjjynoird3zwl2spkan0hgqs1")
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: B.w, height: B.h), styleURL: url)
        B.zoomLevel = 1
        mapView.delegate = self
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.compassView.isHidden = true
        mapView.center = view.center
        mapView.showsUserLocation = false
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        
        view.addSubview(mapView)
        
        spottButton = UIButton()
        spottButton.layer.contents = UIImage(named: "spott-icon")?.cgImage
        spottButton.layer.contentsGravity = kCAGravityResizeAspect
        spottButton.layer.isGeometryFlipped = true
        spottButton.layer.shadowRadius = 1
        spottButton.layer.shadowOpacity = 0.1
        spottButton.alpha = 0
        spottButton.addTarget(self, action: #selector(spottNav), for: .touchUpInside)
        
        let blur1 = UIBlurEffect(style: .light)
        searchBlurView = UIVisualEffectView(effect: blur1)
        searchBlurView.alpha = 0
        searchBlurView.layer.cornerRadius = 50
        //searchBlurView.layer.addGradientBorder(colors: [UIColor.black, UIColor.red], width: 2)
        searchBlurView.layer.borderColor = UIColor.lightGray.cgColor
        searchBlurView.layer.borderWidth = 1
        spottButton.layer.shadowRadius = 1
        spottButton.layer.shadowOpacity = 0.1
        searchBlurView.layer.masksToBounds = true
        
        
        searchButton = UIButton()
        searchButton.layer.contents = UIImage(named: "goldsearch")?.cgImage
        searchButton.layer.contentsGravity = kCAGravityResizeAspect
        searchButton.layer.isGeometryFlipped = true
        searchButton.alpha = 0
        searchButton.addTarget(self, action: #selector(searchNav), for: .touchUpInside)
        
        let blur2 = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur2)
        blurView.frame = UIScreen.main.bounds
        blurView.alpha = 0.3
        view.addSubview(blurView)
        
        if (B.welcome) {
            view.addSubview(welcomeViewController.view)
            addChildViewController(welcomeViewController)
        }
        
        mapPulse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAnnotations()
    }
    
    @objc func spottNav() {
        searchButton.isHidden = true
        searchBlurView.isHidden = true
        view.addSubview(spottViewController.view)
        addChildViewController(spottViewController)
        spottButton.addTarget(self, action: #selector(spottReNav), for: .touchUpInside)
    }
    
    @objc func spottReNav() {
        searchButton.isHidden = false
        searchBlurView.isHidden = false
        spottViewController.removeFromParentViewController()
        spottButton.addTarget(self, action: #selector(spottNav), for: .touchUpInside)
    }
    
    @objc func searchNav() {
        view.addSubview(searchViewController.view)
        addChildViewController(searchViewController)
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
        print(userLocation.coordinate)
        //findUserLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        zoomMap()
    }
    
    func finishWelcome() {
        self.welcomeImg = UIImageView(image: #imageLiteral(resourceName: "welcome"))
        self.welcomeImg.contentMode = .scaleAspectFit
        self.welcomeImg.alpha = 0
        self.view.addSubview(self.welcomeImg)
        self.welcomeImg.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
            make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
            make.height.equalTo(50)
            make.top.equalTo(self.view.snp.top).offset(200)
        }
        
        welcomeFadeIn()
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            self.userAnnotationView = UserLocationAnnotationView()
            return self.userAnnotationView
        }
        
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1 {
            let view = FriendAnnotationView(reuseIdentifier: "friendAnnotation", user: (annotation as! MapAnnotation).user)
            return view
        }
        
        let view = LocationAnnotationView(reuseIdentifier: "locationAnnotation", location: (annotation as! MapAnnotation).location)
        
        return view
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        
        if annotation.isKind(of: MapAnnotation.self)
        {
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        }
        
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 0
        {
            return LocationCalloutView(representedObject: annotation)
        } else if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
        {
            return FriendCalloutView(representedObject: annotation)
        } else if annotation.isKind(of: MGLUserLocation.self) {
            //profileView.isHidden = false
            //profileView.tableView.reloadData()
            return EmptyCalloutView(representedObject: annotation)
        }
        
        return EmptyCalloutView(representedObject: annotation)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func updateAnnotations()
    {
        if mapView != nil
        {
            var v: [String] = []
            
            if mapView.annotations != nil{
                mapView.removeAnnotations(mapView.annotations!)
            }
            
            for location in B.locations {
                let point = MapAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                point.title = location.displayName
                point.location = location
                point.type = 0
                mapView.addAnnotation(point)
                
                v.append(location.name)
            }
            
            for friend in B.user.friends {
                let point = MapAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
                point.title = friend.firstName + " " + friend.lastName
                point.user = friend
                point.type = 1
                mapView.addAnnotation(point)
                
                v.append(friend.firstName + " " + friend.lastName)
            }
        }
    }
    
    // Optional: tap the user location annotation to toggle heading tracking mode.
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if mapView.userTrackingMode != .followWithHeading {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.resetNorth()
        }
        
        // We're borrowing this method as a gesture recognizer, so reset selection state.
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    // MARK: Animations
    
    func zoomMap() {
        if (B.zoomLevel >= 15) {
            blurView.removeFromSuperview()
            zoom = false
            finishWelcome()
            return
        }
        if (zoom) {
            B.zoomLevel += 1
            B.mapViewController.mapView.setCenter(userLocation.coordinate, zoomLevel: B.zoomLevel, direction: 0, animated: true, completionHandler: zoomMap)
        }
    }
    
    func welcomeFadeIn(){
        self.mapView.showsUserLocation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.welcomeImg.alpha = 1
            })
            self.welcomeFadeOut()
        })
    }
    
    func welcomeFadeOut(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.welcomeImg.alpha = 0
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            UIImageView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
                self.userAnnotationView.dot.opacity = 1
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            self.view.addSubview(self.tutorialViewController.view)
            self.addChildViewController(self.tutorialViewController)
        })
        
    }
    
    func mapPulse() {
        UIVisualEffectView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.blurView.alpha = 0.45
        }, completion: nil)
    }
}

final class UserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 48
    var dot: CALayer!
    var arrow: CAShapeLayer!
    
    // -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed. This can be called many times a second, so be careful to keep it lightweight.
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }
        
        // Check whether we have the user’s location yet.
        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }
    
    private func updateHeading() {
        // Show the heading arrow, if the heading of the user is available.
        if let heading = userLocation!.heading?.trueHeading {
            arrow.isHidden = false
            
            // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
            let rotation: CGFloat = -MGLRadiansFromDegrees(mapView!.direction - heading)
            
            // If the difference would be perceptible, rotate the arrow.
            if fabs(rotation) > 0.01 {
                // Disable implicit animations of this rotation, which reduces lag between changes.
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
                CATransaction.commit()
            }
        } else {
            arrow.isHidden = true
        }
    }
    
    private func setupLayers() {
        // This dot forms the base of the annotation.
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            
            // Use CALayer’s corner radius to turn this layer into a circle.
            dot.contents = UIImage(named: "location")?.cgImage
            dot.contentsGravity = kCAGravityResizeAspect
            dot.isGeometryFlipped = true
            layer.addSublayer(dot)
            dot.opacity = 0
        }
        
        // This arrow overlays the dot and is rotated with the user’s heading.
        if arrow == nil {
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
            arrow.position = CGPoint(x: dot.frame.midX, y: dot.frame.midY)
            arrow.fillColor = UIColor.black.cgColor
            layer.addSublayer(arrow)
        }
    }
    
    // Calculate the vector path for an arrow, for use in a shape layer.
    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2
        let pad: CGFloat = 3
        
        let top =    CGPoint(x: max * 0.5, y: 0)
        let left =   CGPoint(x: 0 + pad,   y: max - pad)
        let right =  CGPoint(x: max - pad, y: max - pad)
        let center = CGPoint(x: max * 0.5, y: max * 0.6)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addLine(to: center)
        bezierPath.addLine(to: right)
        bezierPath.addLine(to: top)
        bezierPath.close()
        
        return bezierPath.cgPath
    }
}

extension CALayer {
    
    func addGradientBorder(colors: [UIColor], width: CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.addSublayer(gradientLayer)
    }
    
}
