//
//  PeopleViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class PeopleViewController: UICollectionViewController {
    var segControl = UISegmentedControl(items: ["Spott", "Spotted"])
    var titleLabel: UILabel!
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
        
        segControl.frame = CGRect(x: C.w*0.3, y: C.h*0.11, width: C.w*0.4, height: C.h*0.03)
        segControl.selectedSegmentIndex = 0
        segControl.layer.cornerRadius = 5.0 
        segControl.backgroundColor = C.darkColor
        segControl.tintColor = C.goldishColor
        // spotSegControl.addTarget(self, action: "action:", forControlEvents: .ValueChanged)
        segControl.addTarget(self, action: #selector(changeView), for: UIControlEvents.valueChanged)
        self.view.addSubview(segControl)
        titleLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.02, width: C.w, height: C.h*0.1))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 30)
        titleLabel.text = "Spott"
        self.view.addSubview(titleLabel)
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
    
    func findClosestUsers(user: User, location: Location) -> [User]! {
        var closest: [User]!
        closest = nil
        
        for person in location.population {
            let distance = sqrtf(powf(Float(person.latitude - user.latitude), 2) + powf(Float(person.longitude - user.longitude), 2))
            if (closest == nil){
                closest.insert(person, at: 0)
            } else {
                for (index, p) in closest.enumerated() {
                    let pdist = sqrtf(powf(Float(p.latitude - user.latitude), 2) + powf(Float(p.longitude - user.longitude),2))
                    if (distance <= pdist){
                        closest.insert(person, at: index)
                    }
                }
            }
        }
        
        return closest
    }
    
    func findClosestFriends(user: User, location: Location) -> [User]! {
        var closest: [User]!
        closest = nil
        
        for person in location.friends {
            let distance = sqrtf(powf(Float(person.latitude - user.latitude), 2) + powf(Float(person.longitude - user.longitude), 2))
            if (closest == nil){
                closest.insert(person, at: 0)
            } else {
                for (index, p) in closest.enumerated() {
                    let pdist = sqrtf(powf(Float(p.latitude - user.latitude), 2) + powf(Float(p.longitude - user.longitude),2))
                    if (distance <= pdist){
                        closest.insert(person, at: index)
                    }
                }
            }
        }
        
        return closest
    }
    
    func findClosestNonFriends(user: User, location: Location) -> [User]! {
        var closest_people = findClosestUsers(user: user, location: location)
        let closest_friends = findClosestFriends(user: user, location: location)
        var closest_nonfriends: [User]!
        closest_nonfriends = nil
        
        for (index, person) in closest_people!.enumerated() {
            if (!closest_friends!.contains(person)) {
                closest_nonfriends.append(closest_people!.remove(at: index))
            }
        }
        
        return closest_nonfriends
    }
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.titleLabel.text = "Spotted"
        default:
            self.titleLabel.text = "Spott"
        }
        self.collectionView?.reloadData()
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

