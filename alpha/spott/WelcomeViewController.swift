//
//  WelcomeViewController.swift
//  spott
//
//  Created by Varun Iyer on 7/20/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit
import Mapbox
import SnapKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    var introImg: UIImageView!
    var tapImg: UIImageView!
    var firstImg: UIImageView!
    var lastImg: UIImageView!
    var nameImg: UIImageView!
    var phoneImg: UIImageView!
    var phoneDescrImg: UIImageView!
    var codeImg: UIImageView!
    var codeDescrImg: UIImageView!
    var picImg: UIImageView!
    var cameraButton: UIButton!
    var musicImg: UIImageView!
    var spotifyButton: UIButton!
    var locationReq1: UIImageView!
    var locationReq2: UIImageView!
    var locationReq3: UIImageView!
    var cont: UIImageView!
    var turnLocationOn: UIImageView!
    
    var startingLoc: CLLocationCoordinate2D!
    var button: UIButton!
    
    var phoneErrorLabel: UILabel!
    var codeErrorLabel: UILabel!
    
    var phoneErr: Bool = false
    var codeErr: Bool = false
    var move: Bool = true
    
    var textField: UITextField!
    var phoneField: UITextField!
    
    var stage: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var phoneNum: String = ""
    var verificationID: String = ""
    var verificationCode: String = ""
    var profileImageView: UIImageView!
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        introImg = UIImageView(image: #imageLiteral(resourceName: "intro"))
        introImg.contentMode = .scaleAspectFit
        introImg.alpha = 0
        view.addSubview(introImg)
        introImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(75)
            make.top.equalTo(self.view.snp.top).offset(200)
            make.left.equalTo(self.view.snp.leftMargin).offset(75)
            make.right.equalTo(self.view.snp.rightMargin).offset(-75)
        }
        
        tapImg = UIImageView(image: #imageLiteral(resourceName: "taptobegin"))
        tapImg.contentMode = .scaleAspectFit
        tapImg.alpha = 0
        view.addSubview(tapImg)
        tapImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(125)
            make.left.equalTo(self.view.snp.leftMargin).offset(100)
            make.right.equalTo(self.view.snp.rightMargin).offset(-100)
        }
        
        button = UIButton()
        button.frame = UIScreen.main.bounds
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(stage1), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        
        startingLoc = CLLocationCoordinate2DMake(0, 0)
        B.move = 2
        
        introLabelFadeIn()
        tapImgPulse()
        moveMap()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: NSNotification.Name("logged in"), object: nil)
    }
    
    @objc func stage1() {
        stage = 1
        
        UIView.animate(withDuration: 1){
            self.introImg.removeFromSuperview()
            self.tapImg.removeFromSuperview()
            self.button.removeFromSuperview()
            B.zoomLevel = 1.5
            B.mapViewController.mapView.setCenter(self.startingLoc, zoomLevel: B.zoomLevel, animated: true)
        
            self.nameImg = UIImageView(image: #imageLiteral(resourceName: "whatsyourname"))
            self.nameImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.nameImg)
            self.nameImg.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
                make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
                make.height.equalTo(50)
                make.top.equalTo(self.view.snp.top).offset(200)
            }
            
            self.textField = UITextField()
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.returnKeyType = UIReturnKeyType.next
            self.textField.autocorrectionType = UITextAutocorrectionType.no
            self.textField.textAlignment = .center
            self.textField.delegate = self
            self.textField.font = UIFont(name: "FuturaPT-Light", size: 25.0)
            self.textField.defaultTextAttributes.updateValue(3, forKey: NSAttributedStringKey.kern.rawValue)
            self.textField.borderStyle = UITextBorderStyle.roundedRect
            self.textField.autocapitalizationType = .none
            self.textField.backgroundColor = UIColor(white: 1, alpha: 0.3)
            self.view.addSubview(self.textField)
            self.textField.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.nameImg.snp.trailing)
                make.leading.equalTo(self.nameImg.snp.leading)
                make.top.equalTo(self.nameImg.snp.bottom).offset(150)
                make.height.equalTo(40)
            }
            self.textField.becomeFirstResponder()
            
            self.firstImg = UIImageView(image: #imageLiteral(resourceName: "first"))
            self.firstImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.firstImg)
            self.firstImg.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.width.equalTo(45)
                make.height.equalTo(50)
                make.top.equalTo(self.textField.snp.bottom).offset(10)
            }
        }
    }
    
    func stage2() {
        stage = 2
        
        UIView.animate(withDuration: 2){
            self.firstImg.removeFromSuperview()
            
            self.lastImg = UIImageView(image: #imageLiteral(resourceName: "last"))
            self.lastImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.lastImg)
            self.lastImg.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.width.equalTo(45)
                make.height.equalTo(50)
                make.top.equalTo(self.textField.snp.bottom).offset(10)
            }
        }
    }
    
    func stage3() {
        stage = 3
        
        UIView.animate(withDuration: 2){
            self.lastImg.removeFromSuperview()
            self.textField.removeFromSuperview()
            self.nameImg.removeFromSuperview()
            
            B.zoomLevel = 2
            B.mapViewController.mapView.setCenter(self.startingLoc, zoomLevel: B.zoomLevel, animated: true)
            
            self.phoneImg = UIImageView(image: #imageLiteral(resourceName: "whatsyourphone"))
            self.phoneImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.phoneImg)
            self.phoneImg.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
                make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
                make.height.equalTo(50)
                make.top.equalTo(self.view.snp.top).offset(200)
            }
            
            self.phoneField = UITextField()
            self.phoneField.keyboardType = UIKeyboardType.phonePad
            self.phoneField.textAlignment = .center
            self.phoneField.delegate = self
            self.phoneField.font = UIFont(name: "FuturaPT-Light", size: 25.0)
            self.phoneField.defaultTextAttributes.updateValue(3, forKey: NSAttributedStringKey.kern.rawValue)
            self.phoneField.borderStyle = UITextBorderStyle.roundedRect
            self.phoneField.backgroundColor = UIColor(white: 1, alpha: 0.3)
            self.addDoneButtonOnKeyboard()
            self.view.addSubview(self.phoneField)
            self.phoneField.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.phoneImg.snp.trailing)
                make.leading.equalTo(self.phoneImg.snp.leading)
                make.top.equalTo(self.phoneImg.snp.bottom).offset(150)
                make.height.equalTo(40)
            }
            self.phoneField.becomeFirstResponder()
            
            self.phoneDescrImg = UIImageView(image: #imageLiteral(resourceName: "phonedescr"))
            self.phoneDescrImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.phoneDescrImg)
            self.phoneDescrImg.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.phoneField.snp.trailing)
                make.leading.equalTo(self.phoneField.snp.leading)
                make.top.equalTo(self.phoneField.snp.bottom).offset(5)
                make.height.equalTo(20)
            }
        }
    }
    
    func phoneError() {
        self.phoneErr = true
        
        UIView.animate(withDuration: 1){
            self.phoneDescrImg.removeFromSuperview()
            
            self.phoneErrorLabel = UILabel()
            self.phoneErrorLabel.textAlignment = .center
            self.phoneErrorLabel.addCharactersSpacing(spacing: 3, text: "invalid phone number")
            self.phoneErrorLabel.font = UIFont(name: "FuturaPT-Light", size: 14)
            self.phoneErrorLabel.textColor = UIColor.red
            self.view.addSubview(self.phoneErrorLabel)
            self.phoneErrorLabel.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.height.equalTo(20)
                make.trailing.equalTo(self.phoneField.snp.trailing)
                make.leading.equalTo(self.phoneField.snp.leading)
                make.top.equalTo(self.phoneField.snp.bottom).offset(5)
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.phoneField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        if textFieldShouldReturn(phoneField) {
            return
        }
    }
    
    func stage4() {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                self.phoneError()
                return
            }
            self.stage = 4
            
            self.verificationID = verificationID!
            
            if(self.phoneErr){
                self.phoneErrorLabel.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 1){
                self.phoneDescrImg.removeFromSuperview()
                self.phoneImg.removeFromSuperview()
                
                self.codeImg = UIImageView(image: #imageLiteral(resourceName: "whatsthecode"))
                self.codeImg.contentMode = .scaleAspectFit
                self.view.addSubview(self.codeImg)
                self.codeImg.snp.makeConstraints { (make) in
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
                    make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
                    make.height.equalTo(50)
                    make.top.equalTo(self.view.snp.top).offset(200)
                }
                
                self.phoneField.snp.makeConstraints { (make) in
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.trailing.equalTo(self.codeImg.snp.trailing)
                    make.leading.equalTo(self.codeImg.snp.leading)
                    make.top.equalTo(self.codeImg.snp.bottom).offset(150)
                    make.height.equalTo(40)
                }
                self.phoneField.becomeFirstResponder()
                
                self.codeDescrImg = UIImageView(image: #imageLiteral(resourceName: "wetextedittoyou"))
                self.codeDescrImg.contentMode = .scaleAspectFit
                self.view.addSubview(self.codeDescrImg)
                self.codeDescrImg.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.trailing.equalTo(self.phoneField.snp.trailing)
                    make.leading.equalTo(self.phoneField.snp.leading)
                    make.top.equalTo(self.phoneField.snp.bottom).offset(5)
                    make.height.equalTo(20)
                }
            }
        }
    }
    
    func codeError() {
        codeErr = true
        
        UIView.animate(withDuration: 1){
            self.codeDescrImg.removeFromSuperview()
            
            self.codeErrorLabel = UILabel()
            self.codeErrorLabel.textAlignment = .center
            self.codeErrorLabel.addCharactersSpacing(spacing: 3, text: "invalid code")
            self.codeErrorLabel.font = UIFont(name: "FuturaPT-Light", size: 14)
            self.codeErrorLabel.textColor = UIColor.red
            self.view.addSubview(self.codeErrorLabel)
            self.codeErrorLabel.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.height.equalTo(20)
                make.trailing.equalTo(self.phoneField.snp.trailing)
                make.leading.equalTo(self.phoneField.snp.leading)
                make.top.equalTo(self.phoneField.snp.bottom).offset(5)
            }
        }
    }
    
    func stage5() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
            if error != nil {
                print(error!.localizedDescription)
                
                return
            } else {
                UIView.animate(withDuration: 1){
                    self.codeImg.removeFromSuperview()
                    if(self.codeErr){
                        self.codeErrorLabel.removeFromSuperview()
                    }
                    self.phoneField.removeFromSuperview()
                    
                    B.zoomLevel = 1
                    B.mapViewController.mapView.setCenter(self.startingLoc, zoomLevel: B.zoomLevel, animated: true)
                    
                    self.locationReq1 = UIImageView(image: #imageLiteral(resourceName: "locationrequest1"))
                    self.locationReq1.contentMode = .scaleAspectFit
                    self.view.addSubview(self.locationReq1)
                    self.locationReq1.snp.makeConstraints{ (make) in
                        make.centerX.equalTo(self.view.snp.centerX)
                        make.top.equalTo(self.view.snp.top).offset(200)
                        make.left.equalTo(self.view.snp.leftMargin).offset(25)
                       make.height.equalTo(100)
                        make.right.equalTo(self.view.snp.rightMargin).offset(-25)
                    }
                    
                    self.button = UIButton()
                    self.button.frame = UIScreen.main.bounds
                    self.button.backgroundColor = .clear
                    self.button.addTarget(self, action: #selector(self.stage6), for: UIControlEvents.touchUpInside)
                    self.view.addSubview(self.button)
                }
                
                self.cont = UIImageView(image: #imageLiteral(resourceName: "continue"))
                self.cont.contentMode = .scaleAspectFit
                self.cont.alpha = 0
                self.view.addSubview(self.cont)
                self.cont.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.centerY.equalTo(self.view.snp.centerY).offset(125)
                    make.left.equalTo(self.view.snp.leftMargin).offset(125)
                    make.right.equalTo(self.view.snp.rightMargin).offset(-125)
                }
                self.contImgPulse()
            }
        }
    }
    
    @objc func stage6() {
        UIView.animate(withDuration: 2){
            self.locationReq1.removeFromSuperview()
            self.button.removeFromSuperview()
            
            self.locationReq2 = UIImageView(image: #imageLiteral(resourceName: "locationrequest2"))
            self.locationReq2.contentMode = .scaleAspectFit
            self.view.addSubview(self.locationReq2)
            self.locationReq2.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(self.view.snp.top).offset(200)
                make.height.equalTo(150)
                make.left.equalTo(self.view.snp.leftMargin).offset(25)
                make.right.equalTo(self.view.snp.rightMargin).offset(-25)
            }
            
            self.button = UIButton()
            self.button.frame = UIScreen.main.bounds
            self.button.backgroundColor = .clear
            self.button.addTarget(self, action: #selector(self.stage7), for: UIControlEvents.touchUpInside)
            self.view.addSubview(self.button)
        }
    }
    
    @objc func stage7() {
        UIView.animate(withDuration: 2){
            self.locationReq2.removeFromSuperview()
            self.cont.removeFromSuperview()
            self.button.removeFromSuperview()
            
            self.locationReq3 = UIImageView(image: #imageLiteral(resourceName: "locationrequest3"))
            self.locationReq3.contentMode = .scaleAspectFit
            self.view.addSubview(self.locationReq3)
            self.locationReq3.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(self.view.snp.top).offset(200)
                make.height.equalTo(150)
                make.left.equalTo(self.view.snp.leftMargin).offset(25)
                make.right.equalTo(self.view.snp.rightMargin).offset(-25)
            }
            
            self.turnLocationOn = UIImageView(image: #imageLiteral(resourceName: "turnyourlocationon"))
            self.turnLocationOn.contentMode = .scaleAspectFit
            self.turnLocationOn.alpha = 0
            self.view.addSubview(self.turnLocationOn)
            self.turnLocationOn.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.centerY.equalTo(self.view.snp.centerY).offset(125)
                make.left.equalTo(self.view.snp.leftMargin).offset(75)
                make.right.equalTo(self.view.snp.rightMargin).offset(-75)
            }
            self.locImgPulse()
            
            self.button = UIButton()
            self.button.frame = UIScreen.main.bounds
            self.button.backgroundColor = .clear
            self.button.addTarget(self, action: #selector(self.stage8), for: UIControlEvents.touchUpInside)
            self.view.addSubview(self.button)
        }
    }
    
    @objc func stage8() {
        self.button.removeFromSuperview()
        B.mapViewController.locationManager = CLLocationManager()
        B.mapViewController.locationManager.requestAlwaysAuthorization()

        while CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                stage7()
                return
            case .authorizedAlways, .authorizedWhenInUse:
                move = false
                B.welcome = false
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                B.mapViewController.zoom = true
                B.mapViewController.determineCurrentLocation()
                return
            }
        }
        return
    }
    
    func stage10() {
        UIView.animate(withDuration: 2){
            B.zoomLevel = 2.5
            B.mapViewController.mapView.setCenter(self.startingLoc, zoomLevel: B.zoomLevel, animated: true)
            
            self.picImg = UIImageView(image: #imageLiteral(resourceName: "whatsyourpic"))
            self.picImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.picImg)
            self.picImg.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
                make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
                make.height.equalTo(50)
                make.top.equalTo(self.view.snp.top).offset(200)
            }
            
            self.cameraButton = UIButton()
            self.cameraButton.setImage(#imageLiteral(resourceName: "cameraroll"), for: .normal)
            self.cameraButton.imageView?.contentMode = .scaleAspectFit
            self.view.addSubview(self.cameraButton)
            self.cameraButton.addTarget(self, action: #selector(self.selectPic), for: .touchUpInside)
            self.cameraButton.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.picImg.snp.trailing).offset(-25)
                make.leading.equalTo(self.picImg.snp.leading).offset(25)
                make.centerY.equalTo(self.view.snp.centerY)
            }
        }
    }
    
    @objc func selectPic() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: stage7)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func stage11() {
        UIView.animate(withDuration: 1){
            self.picImg.removeFromSuperview()
            self.cameraButton.removeFromSuperview()
            
            B.zoomLevel = 3
            B.mapViewController.mapView.setCenter(self.startingLoc, zoomLevel: B.zoomLevel, animated: true)
            
            self.musicImg = UIImageView(image: #imageLiteral(resourceName: "whatsyourmusic"))
            self.musicImg.contentMode = .scaleAspectFit
            self.view.addSubview(self.musicImg)
            self.musicImg.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.view.snp.trailingMargin).offset(-50)
                make.leading.equalTo(self.view.snp.leadingMargin).offset(50)
                make.height.equalTo(50)
                make.top.equalTo(self.view.snp.top).offset(200)
            }
            
            self.spotifyButton = UIButton()
            self.spotifyButton.setImage(#imageLiteral(resourceName: "connectspotify"), for: .normal)
            self.spotifyButton.imageView?.contentMode = .scaleAspectFit
            self.view.addSubview(self.spotifyButton)
            self.spotifyButton.snp.makeConstraints{ (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.trailing.equalTo(self.musicImg.snp.trailing).offset(-25)
                make.leading.equalTo(self.musicImg.snp.leading).offset(25)
                make.centerY.equalTo(self.view.snp.centerY)
            }
            self.spotifyButton.addTarget(self, action: #selector(self.connectSpotify), for: .touchUpInside)
        }
    }
    
    @objc func connectSpotify() {
        if UIApplication.shared.canOpenURL(loginUrl!) {
            UIApplication.shared.open(loginUrl!, completionHandler: nil)
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    func setup() {
        SPTAuth.defaultInstance().clientID = "9ff45c20773345a99b397f7202f507d6"
        SPTAuth.defaultInstance().redirectURL = URL(string: "http://www.spott.live/callback/")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    @objc func updateAfterFirstLogin() {
        if let sessionObj:AnyObject = B.userDefaults?.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }

    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
    // MARK: Animations
    
    func introLabelFadeIn(){
        UIImageView.animate(withDuration: 2){
            self.introImg.alpha = 1
        }
    }
    
    func tapImgPulse(){
        UIImageView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.tapImg.alpha = 1
            }, completion: nil)
    }
    
    func contImgPulse(){
        UIImageView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.cont.alpha = 1
        }, completion: nil)
    }
    
    func locImgPulse(){
        UIImageView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.turnLocationOn.alpha = 1
        }, completion: nil)
    }
    
    func moveMap() {
        if(move){
            startingLoc.longitude += B.move
            B.mapViewController.mapView.setCenter(startingLoc, zoomLevel: B.zoomLevel, direction: 0, animated: true, completionHandler: moveMap)
        }
    }
}

extension WelcomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch stage {
        case 1:
            firstName = textField.text!
            textField.text = ""
            stage2()
        case 2:
            lastName = textField.text!
            textField.text = ""
            stage3()
        case 3:
            if !textField.text!.isPhoneNumber {
                phoneError()
            } else {
                phoneNum = "+" + textField.text!
                print(phoneNum)
                phoneField.text = ""
                stage4()
            }
        case 4:
            verificationCode = textField.text!
            textField.text = ""
            stage5()
        default:
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
            // Do not allow upper case letters
            return false
        }
        
        if stage == 3 {
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 14
        }
        
        return true
    }
}

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, text.count - 1))
        self.attributedText = attributedString
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
