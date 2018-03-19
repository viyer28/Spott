//
//  PeopleViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class PeopleViewController: UICollectionViewController {
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People";
        let flowLayout = UICollectionViewFlowLayout()
        self.view.backgroundColor = UIColor.white
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: self.view.frame.width * 0.1, bottom: 0, right: self.view.frame.width * 0.1)
        flowLayout.itemSize = CGSize(width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3)

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView!.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.collectionView!.showsHorizontalScrollIndicator = false;
        self.collectionView!.isPagingEnabled = true;
        self.collectionView!.delegate = self;
        self.collectionView!.dataSource = self;
        self.view.addSubview(self.collectionView!)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
         print(1)
        let locationLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.1))
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "FuturaPT-Light", size: 30)
        locationLabel.text = "regenstein library"
        self.view.addSubview(locationLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let profileView = MatchProflieView()
        cell.addSubview(profileView)
        return cell
        // Configure the cell
        
    }
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        targetContentOffset.pointee = scrollView.contentOffset
//        var factor: CGFloat = 0.5
//        if velocity.x < 0 {
//            factor = -factor
//        }
//        let indexPath = IndexPath(row: (Int(scrollView.contentOffset.x/C.w*0.5 + factor)), section: 0)
//        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
//    }
    
}

