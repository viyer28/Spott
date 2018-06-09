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
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        let token = Messaging.messaging().fcmToken
        
        application.registerForRemoteNotifications()
        
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
        C.regLibrary.numFriends = 11
        C.regLibrary.numPotentials = 11
        C.regLibrary.numPopulation = 123
        
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
        C.user.major = "Economics"
        C.user.hometown = "Washington DC"
        C.user.age = 20
        C.user.image = UIImage(named: "sample_prof")
        
        let geoJSONURL = Bundle.main.url(forResource: "map", withExtension: "geojson")
        C.features = try! Features.fromGeoJSON(geoJSONURL!)
        C.updateLocationCenters()
//        
//            if Auth.auth().currentUser != nil
//            {
//                try! Auth.auth().signOut()
//            }
//
        if Auth.auth().currentUser != nil
        {
            Firestore.firestore().collection(C.userInfo).whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        try! Auth.auth().signOut()
                        let initialViewController = WelcomeViewController()
                        //initialViewController.view.backgroundColor = C.darkColor
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        C.w = self.window?.frame.width
                        C.h = self.window?.frame.height
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                        //self.showLoadingScreen()
                        
                    } else {
                        print("Recieved documents")
                        if querySnapshot!.documents.count == 0
                        {
                            try! Auth.auth().signOut()
                            let initialViewController = WelcomeViewController()
                            //initialViewController.view.backgroundColor = C.darkColor
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            C.w = self.window?.frame.width
                            C.h = self.window?.frame.height
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                            //self.showLoadingScreen()
                        }
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            C.refid = document.documentID
                            C.userData = document.data()
                            C.updateUser()
                            C.updateLocations()
                            //C.addUserListener()
                            //initialViewController.view.backgroundColor = C.darkColor
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            C.w = self.window?.frame.width
                            C.h = self.window?.frame.height
                            self.window?.backgroundColor = .white
                            self.window?.rootViewController = C.navigationViewController
                            self.window?.makeKeyAndVisible()
                           // self.showLoadingScreen()
                        }
                    }
            }
        }
        else
        {
            let initialViewController = WelcomeViewController()
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
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        C.fcmToken = fcmToken
        if C.refid != nil
        {
            let ref = Firestore.firestore().collection(C.userInfo).document(C.refid)
            ref.updateData([ "token" : fcmToken ])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let sender = userInfo["gcm.notification.sender"]
        {
            while C.navigationViewController.mapViewController == nil
            {
            }
            for annotation in C.navigationViewController.mapViewController.mapView.annotations!
            {
                if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 2
                {
                    if sender as? String == (annotation as! MapAnnotation).user.id
                    {
                        C.navigationViewController.mapViewController.mapView.selectAnnotation(annotation, animated: true)
                    }
                }
            }
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if C.navigationViewController.mapViewController.userAnnotation != nil
        {
            C.navigationViewController.mapViewController.userAnnotation.layer.removeAllAnimations()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if C.navigationViewController.mapViewController.userAnnotation != nil
        {
            C.navigationViewController.mapViewController.userAnnotation.layer.removeAllAnimations()
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            
            animation.values = [0.1, 1.0]
            animation.duration = 3
            animation.repeatCount = Float.infinity
            C.navigationViewController.mapViewController.userAnnotation.imageView.layer.add(animation, forKey: nil)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        showLoadingScreen()
    }
    
    func showLoadingScreen()
    {
        if self.window != nil
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h))
            imageView.image = UIImage(named: "launchScreen")
            imageView.contentMode = .scaleAspectFill
            
//            let image1:UIImage = UIImage(named: "loadingScreen1")!
//            let image2:UIImage = UIImage(named: "loadingScreen2")!
//            let image3:UIImage = UIImage(named: "loadingScreen3")!
//            let image4:UIImage = UIImage(named: "loadingScreen4")!
//            let image5:UIImage = UIImage(named: "loadingScreen5")!
//            let image6:UIImage = UIImage(named: "loadingScreen6")!
//            let image7:UIImage = UIImage(named: "loadingScreen7")!
//            let image8:UIImage = UIImage(named: "loadingScreen8")!
//            let image9:UIImage = UIImage(named: "loadingScreen9")!
//            let image10:UIImage = UIImage(named: "loadingScreen10")!
//            let image11:UIImage = UIImage(named: "loadingScreen11")!
//            let image12:UIImage = UIImage(named: "loadingScreen12")!
//            let image13:UIImage = UIImage(named: "loadingScreen13")!
//            let image14:UIImage = UIImage(named: "loadingScreen14")!
//            let image15:UIImage = UIImage(named: "loadingScreen15")!
//            let image16:UIImage = UIImage(named: "loadingScreen16")!
//            let image17:UIImage = UIImage(named: "loadingScreen17")!
//            let image18:UIImage = UIImage(named: "loadingScreen18")!
//            let image19:UIImage = UIImage(named: "loadingScreen19")!
//            let image20:UIImage = UIImage(named: "loadingScreen20")!
//            imageView.animationImages = [image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, image17, image18, image19, image20]
//            imageView.animationDuration = 1
//            imageView.startAnimating()
            
            window?.rootViewController?.view.addSubview(imageView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                imageView.removeFromSuperview()
            })
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

