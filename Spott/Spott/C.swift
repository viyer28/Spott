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
    
    static func updateUser(refid: String)
    {
        let docsref = Firestore.firestore().collection("user_info").document(refid)
        docsref.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
            } else {
                print("Document does not exist")
            }
        }
//        user.name = ref.value(forKey: "name") as! String
//        user.major = ref.value(forKey: "major") as! String
//        user.whoIam[0] = ref.value(forKey: "who1") as! String
//        user.whoIam[1] = ref.value(forKey: "who2") as! String
//        user.whoIam[2] = ref.value(forKey: "who3") as! String
//        user.whatIDo[0] = ref.value(forKey: "what1") as! String
//        user.whatIDo[1] = ref.value(forKey: "what2") as! String
//        user.whatIDo[2] = ref.value(forKey: "what3") as! String
//        user.gender = ref.value(forKey: "gender") as! String
    }
    
}
