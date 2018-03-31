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
import GEOSwift

class C: NSObject {
    static var w: CGFloat!
    static var h: CGFloat!
    static var darkColor = UIColor(red: 54.0/255.0, green: 57/255.0, blue: 61/255.0, alpha: 1)
    static var yellowColor = UIColor(red:216.0/255.0, green:171.0/255.0, blue:23.0/255.0, alpha:1.0)
    static var lightColor = UIColor(red:232.0/255.0, green:233.0/255.0, blue:235.0/255.0, alpha:1.0)
    static var goldishColor = UIColor(red:213.0/255.0, green:177.0/255.0, blue:132.0/255.0, alpha:1.0)
    static var blueishColor = UIColor(red:70.0/255.0, green:178.0/255.0, blue:199.0/255.0, alpha:1.0)
    static var regLibrary = Location()
    static var user = User()
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
    static let navigationViewController = NavigationViewController()
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
                    location.friends_num = 11
                    location.potentials = 11
                    location.population_num = 123
                    C.locations.append(location)
                }
                C.navigationViewController.mapViewController.updateAnnotations()
            }
        }
    }
    static func updateUser()
    {
        C.user.name = C.userData["name"] as! String
        C.user.xp = C.userData["xp"] as! Int
        C.user.level = C.userData["level"] as! Int
        C.user.gender = C.userData["gender"] as! String
        C.user.numFriends = C.userData["num_friends"] as! Int
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
            C.user.whoIam[0] = C.userData["what1"] as! String
        }
        if C.userData["what2"] != nil
        {
            C.user.whoIam[1] = C.userData["what2"] as! String
        }
        if C.userData["what3"] != nil
        {
            C.user.whoIam[2] = C.userData["what3"] as! String
        }
        if C.userData["hometown"] != nil
        {
            C.user.hometown = C.userData["hometown"] as! String
        }
        C.user.major = C.userData["major"] as! String
        updateFriends(user: C.user, friends: C.userData["friends"] as! [String])
    }
    
    static func updateFriends(user: User, friends: [String])
    {
        var friend_userData: Dictionary<String, Any>!
        C.user.friends = []
        for friend in friends {
            let f = User()
            
            Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: friend).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting Friend documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        friend_userData = document.data()
                        
                        f.name = friend_userData["name"] as! String
                        f.xp = friend_userData["xp"] as! Int
                        f.level = friend_userData["level"] as! Int
                        f.numFriends = friend_userData["num_friends"] as! Int
                        f.whoIam = ["", "", ""]
                        f.whatIDo = ["", "", ""]
                        if friend_userData["who1"] != nil
                        {
                            f.whoIam[0] = friend_userData["who1"] as! String
                        }
                        if friend_userData["who2"] != nil
                        {
                            f.whoIam[1] = friend_userData["who2"] as! String
                        }
                        if friend_userData["who3"] != nil
                        {
                            f.whoIam[2] = friend_userData["who3"] as! String
                        }
                        if friend_userData["what1"] != nil
                        {
                            f.whoIam[0] = friend_userData["what1"] as! String
                        }
                        if friend_userData["what2"] != nil
                        {
                            f.whoIam[1] = friend_userData["what2"] as! String
                        }
                        if friend_userData["what3"] != nil
                        {
                            f.whoIam[2] = friend_userData["what3"] as! String
                        }
                        f.major = friend_userData["major"] as! String
                        f.longitude = friend_userData["longitude"] as! Double
                        f.latitude = friend_userData["latitude"] as! Double
                        f.refid = document.documentID
                        //updateFriends(user: f, friends: friend_userData["friends"] as! [String])
                        if (f.name != nil){
                            user.friends.append(f)
                        }
                    }
                    C.navigationViewController.mapViewController.updateAnnotations()
                }
            }
        }
    }
}
