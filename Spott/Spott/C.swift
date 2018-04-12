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
    static var lastLocationUpdate = NSDate()
    static var events: [Event] = []
    static var locations: [Location] = []
    static var eventDarkBlueColor = UIColor(red:0/255.0, green:144.0/255.0, blue:170.0/255.0, alpha:1.0)
    static var eventLightBlueColor = UIColor(red:72.0/255.0, green:207.0/255.0, blue:231.0/255.0, alpha:1.0)
    static var eventDarkBrownColor = UIColor(red:155.0/255.0, green:99.0/255.0, blue:29.0/255.0, alpha:1.0)
    static var eventLightBrownColor = UIColor(red:246.0/255.0, green:194.0/255.0, blue:127.0/255.0, alpha:1.0)
    static var refid: String!
    static var userData: Dictionary<String, Any>!
    static let db = Firestore.firestore()
    static let dbChat = db.collection("chats")
    static let storage = Storage.storage()
    static let stoRef = Storage.storage().reference()
    static var navigationViewController = NavigationViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                                   navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
                                                                   options: nil)
    static var profileViewController = ProfileViewController()
    static var features: [Feature]!
    
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
                    C.locations.append(location)
                }
                getNums(locations: C.locations)
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
        Firestore.firestore().collection("user_info").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Friend documents: \(err)")
            } else {
                for location in locations
                {
                    C.totalPopulation = querySnapshot!.documents.count
                    getLocationNums(location: location, documents: querySnapshot!.documents)
                }
                C.navigationViewController.mapViewController.updateAnnotations()
            }
        }
    }
    
    static func getLocationNums(location: Location, documents: [QueryDocumentSnapshot])
    {
        var sp: [User] = []
        location.spotts = []
        var population = 0
        var potentials = 0
        var friends = 0
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
        location.spotts = sp
        location.numFriends = friends
        location.numPotentials = potentials
        location.numPopulation = population
    }
    
    static func getSpott(document: QueryDocumentSnapshot) -> User
    {
        let f = User()
        f.name = document["name"] as! String
        f.xp = document["xp"] as! Int
        f.level = document["level"] as! Int
        f.numFriends = document["num_friends"] as! Int
        f.whoIam = ["", "", ""]
        f.whatIDo = ["", "", ""]
        if document["who1"] != nil
        {
            f.whoIam[0] = document["who1"] as! String
        }
        if document["who2"] != nil
        {
            f.whoIam[1] = document["who2"] as! String
        }
        if document["who3"] != nil
        {
            f.whoIam[2] = document["who3"] as! String
        }
        if document["what1"] != nil
        {
            f.whatIDo[0] = document["what1"] as! String
        }
        if document["what2"] != nil
        {
            f.whatIDo[1] = document["what2"] as! String
        }
        if document["what3"] != nil
        {
            f.whatIDo[2] = document["what3"] as! String
        }
        f.age = 18
        if document["profilePicture"] != nil
            
        {
            C.storage.reference(forURL: document["profilePicture"] as! String).getData(maxSize: 1024*1024, completion: {(data, error) -> Void in
                // Create a UIImage, add it to the array
                f.image = UIImage(data: data!)
                
                
            })
        }
        updateFriendsofFriend(user: f, friends: document["friends"] as! [String])
        return f
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
    
//    static func addUserListener()
//    {
//        db.collection("user_info").document(C.refid)
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
        C.user.name = C.userData["name"] as! String
        C.user.xp = C.userData["xp"] as! Int
        C.user.level = C.userData["level"] as! Int
        C.user.numFriends = C.userData["num_friends"] as! Int
        C.user.dob = C.userData["dob"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM–dd–yyyy"
        dateFormatter.timeZone = TimeZone.current
        var yearString = C.user.dob[6..<C.user.dob.count]
        let year = Int(yearString)
        if year! < 18
        {
            yearString = "20" + yearString
        }
        else
        {
            yearString = "19" + yearString
        }
        var birthdayString = C.user.dob[0..<6] + yearString
        birthdayString = birthdayString.replacingOccurrences(of: "-", with: "–")
        let birthdate = dateFormatter.date(from: birthdayString)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        C.user.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
        
        if C.userData["who1"] != nil
        {
            C.user.whoIam[0] = C.userData["who1"] as! String
        }
        if C.userData["who2"] != nil
        {
            C.user.whoIam[1] = C.userData["who2"] as! String
        }
        if C.userData["who3"] != nil
        {
            C.user.whoIam[2] = C.userData["who3"] as! String
        }
        if C.userData["what1"] != nil
        {
            C.user.whatIDo[0] = C.userData["what1"] as! String
        }
        if C.userData["what2"] != nil
        {
            C.user.whatIDo[1] = C.userData["what2"] as! String
        }
        if C.userData["what3"] != nil
        {
            C.user.whatIDo[2] = C.userData["what3"] as! String
        }
        if C.userData["hometown"] != nil
        {
            C.user.hometown = C.userData["hometown"] as! String
        }
        if C.userData["profilePicture"] != nil && C.user.profilePictureURL != C.userData["profilePicture"] as! String
            
        {
            C.storage.reference(forURL: C.userData["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                
                // Create a UIImage, add it to the array
                C.user.image = UIImage(data: data!)
            
        
            })
        }
        C.user.id = C.userData["user_id"] as! String
        C.user.spotted = []
        C.user.major = C.userData["major"] as! String
        updateFriends(user: C.user, friends: C.userData["friends"] as! [String])
        updateSpotted(spotted: C.userData["spotted"] as! [String])
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
                    Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: spott).getDocuments() { (querySnapshot, err) in
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
                                C.user.spotted.append(f)
                                updateFriendsofFriend(user: f, friends: spotted_userData["friends"] as! [String])
                                
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
        C.updateSpottsAtUserLoc()
    }
    
    
    static func updateUserSpotted()
    {
        let oldSpotted = C.user.spotted
        C.user.spotted = []
        Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
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
        Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user spotted documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                C.updateFriends(user: C.user, friends: document["friends"] as! [String])
            }
        }
    }
    
    static func updateSpottsAtUserLoc()
    {
        Firestore.firestore().collection("user_info").whereField("curLoc", isEqualTo: C.user.curLoc).getDocuments { (querySnapshot, err) in
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
                            })
                        }
                        else
                        {
                            f.image = UIImage(named: "sample_prof")
                        }
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
                if C.navigationViewController.peopleViewController.sliderInt == 0
                {
                    C.navigationViewController.peopleViewController.current = spotts
                    C.navigationViewController.peopleViewController.collectionView?.reloadData()
                }
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
            
            Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: friend).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting Friend documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        let f = C.parseUser(document: document)
                        let friend_userData = document.data()
                        C.storage.reference(forURL: friend_userData["profilePicture"] as! String).getData(maxSize: 1024*1024, completion: {(data, error) -> Void in
                            // Create a UIImage, add it to the array
                            if data == nil
                            {
                                f.image = UIImage(named: "sample_prof")
                            }
                            else
                            {
                                f.image = UIImage(data: data!)
                            }
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
                            user.friends = newFriends
                            C.navigationViewController.mapViewController.updateAnnotations()
                            if C.profileViewController.tableView != nil
                            {
                                C.profileViewController.tableView.reloadData()
                            }
                        })
                        updateFriendsofFriend(user: f, friends: friend_userData["friends"] as! [String])
                        updateLocations()
                    }
                    
                }
            }
        }
    }
    
    static func parseUser(document: QueryDocumentSnapshot) -> User
    {
        let dict = document.data()
        let f = User()
        f.name = dict["name"] as! String
        f.xp = dict["xp"] as! Int
        f.level = dict["level"] as! Int
        f.numFriends = dict["num_friends"] as! Int
        f.hometown = dict["hometown"] as! String
        f.whoIam = ["", "", ""]
        f.whatIDo = ["", "", ""]
        if dict["who1"] != nil
        {
            f.whoIam[0] = dict["who1"] as! String
        }
        if dict["who2"] != nil
        {
            f.whoIam[1] = dict["who2"] as! String
        }
        if dict["who3"] != nil
        {
            f.whoIam[2] = dict["who3"] as! String
        }
        if dict["what1"] != nil
        {
            f.whatIDo[0] = dict["what1"] as! String
        }
        if dict["what2"] != nil
        {
            f.whatIDo[1] = dict["what2"] as! String
        }
        if dict["what3"] != nil
        {
            f.whatIDo[2] = dict["what3"] as! String
        }
        f.major = dict["major"] as! String
        f.longitude = dict["longitude"] as! Double
        f.latitude = dict["latitude"] as! Double
        f.refid = document.documentID
        f.id = dict["user_id"] as! String
        f.curLoc = dict["curLoc"] as! Int
        f.dob = dict["dob"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM–dd–yyyy"
        var yearString = C.user.dob[6..<C.user.dob.count]
        let year = Int(yearString)
        if year! < 18
        {
            yearString = "20" + yearString
        }
        else
        {
            yearString = "19" + yearString
        }
        
        var birthdayString = C.user.dob[0..<6] + yearString
        birthdayString = birthdayString.replacingOccurrences(of: "-", with: "–")
        let birthdate = dateFormatter.date(from: birthdayString)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        f.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
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
