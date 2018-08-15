//
//  SpottViewController.swift
//  spott
//
//  Created by Varun Iyer on 7/31/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SpottViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var spottCollectionView: UICollectionView!
    var current: [User]! = []
    var segControl = UISegmentedControl(items: ["spott", "spotted"])
    var noOneLabel : UILabel!
    var noOneView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        spottCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        spottCollectionView.showsHorizontalScrollIndicator = false
        spottCollectionView.isPagingEnabled = true
        spottCollectionView.delegate = self
        spottCollectionView.dataSource = self
        spottCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(spottCollectionView)
        spottCollectionView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.snp.top).offset(120)
            make.bottom.equalTo(self.view.snp.bottom).offset(-140)
            make.right.equalTo(self.view.snp.right).offset(-40)
            make.left.equalTo(self.view.snp.left).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        spottCollectionView.register(SpottCollectionViewCell.self, forCellWithReuseIdentifier: "spottCell")
        
        segControl.selectedSegmentIndex = 0
        segControl.layer.cornerRadius = 15.0
        segControl.backgroundColor = .white
        segControl.tintColor = UIColor(red: 213.0/255.0, green: 177.0/255.0, blue: 132.0/255.0, alpha:1.0)
        segControl.addTarget(self, action: #selector(changeView), for: UIControlEvents.valueChanged)
        segControl.setTitleTextAttributes([kCTFontAttributeName: UIFont(name: "FuturaPT-Light", size: 16)!],
                                          for: .normal)
        self.view.addSubview(segControl)
        segControl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.snp.top).offset(75)
            make.bottom.equalTo(self.spottCollectionView.snp.top).offset(-20)
            make.left.equalTo(self.view.snp.left).offset(100)
            make.right.equalTo(self.view.snp.right).offset(-100)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if current.count == 0
        {
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = spottCollectionView.dequeueReusableCell(withReuseIdentifier: "spottCell", for: indexPath) as! SpottCollectionViewCell
        //cell.cellViewData = SpottCollectionViewCell.CellViewData(user: current[indexPath.row])
        cell.layer.cornerRadius = 25
        cell.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width-10), height: (collectionView.frame.height-10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            //current = B.user.spotted
            //self.sliderInt = 1
            self.spottCollectionView?.reloadData()
            //self.noOneLabel.text = "no one has spotted you"
        default:
            //self.titleLabel.text = "spott"
            //self.noOneLabel.text = "there is no one to spott here"
            //current = B.user.spotts
            //self.sliderInt = 0
            self.spottCollectionView?.reloadData()
        }
        self.spottCollectionView?.reloadData()
    }
}
