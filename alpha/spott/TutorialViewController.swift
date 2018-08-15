//
//  TutorialViewController.swift
//  spott
//
//  Created by Varun Iyer on 7/30/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    var youImg: UIImageView!
    var spottImg: UIImageView!
    var searchImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        youImg = UIImageView(image: #imageLiteral(resourceName: "you"))
        youImg.contentMode = .scaleAspectFit
        youImg.alpha = 0
        view.addSubview(youImg)
        youImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(125)
            make.left.equalTo(self.view.snp.leftMargin).offset(100)
            make.right.equalTo(self.view.snp.rightMargin).offset(-100)
        }
        
        
        self.youFadeIn()
    }
    
    // MARK: Animations
    
    func youFadeIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.youImg.alpha = 1
            })
            self.youFadeOut()
        })
    }
    
    func youFadeOut() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.youImg.alpha = 0
            })
            self.spottAppear()
        })
    }
    
    func spottAppear() {
        B.mapViewController.view.addSubview(B.mapViewController.spottButton)
        B.mapViewController.spottButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(B.mapViewController.view.snp.centerX)
            make.bottom.equalTo(B.mapViewController.view.snp.bottom).offset(-75)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                B.mapViewController.spottButton.alpha = 1
            }, completion: nil)
        })
        
        self.spottImg = UIImageView(image: #imageLiteral(resourceName: "thisisspottbutton"))
        self.spottImg.contentMode = .scaleAspectFit
        self.spottImg.alpha = 0
        self.view.addSubview(self.spottImg)
        self.spottImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-150)
            make.left.equalTo(self.view.snp.leftMargin).offset(25)
            make.right.equalTo(self.view.snp.rightMargin).offset(-25)
            make.height.equalTo(50)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.spottImg.alpha = 1
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.spottImg.alpha = 0
            })
        })
        
        searchAppear()
    }
    
    func searchAppear() {
        B.mapViewController.view.addSubview(B.mapViewController.searchBlurView)
        B.mapViewController.searchBlurView.snp.makeConstraints { (make) in
            make.centerX.equalTo(B.mapViewController.view.snp.centerX)
            make.top.equalTo(B.mapViewController.view.snp.top).offset(-200)
            make.width.equalTo(B.mapViewController.view.snp.width)
            make.bottom.equalTo(B.mapViewController.view.snp.top).offset(110)
        }
        
        B.mapViewController.view.addSubview(B.mapViewController.searchButton)
        B.mapViewController.searchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(B.mapViewController.view.snp.centerX)
            make.top.equalTo(B.mapViewController.view.snp.top).offset(45)
            make.height.equalTo(50)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                B.mapViewController.searchBlurView.alpha = 0.8
                B.mapViewController.searchButton.alpha = 1
            })
        })
        
        self.searchImg = UIImageView(image: #imageLiteral(resourceName: "thisissearch"))
        self.searchImg.contentMode = .scaleAspectFit
        self.searchImg.alpha = 0
        self.view.addSubview(self.searchImg)
        self.searchImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(150)
            make.left.equalTo(self.view.snp.leftMargin).offset(25)
            make.right.equalTo(self.view.snp.rightMargin).offset(-25)
            make.height.equalTo(50)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.searchImg.alpha = 1
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.searchImg.alpha = 0
                self.removeFromParentViewController()
            })
        })
    }
}
