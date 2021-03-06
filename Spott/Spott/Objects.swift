//
//  Objects.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/11/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Location : NSObject {
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var numFriends    = 0
    var numPotentials = 0
    var numPopulation = 0
    var id: Int!
    var refid: String!
    var spotts: [User] = []
    var displayName: String!
    var users: [QueryDocumentSnapshot] = []
    var type = 0
}

class Event : NSObject {
    var location: Location!
    var name: String!
    var numFriends: Int!
    var friends: [User]!
    var potentials: Int!
    var going: Int!
    var dateComponents = DateComponents()
//    let calendar = Calendar.current
//    let hour = calendar.component(.hour, from: date)
//    let minutes = calendar.component(.minute, from: date)
    
}

class User: NSObject {
    var name: String!
    var numFriends: Int!
    var friends: [User] = []
    var profilePictureURL: String!
    var whoIam: [String]!
    var whatIDo: [String]!
    var major: String!
    var hometown: String!
    var gender: String!
    var age: Int!
    var friendsNum = 123
    var latitude: Double!
    var longitude: Double!
    var spotted: [User]!
    var acquaintances: [User]!
    var refid: String!
    var image: UIImage!
    var curLoc: Int = -1
    var id: String!
    var dob: String!
    var bio: String!
    var statuses: [Status] = []
    var business = 0
}

class Leader: NSObject {
    var score = 0
    var rank = -1
    var prevRank = -1
    var profilePictureURL: String!
    var name: String!
    var refid: String!
    var id: String!
    var image: UIImage!
}

class Status: NSObject {
    var time =  Date()
    var text = ""
}


