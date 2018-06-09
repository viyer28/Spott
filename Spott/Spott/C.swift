//
//  C.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase
import FirebaseStorage
import GEOSwift

class C: NSObject {
    static var w: CGFloat!
    static var h: CGFloat!
    static var darkColor = UIColor(red: 54.0/255.0, green: 57/255.0, blue: 61/255.0, alpha: 1)
    static var yellowColor = UIColor(red:216.0/255.0, green:171.0/255.0, blue:23.0/255.0, alpha:1.0)
    static var lightColor = UIColor(red:232.0/255.0, green:233.0/255.0, blue:235.0/255.0, alpha:1.0)
    static var goldishColor = UIColor(red:213.0/255.0, green:177.0/255.0, blue:132.0/255.0, alpha:1.0)
    static var blueishColor = UIColor(red:70.0/255.0, green:178.0/255.0, blue:199.0/255.0, alpha:1.0)
    static var greenishColor = UIColor(red:58.0/255.0, green:215.0/255.0, blue:197.0/255.0, alpha:1.0)
    static var redishColor = UIColor(red:222.0/255.0, green:43.0/255.0, blue:105.0/255.0, alpha:1.0)
    static var regLibrary = Location()
    static var currentLocation = Location()
    static var totalPopulation = 1
    static var user = User()
    static var lastSpottUpdated = NSDate()
    static var leaders: [Leader] = []
    static var spotts: [User] = []
    static var lastLocationUpdate = NSDate()
    static var events: [Event] = []
    static var locations: [Location] = []
    static var eventDarkBlueColor = UIColor(red:0/255.0, green:144.0/255.0, blue:170.0/255.0, alpha:1.0)
    static var eventLightBlueColor = UIColor(red:72.0/255.0, green:207.0/255.0, blue:231.0/255.0, alpha:1.0)
    static var eventDarkBrownColor = UIColor(red:155.0/255.0, green:99.0/255.0, blue:29.0/255.0, alpha:1.0)
    static var eventLightBrownColor = UIColor(red:246.0/255.0, green:194.0/255.0, blue:127.0/255.0, alpha:1.0)
    static var refid: String!
    static var userData: Dictionary<String, Any>!
    static let userInfo = "user_info2"
    static let db = Firestore.firestore()
    static let dbChat = db.collection("chats")
    static var leader = Leader()
    static var  fcmToken: String!
    static let storage = Storage.storage()
    static let stoRef = Storage.storage().reference()
    static var navigationViewController = NavigationViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                                   navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
                                                                   options: nil)
    static var profileViewController = ProfileViewController()
    static var features: [Feature]!
    static var people: [QueryDocumentSnapshot]!
    static var businesses: [User] = []
    static func updateLocations()
    {
        var locationData: Dictionary<String, Any>!
        Firestore.firestore().collection("locations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                C.locations = []
                for document in querySnapshot!.documents {
                    let location = Location()
                    locationData = document.data()
                    location.name = locationData["name"] as! String
                    location.id = locationData["id"] as! Int
                    location.latitude = locationData["latitude"] as! Double
                    location.longitude = locationData["longitude"] as! Double
                    location.displayName = locationData["displayName"] as! String
                    location.refid = document.documentID
                    location.numPopulation = 0
                    if locationData["flame"] != nil
                    {
                        location.type = locationData["flame"] as! Int
                    }
                    if locationData["population"] != nil
                    {
                        //location.numPopulation = locationData["population"] as! Int
                    }
                    C.locations.append(location)
                    
                }
                getNums(locations: C.locations)
                C.updateUsersLocation()
                C.navigationViewController.findUserLocation()
                //C.navigationViewController.mapViewController.searchView.tableView.reloadData()
            }
        }
    }
    
    static func updateLocationCenters()
    {
        Firestore.firestore().collection("locations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                C.locations = []
                for document in querySnapshot!.documents {
                    let locationData = document.data()
                    
                    for f in C.features
                    {
                        if f.properties!["id"] as! Int == locationData["id"] as! Int
                        {
                            let point = f.geometries?.first?.centroid()
                            Firestore.firestore().collection("locations").document(document.documentID).updateData([
                                "longitude" : point?.coordinate.x ?? 0,
                                "latitude" : point?.coordinate.y ?? 0
                            ])
                        }
                    }
                    
                }
            }
        }
    }
    
    static func updateBusinesses()
    {
        var locationData: Dictionary<String, Any>!
        Firestore.firestore().collection(C.userInfo).whereField("business", isEqualTo: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                C.businesses = []
                for document in querySnapshot!.documents {
                    let businessData = document.data()
                    let b = parseUser(document: document)
                    b.business = 1
                    if businessData["profilePicture"] != nil
                    {
                    C.storage.reference(forURL: businessData["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                    // Create a UIImage, add it to the array
                    b.image = UIImage(data: data!)
                    })
                    }
                    else
                    {
                        b.image = UIImage(named: "sample_prof")
                    }
                    C.businesses.append(b)
                    C.navigationViewController.mapViewController.updateAnnotations()
                    
                }
                // getNums(locations: C.locations)
                C.updateUsersLocation()
                C.navigationViewController.findUserLocation()
                //C.navigationViewController.mapViewController.searchView.tableView.reloadData()
            }
        }
    }
    
    static func updateUsersLocation()
    {
        if C.user.curLoc == -1
        {
            C.currentLocation = Location()
        }
        for l in C.locations
        {
            if C.user.curLoc == l.id
            {
                C.currentLocation = l
            }
        }
        if C.navigationViewController.peopleViewController.sliderInt == 0
        {
            C.navigationViewController.peopleViewController.current = C.currentLocation.spotts
            C.navigationViewController.peopleViewController.collectionView?.reloadData()
        }
    }
    
    static func getNums(locations: [Location])
    {
        Firestore.firestore().collection(C.userInfo).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                for location in locations
                {
                    C.people = querySnapshot!.documents
                    C.totalPopulation = querySnapshot!.documents.count
                    getLocationNums(location: location, documents: querySnapshot!.documents)
                }
                C.navigationViewController.mapViewController.updateAnnotations()
            }
        }
    }
    
    static func getLocationNums(locaitons: [Location])
    {
        for l in locations
        {
            getLocationNums(location: l, documents: C.people)
        }
        C.navigationViewController.mapViewController.updateAnnotations()
    }
    
    static func getLocationNums(location: Location, documents: [QueryDocumentSnapshot])
    {
        // let sp: [User] = []
        // location.spotts = []
        var population = 0
        var potentials = 0
        var friends = 0
        location.users = documents
        for document in documents
        {
            if (document["curLoc"] as! Int == location.id)
            {
                population += 1
                if (userHasFriend(document: document))
                {
                    friends += 1
                }
                else if document.documentID as! String != C.refid
                {
                    potentials += 1
                    //sp.append(parseUser(document: document))
                }
            }
        }
        if location.displayName == "harper"
        {
            print(friends)
        }
        //location.spotts = sp
        location.numFriends = friends
        location.numPotentials = potentials
        location.numPopulation = population
    }
    
    static func userHasFriend(document: QueryDocumentSnapshot) -> Bool
    {
        for friend in C.user.friends
        {
            if document["user_id"] as! String == friend.id
            {
                return true
            }
        }
        return false
    }
    
    static func getLeaderboardUsers()
    {
        var leaders: [Leader] = []
        Firestore.firestore().collection(C.userInfo).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    let l = Leader()
                    l.name = document["name"] as! String
                    if data["score"] != nil
                    {
                        l.score = document["score"] as! Int
                    }
                    if data["rank"] != nil
                    {
                        l.rank = data["rank"] as! Int
                    }
                    if data["prevRank"] != nil
                    {
                        l.prevRank = data["prevRank"] as! Int
                    }
                    leaders.append(l)
                    
                    if C.user.refid != nil && C.user.refid == document.documentID
                    {
                        if data["score"] != nil
                        {
                            C.leader.score = document["score"] as! Int
                        }
                        if data["rank"] != nil
                        {
                            C.leader.rank = data["rank"] as! Int
                        }
                        if data["prevRank"] != nil
                        {
                            C.leader.prevRank = data["prevRank"] as! Int
                        }
                    }
                    
                    if data["profilePicture"] != nil
                    {
                        C.storage.reference(forURL: data["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                            l.image = UIImage(data: data!)
                            
                        })
                        if C.navigationViewController.eventsViewController.tableView != nil
                        {
                            C.navigationViewController.eventsViewController.tableView.reloadData()
                        }
                    }
                }
                C.leaders = leaders.sorted(by: { $0.score > $1.score })
                
            }
        }
    }
    
//    static func addUserListener()
//    {
//        db.collection(C.userInfo).document(C.refid)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                C.userData = document.data()
//                C.updateUser()
//        }
//    }
    
    static func updateUser()
    {

        C.user.dob = C.userData["dob"] as! String
        
        C.updateToken()
        C.getLeaderboardUsers()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        let birthdate = dateFormatter.date(from: C.user.dob)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        C.user.name = C.userData["name"] as! String
        C.leader.name = C.userData["name"] as! String
        if C.userData["score"] != nil
        {
            C.leader.score = C.userData["score"] as! Int
        }
        if C.userData["rank"] != nil
        {
            C.leader.rank = C.userData["rank"] as! Int
        }
        
        if C.userData["prevRank"] != nil
        {
            C.leader.rank = C.userData["rank"] as! Int
        }
        
        if C.userData["business"] != nil && C.userData["business"] as! Int == 1
        {
            C.user.business = 1
            if C.navigationViewController.mapButton != nil
            {
                C.navigationViewController.mapButton.removeFromSuperview()
                C.navigationViewController.spottButton.removeFromSuperview()
                C.navigationViewController.eventsButton.removeFromSuperview()
            }
        }
        if C.userData["statuses"] != nil
        {
            parseStatuses(statusDict: C.userData["statuses"] as! [Dictionary <String, Any>], u: C.user)
        }
        C.user.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
        
        if C.userData["bio"] != nil
        {
            C.user.bio = C.userData["bio"] as! String
        }
        if C.userData["profilePicture"] != nil && C.user.profilePictureURL != C.userData["profilePicture"] as! String
            
        {
            C.storage.reference(forURL: C.userData["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                
                // Create a UIImage, add it to the array
                C.user.image = UIImage(data: data!)
                C.leader.image = C.user.image
            
        
            })
        }
        C.user.id = C.userData["user_id"] as! String
        C.user.spotted = []
        C.user.friends = []
        updateFriends(user: C.user, friends: C.userData["friends"] as! [String])
        updateSpotted(spotted: C.userData["spotted"] as! [String])
    }
    
    static func updateToken()
    {
        let fcmToken = Messaging.messaging().fcmToken
        
        if C.userData["token"] == nil || C.userData["token"] as! String != fcmToken
        {
            let ref = Firestore.firestore().collection(C.userInfo).document(C.refid)
            ref.updateData([ "token" : fcmToken ])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    static func updateSpotted(spotted: [String])
    {
        var spotted_userData: Dictionary<String, Any>!
        let oldSpotted = C.user.spotted
        C.user.spotted = []
        for spott in spotted {
            var f = User()
            var old = 0
            var previous = 0
            for f in C.user.friends
            {
                if f.id == spott
                {
                    previous = 1
                }
            }
            for s in C.user.spotted
            {
                if s.id == spott
                {
                    previous = 1
                }
            }
            if previous == 0
            {
                if oldSpotted != nil
                {
                    for s in oldSpotted!
                    {
                        if s.id == spott
                        {
                            old = 1
                            C.user.spotted.append(s)
                        }
                    }
                }
                if old == 0
                {
                    Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: spott).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting spotted documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                spotted_userData = document.data()
                                f = C.parseUser(document: document)
                                if spotted_userData["profilePicture"] != nil
                                {
                                    C.storage.reference(forURL: spotted_userData["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                                        // Create a UIImage, add it to the array
                                        f.image = UIImage(data: data!)
                                        if C.navigationViewController.peopleViewController.sliderInt == 1
                                        {
                                        C.navigationViewController.peopleViewController.collectionView?.reloadData()
                                        }
                                    })
                                }
                                else
                                {
                                    f.image = UIImage(named: "sample_prof")
                                }
                                updateFriendsofFriend(user: f, friends: spotted_userData["friends"] as! [String])
                                C.user.spotted.append(f)
                                
                                //updateFriends(user: f, friends: friend_userData["friends"] as! [String])
                            }
                            if C.navigationViewController.peopleViewController.sliderInt == 1
                            {
                                C.navigationViewController.peopleViewController.current = C.user.spotted
                                C.navigationViewController.peopleViewController.collectionView?.reloadData()
                            }
                            print("Recieved Spotted documents")
                        }
                    }
                }
            }
        }
        C.updateSpotts()
    }
    
    static func updateFriendsLocations()
    {
        for f in C.user.friends
        {
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: f.id).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting spotted documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        f.latitude = data["latitude"] as! Double
                        f.longitude = data["longitude"] as! Double
                    }
                    C.navigationViewController.mapViewController.updateAnnotations()
                }
            }
        }
        for f in C.businesses
        {
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: f.id).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting spotted documents: \(err)")
                } else {
                    let latitude = f.latitude
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        f.latitude = data["latitude"] as! Double
                        f.longitude = data["longitude"] as! Double
                    }
                    if latitude != f.latitude
                    {
                        C.navigationViewController.mapViewController.updateAnnotations()
                    }
                }
            }
        }
    }
    
    
    static func updateUserSpotted()
    {
        C.user.spotted = []
        Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user spotted documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let spottsData = document.data()["spotted"] as! [String]
                C.updateSpotted(spotted: spottsData)
            }
        }
        
    }
    
    static func updateFriendsofFriend(user: User, friends: [String])
    {
        user.friends = []
        for friend in friends
        {
            for friend2 in C.user.friends
            {
                if friend == friend2.id
                {
                    user.friends.append(friend2)
                }
                
            }
        }
        
    }
    
    static func updateUserFriends()
    {
        Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user spotted documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                C.updateFriends(user: C.user, friends: document["friends"] as! [String])
                
            }
        }
    }
    static func updateSpotts2()
    {
        Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user spotted documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let data = document.data()
                if document["spotts"] != nil
                {
                    parseSpotts(ss: document["spotts"] as! [String])
                }
            }
        }
    }
    static func parseSpotts(ss: [String])
    {
        for s in ss
        {
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: s).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting Spotts documents: \(err)")
                } else {
                    for document in querySnapshot!.documents
                    {
                        let data = document.data()
                        let f = parseUser(document: document)
                        if data["profilePicture"] != nil
                        {
                            C.storage.reference(forURL: data["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                                // Create a UIImage, add it to the array
                                f.image = UIImage(data: data!)
                                spotts.append(f)
                                if C.navigationViewController.peopleViewController.sliderInt == 0
                                {
                                    C.navigationViewController.peopleViewController.collectionView?.reloadData()
                                }
                                C.navigationViewController.mapViewController.updateAnnotations()
                            })
                        }
                        else
                        {
                            f.image = UIImage(named: "sample_prof")
                        }
                        C.updateFriendsofFriend(user: f, friends: data["friends"] as! [String])
                        spotts.append(f)
                    }
                    C.spotts = spotts
                    if C.navigationViewController.peopleViewController.sliderInt == 0
                    {
                        C.navigationViewController.peopleViewController.current = spotts
                        C.navigationViewController.peopleViewController.collectionView?.reloadData()
                    }
                }
            }
            
        }
    }
    static func updateSpotts()
    {
        if NSDate().timeIntervalSince(lastSpottUpdated as Date) <= 15
        {
            return
        }
        lastSpottUpdated = NSDate()
        Firestore.firestore().collection(C.userInfo).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting Spotts documents: \(err)")
            } else {
                var spotts: [User] = []
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    var add = 1
                    if (data["business"] != nil) && data["business"] as! Int == 1
                    {
                        add = 0
                    }
                   
                    if (data["user_id"] as! String) == C.user.id
                    {
                        add = 0
                    }
                    for f in C.user.friends
                    {
                        if (data["user_id"] as! String) == f.id
                        {
                            add = 0
                        }
                    }
                    for s in (data["spotted"] as! [String])
                    {
                        if s == C.user.id
                        {
                            add = 0
                        }
                    }
                    
                    if add == 1
                    {
                        let point = CLLocation(latitude: CLLocationDegrees(data["latitude"] as! CGFloat), longitude: CLLocationDegrees(data["longitude"] as! CGFloat))
                        if point.distance(from: C.navigationViewController.userLocation) > 200
                        {
                            add = 0
                        }
                    }
                    
                    if add == 1
                    {
                        let f = parseUser(document: document)
                        if data["profilePicture"] != nil
                        {
                            C.storage.reference(forURL: data["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                                // Create a UIImage, add it to the array
                                f.image = UIImage(data: data!)
                                spotts.append(f)
                                if C.navigationViewController.peopleViewController.sliderInt == 0
                                {
                                    C.navigationViewController.peopleViewController.collectionView?.reloadData()
                                }
                                C.navigationViewController.mapViewController.updateAnnotations()
                            })
                        }
                        else
                        {
                            f.image = UIImage(named: "sample_prof")
                        }
                        C.updateFriendsofFriend(user: f, friends: data["friends"] as! [String])
                        spotts.append(f)
                    }
                }
                C.spotts = spotts
                if C.navigationViewController.peopleViewController.sliderInt == 0
                {
                    C.navigationViewController.peopleViewController.current = spotts
                    C.navigationViewController.peopleViewController.collectionView?.reloadData()
                }
            }
        }
    }
    static func updateSpottsAtUserLoc()
    {
        if C.user.curLoc == -1
        {
            return;
        }
        Firestore.firestore().collection(C.userInfo).whereField("curLoc", isEqualTo: C.user.curLoc).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting Spotts documents: \(err)")
            } else {
                var spotts: [User] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    var add = 1
                    if (data["user_id"] as! String) == C.user.id
                    {
                        add = 0
                    }
                    for f in C.user.friends
                    {
                        if (data["user_id"] as! String) == f.id
                        {
                            add = 0
                        }
                    }
                    for s in (data["spotted"] as! [String])
                    {
                        if s == C.user.id
                        {
                            add = 0
                        }
                    }
                    if add == 1
                    {
                        let f = parseUser(document: document)
                        if data["profilePicture"] != nil
                        {
                            C.storage.reference(forURL: data["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                                // Create a UIImage, add it to the array
                                f.image = UIImage(data: data!)
                                spotts.append(f)
                                if C.navigationViewController.peopleViewController.sliderInt == 0
                                {
                                    C.navigationViewController.peopleViewController.collectionView?.reloadData()
                                }
                                C.navigationViewController.mapViewController.updateAnnotations()
                            })
                        }
                        else
                        {
                            f.image = UIImage(named: "sample_prof")
                        }
                        C.updateFriendsofFriend(user: f, friends: data["friends"] as! [String])
                        spotts.append(f)
                    }
                }
                for l in C.locations
                {
                    if l.id == C.user.curLoc
                    {
                        l.spotts = spotts
                    }
                }
                C.currentLocation.spotts = spotts
            }
        }
    }
    
    static func updateFriends(user: User, friends: [String])
    {
        var friend_userData: Dictionary<String, Any>!
        
        if friends.count == C.user.friends.count
        {
            return
        }
        
        var newFriends: [User] = []
        
        for friend in friends {
            var found = 0
            for f in C.user.friends
            {
                if friend == f.id
                {
                    var added = 0
                    for fr in newFriends
                    {
                        if fr.id == friend
                        {
                            added = 1
                        }
                    }
                    if added == 0
                    {
                        newFriends.append(f)
                    }
                    found = 1
                }
            }
            if found == 0
            {
                Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: friend).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting Friend documents: \(err)")
                    } else {
                        var i = 0
                        for document in querySnapshot!.documents {
                            let f = C.parseUser(document: document)
                            let friend_userData = document.data()
                            f.image = UIImage(named: "sample_prof")
                            C.storage.reference(forURL: friend_userData["profilePicture"] as! String).getData(maxSize: 1024*1024, completion: {(data, error) -> Void in
                                // Create a UIImage, add it to the array
                                if data == nil
                                {
                                }
                                else
                                {
                                    f.image = UIImage(data: data!)
                                    C.navigationViewController.mapViewController.updateAnnotations()
                                }
                            })
                            var added = 0
                            for fr in newFriends
                            {
                                if fr.name == f.name
                                {
                                    added = 1
                                }
                            }
                            if added == 0
                            {
                                newFriends.append(f)
                            }
                            i = i + 1
                            if i == querySnapshot!.documents.count
                            {
                                NotificationCenter.default.post(name: .update, object: nil)
                                
                            }
                            updateFriendsofFriend(user: f, friends: friend_userData["friends"] as! [String])
                            user.friends = newFriends
                            if C.profileViewController.tableView != nil
                            {
                                C.profileViewController.tableView.reloadData()
                            }
                            updateLocations()
                            C.navigationViewController.mapViewController.updateAnnotations()
                        }
                    }
                }
            }
        }
        user.friends = newFriends
        if C.profileViewController.tableView != nil
        {
            C.profileViewController.tableView.reloadData()
        }
        updateLocations()
        updateBusinesses()
        if C.navigationViewController.mapViewController != nil
        {
            C.navigationViewController.mapViewController.updateAnnotations()
        }
    }
    
    static func parseUser(document: QueryDocumentSnapshot) -> User
    {
        let dict = document.data()
        let f = User()
        f.name = dict["name"] as! String
        f.longitude = dict["longitude"] as! Double
        f.latitude = dict["latitude"] as! Double
        f.refid = document.documentID
        f.id = dict["user_id"] as! String
        f.curLoc = dict["curLoc"] as! Int
        f.dob = dict["dob"] as! String
        f.bio = dict["bio"] as! String
        if dict["business"] != nil
        {
            f.business == dict["business"] as! Int
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdate = dateFormatter.date(from: f.dob)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        f.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
        if dict["statuses"] != nil
        {
            parseStatuses(statusDict: dict["statuses"] as! [Dictionary <String, Any>], u: f)
        }
        C.updateFriendsofFriend(user: f, friends: dict["friends"] as! [String])
        return f
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func parseStatuses(statusDict: [Dictionary<String, Any>], u: User)
    {
        var statuses: [Status] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        for s in statusDict
        {
            let status = Status()
            status.text = s["text"] as! String
            status.time = dateFormatter.date(from: s["time"] as! String)!
            statuses.append(status)
        }
        u.statuses = statuses
    }
}
extension Notification.Name {
    static let update = Notification.Name("update")
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
}


import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

