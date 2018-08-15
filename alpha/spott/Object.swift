//
//  Object.swift
//  spott
//
//  Created by Varun Iyer on 8/3/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    var firstName: String!
    var lastName: String!
    
    var dob: String!
    var age: Int!
    
    var phoneNum: String!
    
    var refid: String!
    var id: String!
    
    var profilePictureURL: String!
    var propic: UIImage!
    
    var friends: [User] = []
    var knowns: [User]!
    
    var latitude: Double!
    var longitude: Double!
    
    var curLoc: Int = -1
    
    var spotts: [User] = []
    var spotted: [User]!
    
    var business: Int!
}

class Location : NSObject {
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var numFriends    = 0
    var numPotentials = 0
    var numPopulation = 0
    var id: Int!
    var refid: String!
    var displayName: String!
    var users: [QueryDocumentSnapshot] = []
    var type = 0
}
