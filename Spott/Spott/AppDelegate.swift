//
//  AppDelegate.swift
//  test2
//
//  Created by Brendan Sanderson on 1/30/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GEOSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: UIFont(name: "FuturaPT-Light", size: 30)!]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UITabBar.appearance().tintColor = C.lightColor
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "FuturaPT-Light", size: 10)!], for: [])
        
        
        C.regLibrary.latitude = 41.792212
        C.regLibrary.longitude = -87.599573
        C.regLibrary.name = "Reg Library"
        C.regLibrary.friends_num = 11
        C.regLibrary.potentials = 11
        C.regLibrary.population_num = 123
        
        let physStudyGroup = Event()
        physStudyGroup.potentials = 7
        physStudyGroup.going = 3
        physStudyGroup.name = "Physics Study Group"
        physStudyGroup.location = C.regLibrary
        physStudyGroup.numFriends = 23
        physStudyGroup.going = 1
        
        
        C.events.append(physStudyGroup)
        C.events.append(physStudyGroup)
        C.events.append(physStudyGroup)
        C.user.name = "Griffon"
        C.user.numFriends = 123
        //C.user.friends
        C.user.profilePictureURL = "sample_prof"
        C.user.whoIam = ["Charismatic", "Chill", "Risktaking"]
        C.user.whatIDo = ["Tennis", "Trumpet", "Skiiing"]
        C.user.xp = 10000
        C.user.level = 10
        C.user.major = "Economics"
        C.user.hometown = "Washington DC"
        C.user.age = 20
        
        let geoJSONURL = Bundle.main.url(forResource: "map", withExtension: "geojson")
        C.features = try! Features.fromGeoJSON(geoJSONURL!)
        
        
//        if Auth.auth().currentUser != nil
//        {
//            try! Auth.auth().signOut()
//        }
//
        if Auth.auth().currentUser != nil
        {
            Firestore.firestore().collection("user_info").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print("Recieved documents")
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            C.refid = document.documentID
                            C.userData = document.data()
                            C.updateUser()
                            C.updateLocations()
                            //initialViewController.view.backgroundColor = C.darkColor
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            C.w = self.window?.frame.width
                            C.h = self.window?.frame.height
                            self.window?.rootViewController = C.navigationViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
            }
        }
        else
        {
            let initialViewController = LoginViewController()
            //initialViewController.view.backgroundColor = C.darkColor
            window = UIWindow(frame: UIScreen.main.bounds)
            C.w = window?.frame.width
            C.h = window?.frame.height
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

