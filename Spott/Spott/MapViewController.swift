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

let MapboxAccessToken = "pk.eyJ1Ijoic3BvdHRpeWVyIiwiYSI6ImNqZmQyZnVkejIwbGgyd29iZnR3bGVvMXUifQ.fVrLRiLoyIoPfAGm5ozmMg"
class MapViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView:MGLMapView!
    var tabBar:TabBarViewController!
    var textField: UITextField!
    var tableView: UITableView!
    var profileButton = UIButton(type: UIButtonType.custom) as UIButton
    var friendsButton = UIButton(type: UIButtonType.custom) as UIButton
    var centerButton = UIButton(type: UIButtonType.custom) as UIButton
    var otherControllerView: UIView!
    var allValues: [String] = []
    var values: [String] = []
    //var searchView = SearchBarView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MGLAccountManager.setAccessToken(MapboxAccessToken)
        let url = URL(string: "mapbox://styles/spottiyer/cjfgeobk2aztz2rk98ke0awx4")
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h), styleURL: url)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        textField = UITextField(frame: CGRect(x: C.w*0.1, y: C.h*0.05, width: C.w*0.8, height: C.h*0.05))
        textField.delegate = self
        textField.backgroundColor = UIColor.white
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocapitalizationType = .none
        textField.font = UIFont(name: "FuturaPT-Light", size: 16.0)
        textField.tintColor = .black 
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.placeholder = "Search for a user or a location..."
        textField.autocorrectionType = UITextAutocorrectionType.no
        tableView = UITableView(frame: CGRect(x: C.w*0.11, y: C.h*0.1, width: C.w*0.78, height: C.h*0.4))
        let tmaskLayer = CAShapeLayer()
        tmaskLayer.path = UIBezierPath(roundedRect: self.tableView.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: C.h*0.01, height: C.h*0.01)).cgPath
        tableView.layer.mask = tmaskLayer
        
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = C.goldishColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets.zero;
        mapView.center = view.center
//        if #available(iOS 11.0, *) {
//            self.navigationItem.searchController = searchView.searchController
//        } else {
//            // Fallback on earlier versions
//        }
        mapView.showsUserLocation = true;
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true

        //self.mapView.addSubview(searchView)
        
        centerButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        centerButton.center = CGPoint(x: C.w*0.5, y: C.h*0.95)
        centerButton.setImage(UIImage(named: "centerUser"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerToUser), for: UIControlEvents.touchUpInside)
        self.view.addSubview(centerButton)
        self.view.addSubview(tableView)
        self.view.addSubview(textField)
        self.centerButton.isHidden = true
//
//        let image = UIImage(named: "PeopleIcon") as UIImage?
//        friendsButton = UIButton(type: UIButtonType.custom) as UIButton
//        friendsButton.backgroundColor = UIColor.white
//        friendsButton.frame = CGRect(x: C.w*0.9, y: C.w*0.2, width: C.w * 0.07, height: C.w * 0.07)
//        friendsButton.imageView?.frame = CGRect(x: C.w*0.9, y: C.w*0.2, width: C.w * 0.05, height: C.w * 0.05)
//        friendsButton.imageView?.center = friendsButton.center
//        friendsButton.layer.cornerRadius = friendsButton.frame.width/2
//        friendsButton.clipsToBounds = true
//        friendsButton.setImage(image, for: .normal)
//        friendsButton.imageView?.image = image
//        friendsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//        friendsButton.addTarget(self, action: #selector(showFriends), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(friendsButton)
//
//        let image1 = UIImage(named: "ProfileIcon") as UIImage?
//        profileButton.frame = CGRect(x: C.w*0.9, y: C.w*0.1, width: C.w * 0.07, height: C.w * 0.07)
//        profileButton.backgroundColor = UIColor.white
//        profileButton.layer.cornerRadius = profileButton.frame.width/2
//        profileButton.clipsToBounds = true
//        profileButton.backgroundColor = UIColor.white
//        profileButton.setImage(image1, for: .normal)
//        profileButton.addTarget(self, action: #selector(showProfile), for: UIControlEvents.touchUpInside)
//        profileButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
//        NotificationCenter.default.addObserver(self, selector: #selector(updateAnnotations), name: .update, object: nil)
//        self.view.addSubview(profileButton)
        
        
        self.title = "Map";
        
    }
    override func viewDidAppear(_ animated: Bool) {
        mapView.setCenter(C.navigationViewController.userLocation.coordinate, zoomLevel: 15, animated: false)
        updateAnnotations()
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if annotation is MGLUserLocation {
            
            return UserLocationAnnotationView()
        }
        
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
        {
            let view = MapUserAnnotationView(reuseIdentifier: "mapAnnotation", user: (annotation as! MapAnnotation).user)
            return view
        }
        
        let view = MapAnnotationView(reuseIdentifier: "mapAnnotation",  location: (annotation as! MapAnnotation).location)
        
        return view
    }
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
        {
            C.navigationViewController.eventsButton.isHidden = true
            C.navigationViewController.spottButton.isHidden = true
            self.centerButton.isHidden = true
            return UserCalloutView(representedObject: annotation)
            
        }
        else if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 0
        {
            return SpottCalloutView(representedObject: annotation, location: (annotation as! MapAnnotation).location)
        }
        else if annotation.isKind(of: UserLocationAnnotationView.self)
        {
            present(C.profileViewController, animated: true, completion: nil)
        }
        showProfile()
        return EmptyCalloutView(representedObject: annotation)
    }
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        self.centerButton.isHidden = false
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    @objc func centerToUser()
    {
        mapView.centerCoordinate = C.navigationViewController.userLocation.coordinate
        self.centerButton.isHidden = true
    }
    
    @objc func showFriends ()
    {
        self.mapView.addSubview(FriendsView())
    }
    
    func showProfile ()
    {
        self.present(C.profileViewController, animated: true, completion: nil)
        self.centerButton.isHidden = false
    }
    func updateAnnotations()
    {
        if mapView != nil
        {
            var v: [String] = []
            if mapView.annotations != nil
            {
                mapView.removeAnnotations(mapView.annotations!)
            }
            for location in C.locations {
                let point = MapAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude:  location.latitude, longitude:  location.longitude)
                point.title = location.displayName
                point.location = location
                point.type = 0
                mapView.addAnnotation(point)
                v.append(location.name)
            }
            for friend in C.user.friends {
                v.append(friend.name)
                if friend.curLoc == -1
                {
                    let point = MapAnnotation()
                    point.coordinate = CLLocationCoordinate2D(latitude:  friend.latitude, longitude:  friend.longitude)
                    point.title = friend.name
                    point.user = friend
                    point.type = 1
                    mapView.addAnnotation(point)
                }
            }
            self.values = v
            self.allValues = v
            self.tableView.reloadData()
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
            layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.1)
            layer.fillExtrusionColor = MGLStyleValue(rawValue: .black)
            
            // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Show the user location here
        mapView.showsUserLocation = true
    }
    
}

final class UserLocationAnnotationView: MGLUserLocationAnnotationView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    convenience init()
    {
        self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = kCAGravityCenter
        
        // Use your image here
        let image = UIImage(named: "UserAnnotation")
        UIGraphicsBeginImageContext(CGSize(width: 500, height: 500))
        image?.draw(in: CGRect(x: 0, y: 0, width: 500, height: 500))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        layer.contents = newImage?.cgImage
    }
}


extension MapViewController: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.frame = CGRect(x: C.w*0.11, y: C.h*0.1, width: C.w*0.78, height: min(C.h*0.4, CGFloat(values.count)*C.h*0.05))
        return values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        // Set text from the data model
        cell.textLabel?.text = values[indexPath.row].lowercased()
        cell.textLabel?.font = textField.font
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        textField.text = values[indexPath.row].lowercased()
        tableView.isHidden = true
        textField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return C.h*0.05
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return C.h*0.05
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        
        for annotation in self.mapView.annotations!
        {
            if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
            {
                if textField.text == (annotation as! MapAnnotation).user.name.lowercased()
                {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
            else if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 0
            {
                if textField.text == (annotation as! MapAnnotation).location.name.lowercased()
                {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string == ""
        {
            values = allValues
        }
        else
        {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                self.values = []
                for v in allValues
                {
                    if v.lowercased().range(of: updatedText.lowercased()) != nil
                    {
                        values.append(v)
                    }
                }
            }
        }
        self.tableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}
//
//func searchBarIsEmpty() -> Bool {
//    // Returns true if the text is empty or nil
//    return searchController.searchBar.text?.isEmpty ?? true
//}
//
//func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//    filteredCandies = candies.filter({( candy : Candy) -> Bool in
//        return candy.name.lowercased().contains(searchText.lowercased())
//    })
//
//    tableView.reloadData()
//}


class SearchBarView : UIView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating
{
    
    var tableView : UITableView!
    var searchController : UISearchController!
    
    convenience init ()
    {
        self.init(frame: CGRect(x: C.w*0.1, y: C.h*0.1, width: C.w*0.8, height: C.h*0.4))
    }
    
    override init(frame: CGRect) {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        self.tableView.separatorInset = UIEdgeInsets.zero;
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(tableView)
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find Friends or Locations!"
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return C.locations.count+C.user.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        if indexPath.row < C.user.friends.count
        {
            cell?.textLabel?.text = C.user.friends[indexPath.row].name
        }
        else if indexPath.row - C.user.friends.count < C.locations.count
        {
            cell?.textLabel?.text = C.locations[indexPath.row - C.user.friends.count].name
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return C.h*0.05
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return C.h*0.05
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    
}
