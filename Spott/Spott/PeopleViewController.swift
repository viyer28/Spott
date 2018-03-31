//
//  PeopleViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class PeopleViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var segControl = UISegmentedControl(items: ["Spott", "Spotted"])
    var titleLabel: UILabel!
    var mapButton: UIButton!
    var eventsButton: UIButton!
    var spottButton: UIButton!
    var current: [User] = C.user.spotted
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
        self.collectionView!.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
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
        addNav()
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
        return current.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        let profileView = MatchProfileView(user: current[indexPath.row])
        cell.addSubview(profileView)
        return cell
        // Configure the cell
        
    }
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.titleLabel.text = "Spotted"
            current = C.user.spotted
            self.collectionView?.reloadData()
        default:
            self.titleLabel.text = "Spott"
            current = C.user.spotted
            self.collectionView?.reloadData()
        }
        self.collectionView?.reloadData()
    }
    
    
    func addNav()
    {
        self.spottButton = UIButton(type: UIButtonType.custom) as UIButton
        self.mapButton = UIButton(type: UIButtonType.custom) as UIButton
        self.eventsButton = UIButton(type: UIButtonType.custom) as UIButton
        let mImage = UIImage(named: "MapIcon") as UIImage?
        mapButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        mapButton.center = CGPoint(x: C.w*0.5, y: C.h*0.95)
        mapButton.setImage(mImage, for: .normal)
        mapButton.backgroundColor = UIColor.white
        mapButton.layer.cornerRadius = mapButton.frame.width/2
        mapButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        mapButton.clipsToBounds = true
        mapButton.addTarget(self, action: #selector(clickMap), for: UIControlEvents.touchUpInside)
        self.view.addSubview(mapButton)
        
        let eImage = UIImage(named: "EventsIcon") as UIImage?
        eventsButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        eventsButton.center = CGPoint(x: C.w*0.25, y: C.h*0.95)
        eventsButton.setImage(eImage, for: .normal)
        eventsButton.backgroundColor = UIColor.white
        eventsButton.layer.cornerRadius = mapButton.frame.width/2
        eventsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        eventsButton.clipsToBounds = true
        eventsButton.addTarget(self, action: #selector(clickEvents), for: UIControlEvents.touchUpInside)
        self.view.addSubview(eventsButton)
        
        var sImage = UIImage(named: "PeopleIcon") as UIImage?
        sImage = sImage?.withRenderingMode(.alwaysTemplate)
        spottButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        spottButton.center = CGPoint(x: C.w*0.75, y: C.h*0.95)
        spottButton.backgroundColor = UIColor.white
        spottButton.layer.cornerRadius = mapButton.frame.width/2
        spottButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        spottButton.tintColor = C.eventLightBlueColor
        spottButton.setImage(sImage, for: .normal)
        spottButton.clipsToBounds = true
        spottButton.addTarget(self, action: #selector(clickSpott), for: UIControlEvents.touchUpInside)
        self.view.addSubview(spottButton)
        
    }
    
    @objc func clickMap ()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickSpott()
    {
    }
    
    @objc func clickEvents()
    {
        self.dismiss(animated: true, completion: nil)
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

