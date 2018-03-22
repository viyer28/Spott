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
    static var eventDarkBlueColor = UIColor(red:0/255.0, green:144.0/255.0, blue:170.0/255.0, alpha:1.0)
    static var eventLightBlueColor = UIColor(red:72.0/255.0, green:207.0/255.0, blue:231.0/255.0, alpha:1.0)
    static var eventDarkBrownColor = UIColor(red:155.0/255.0, green:99.0/255.0, blue:29.0/255.0, alpha:1.0)
    static var eventLightBrownColor = UIColor(red:246.0/255.0, green:194.0/255.0, blue:127.0/255.0, alpha:1.0)
    static var refid: String!
    static var userData: Dictionary<String, Any>!
    
    static func updateUser()
    {
        C.user.name = C.userData["name"] as! String
        C.user.xp = C.userData["xp"] as! Int
        C.user.level = C.userData["level"] as! Int
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
        C.user.major = C.userData["major"] as! String
    }
    
}
