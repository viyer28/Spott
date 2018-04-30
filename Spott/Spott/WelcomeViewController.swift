//
//  WelcomeViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 4/19/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {
    var startLabel: UILabel!
    var stage = 1
    var nda: UITextView!
    var button: UIButton!
    var but: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let cw = self.view.frame.width
        let ch = self.view.frame.height
        
        
        let path = Bundle.main.path(forResource: "nda", ofType: "txt")
        let ndaText = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        
        nda = UITextView(frame:CGRect(x: C.w*0.1, y: C.h*0.45, width: C.w*0.8, height: C.h*0.4));
        nda.font = UIFont(name: "FuturaPT-Light", size: 12.0)
        nda.backgroundColor = .clear
        nda.text = ndaText;
        nda.isEditable = false
        
        let spottImg = UIImageView(frame:CGRect(x: cw * 0.5 - ch * 0.125, y: ch * 0.15, width: ch * 0.25, height: ch*0.25))
        spottImg.image = UIImage(named: "spottOwl")
        self.view.addSubview(spottImg)
        
        let betaImg = UIImageView(frame:CGRect(x: C.w*0.5-ch*0.05*640.0/176.0 / 2.0, y: ch * 0.375, width: ch*0.05*640.0/176.0, height: ch*0.05))
        betaImg.image = UIImage(named: "betaImage")
        self.view.addSubview(betaImg)
        
        
        startLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.5, width: C.w, height: ch*0.2))
        startLabel.textAlignment = .center
        startLabel.font = UIFont(name: "FuturaPT-Light", size: 30.0)
        startLabel.text = "tap to begin"
        self.view.addSubview(startLabel)
        
        button = UIButton(type: .system) // let preferred over var here
        button.frame = CGRect(x: C.w*0.35, y: C.h*0.7, width: C.w*0.3, height: ch*0.04)
        //button.backgroundColor = C.goldishColor
        button.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        button.titleLabel?.text = "or log in"
        button.setTitleColor(C.darkColor, for: .normal)
        button.setTitle("or log in", for: .normal)
        button.addTarget(self, action: #selector(loginClick), for: UIControlEvents.touchUpInside)
        button.tag = 1
        self.view.addSubview(button)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginClick()
    {
        self.present(LoginViewController(), animated: false, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        let tag = touch?.view?.tag
        if tag == 1{
            return
        }else{
            if stage == 1 || stage == 3
            {
                if stage == 1
                {
                    goToStage2()
                }
                else if stage == 2
                {
                    goToStage3()
                }
                else if stage == 3
                {
                    findUser()
                }
            }
        }
        
    }
    func goToStage2()
    {
        stage = 2
        startLabel.isHidden = true
        button.removeFromSuperview()
        self.view.addSubview(nda)
        
        but = UIButton(type: .system) // let preferred over var here
        but.frame = CGRect(x: C.w*0.35, y: C.h*0.87, width: C.w*0.3, height: C.h*0.04)
        //button.backgroundColor = C.goldishColor
        but.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: 20.0)
        but.titleLabel?.text = "accept"
        but.setTitleColor(C.darkColor, for: .normal)
        but.setTitle("accept", for: .normal)
        but.addTarget(self, action: #selector(goToStage3), for: UIControlEvents.touchUpInside)
        self.view.addSubview(but)
    }
    @objc func goToStage3()
    {
        stage = 3
        but.removeFromSuperview()
        nda.removeFromSuperview()
        startLabel.isHidden = false
        startLabel.text = "first, let's find you."
    }
    
    @objc func findUser()
    {
        stage = 4
        C.navigationViewController.locationManager = CLLocationManager()
        C.navigationViewController.locationManager.requestAlwaysAuthorization()
        self.view.isUserInteractionEnabled = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                startLabel.text = "Enable location to use spott"
            case .authorizedAlways, .authorizedWhenInUse:
                C.navigationViewController.onboarding = 1
                self.present(C.navigationViewController, animated: false, completion: nil)
            }
        } else {
            startLabel.text = "Enable location to use spott"
        }
    }
    
}


