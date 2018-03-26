//
//  Objects.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/11/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit

class Location : NSObject {
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var friends_num: Int!
    var friends: [User]!
    var potentials: Int!
    var population_num: Int!
    var population: [User]!
    var id: Int!
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
    var friends: [User]!
    var profilePictureURL: String!
    var whoIam: [String]!
    var whatIDo: [String]!
    var xp: Int!
    var level: Int!
    var major: String!
    var hometown: String!
    var gender: String!
    var age: Int!
    var friendsNum = 123
    var latitude: Double!
    var longitude: Double!
    var spotted: Bool!
}

