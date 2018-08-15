//
//  AppDelegate.swift
//  spott
//
//  Created by Varun Iyer on 6/26/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var auth = SPTAuth()
    var userDefaults: UserDefaults? = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            Firestore.firestore().collection(B.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                    try! Auth.auth().signOut()
                    
                    let initialViewController = B.mapViewController
                    
                    B.welcome = true
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    B.w = self.window?.frame.width
                    B.h = self.window?.frame.height
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                    
                } else {
                    print("Recieved documents")
                    if querySnapshot!.documents.count == 0
                    {
                        try! Auth.auth().signOut()
                        
                        let initialViewController = B.mapViewController
                        
                        B.welcome = true
                        
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        B.w = self.window?.frame.width
                        B.h = self.window?.frame.height
                        
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        //B.refid = document.documentID
                        //B.userData = document.data()
                        
                        //B.updateUser()
                        //B.updateLocations()
                        
                        try! Auth.auth().signOut()
                        
                        let initialViewController = B.mapViewController
                        
                        B.welcome = true
                        
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        B.w = self.window?.frame.width
                        B.h = self.window?.frame.height

                        self.window?.rootViewController = initialViewController //B.mapViewController
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        } else {
            let initialViewController = B.mapViewController
            
            B.welcome = true

            window = UIWindow(frame: UIScreen.main.bounds)
            B.w = window?.frame.width
            B.h = window?.frame.height
            
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        auth.redirectURL = URL(string: "http://www.spott.live/callback/")
        auth.sessionUserDefaultsKey = "current session"
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                if error != nil {
                    print("error!")
                } else {
                    let sessionData = NSKeyedArchiver.archivedData(withRootObject: session!)
                    self.userDefaults?.set(sessionData, forKey: "SpotifySession")
                    self.userDefaults?.synchronize()
                    B.userDefaults = self.userDefaults
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
                }
            })
            return true
        }
        return false
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

}

