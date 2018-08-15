//
//  B.swift
//  spott
//
//  Created by Varun Iyer on 7/19/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import MapKit
import Mapbox
import Firebase
import FirebaseStorage

class B: NSObject {
    static var w: CGFloat!
    static var h: CGFloat!
    
    static var mapViewController = MapViewController()
    static var welcome: Bool!
    static var zoomLevel: Double = 0
    static var move: Double = 0
    static var userDefaults: UserDefaults!
    
    static var darkGold = UIColor(red: 148.0/255.0, green: 103.0/255.0, blue: 43/0/255.0, alpha: 1.0)
    static var lightGold = UIColor(red: 255.0/255.0, green: 209.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    static var goldishColor = UIColor(red: 213.0/255.0, green: 177.0/255.0, blue: 132.0/255.0, alpha:1.0)
    
    static var totalPopulation = 0
    
    static var user = User()
    static var userData: Dictionary<String, Any>!
    static let userInfo = "user_info2"
    
    static var locations: [Location] = []
    
    static let storage = Storage.storage()
    
    static func updateLocations()
    {
        /* - called after logging in
         - read all locations and info into the locations array in c
         - call updateAnnotations after */
        
        var locationData: Dictionary<String, Any>!
        
        Firestore.firestore().collection("locations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Location documents: \(err)")
            } else {
                B.locations = []
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
                    B.locations.append(location)
                }
            }
        }
        
        mapViewController.updateAnnotations()
    }
    
    static func updateLocationNums()
    {
        /* - for each location calls user_info2 collection where curloc is equal to location id
        */
        
        Firestore.firestore().collection(B.userInfo).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents for Location populations: \(err)")
            } else {
                for location in locations
                {
                    var population = 0
                    
                    for document in querySnapshot!.documents
                    {
                        if (document["curLoc"] as! Int == location.id)
                        {
                            population += 1
                        }
                    }
                    
                    location.numPopulation = population
                    totalPopulation += population
                }
            }
        }
        
        mapViewController.updateAnnotations()
    }
    
    static func updateUser()
    {
        /* - called after successful login reads in all user data into firebase
        */
        
        B.user.firstName = B.userData["firstName"] as! String
        B.user.lastName = B.userData["lastName"] as! String
        B.user.dob = B.userData["dob"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        let birthdate = dateFormatter.date(from: B.user.dob)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        
        B.user.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
        
        
        if B.userData["profilePicture"] != nil && B.user.profilePictureURL != (B.userData["profilePicture"] as! String)
            
        {
            B.storage.reference(forURL: B.userData["profilePicture"] as! String).getData(maxSize: 4*1024*1024, completion: {(data, error) -> Void in
                
                // Create a UIImage, add it to the array
                B.user.propic = UIImage(data: data!)
            })
        }
        
        B.user.id = B.userData["user_id"] as! String
        B.user.phoneNum = B.userData["phoneNum"] as! String
        
        B.user.friends = []
        
        B.updateFriends(user: B.user, friends: B.userData["friends"] as! [String])
        
        mapViewController.updateAnnotations()
    }
    
    static func updateFriends(user: User, friends: [String])
    {
        /*- called by updateUser(), gets info from firebase of all friends
        */
        
        for friend in friends {
            Firestore.firestore().collection(B.userInfo).whereField("user_id", isEqualTo: friend).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting Friend documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let f = B.parseUser(document: document)
                        let friend_userData = document.data()
                        
                        f.propic = #imageLiteral(resourceName: "spott-propic")
                        
                        B.storage.reference(forURL: friend_userData["profilePicture"] as! String).getData(maxSize: 1024*1024, completion: {(data, error) -> Void in
                            if data == nil
                            {
                            }
                            else
                            {
                                f.propic = UIImage(data: data!)
                            }
                        })
                        
                        updateMutuals(user: f, friends: friend_userData["friends"] as! [String])
                        
                        user.friends.append(f)
                    }
                }
            }
        }
        
        mapViewController.updateAnnotations()
    }
    
    static func parseUser(document: QueryDocumentSnapshot) -> User
    {
        let dict = document.data()
        let f = User()
        
        f.firstName = dict["firstName"] as! String
        f.lastName = dict["lastName"] as! String
        f.longitude = dict["longitude"] as! Double
        f.latitude = dict["latitude"] as! Double
        f.refid = document.documentID
        f.id = dict["user_id"] as! String
        f.curLoc = dict["curLoc"] as! Int
        f.dob = dict["dob"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdate = dateFormatter.date(from: f.dob)
        let currentDate = Date()
        let calendar: Calendar = Calendar(identifier: .gregorian)
        
        f.age = calendar.component(.year, from: birthdate!).distance(to: calendar.component(.year, from: currentDate))
        
        B.updateMutuals(user: f, friends: dict["friends"] as! [String])
        
        return f
    }
    
    static func updateMutuals(user: User, friends: [String])
    {
        /* -looks at user's friends list and friend's friends list and sees if anyone is the same. NOTE: This should not make any firebase calls.
        */
        
        user.friends = []
        for friend in friends
        {
            for friend2 in B.user.friends
            {
                if friend == friend2.id
                {
                    user.friends.append(friend2)
                }
            }
        }
        
        mapViewController.updateAnnotations()
    }
}
