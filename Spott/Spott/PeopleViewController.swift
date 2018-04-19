//
//  PeopleViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class PeopleViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var segControl = UISegmentedControl(items: ["spott", "spotted"])
    var titleLabel: UILabel!
    var current: [User] = []
    var sliderInt = 0
    var noOneLabel : UILabel!
    var noOneView: UIView!
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People";
        let flowLayout = UICollectionViewFlowLayout()
        self.view.backgroundColor = UIColor.clear
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: self.view.frame.width * 0.1, bottom: 0, right: self.view.frame.width * 0.1)
        flowLayout.itemSize = CGSize(width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3)
        
        self.noOneView = UIView(frame: CGRect(x: 0, y: 0, width: C.w*0.8, height: C.w * 0.8 + C.h * 0.8 * 0.3))
        self.noOneView.center = CGPoint(x: C.w * 0.5, y: C.h * 0.5)
        self.noOneView.backgroundColor = UIColor.white
        noOneView.layer.borderWidth = 1.0 as CGFloat
        noOneView.layer.borderColor = C.goldishColor.cgColor
        
        self.noOneLabel = UILabel(frame: noOneView.frame)
        noOneLabel.center = CGPoint(x: noOneView.frame.width * 0.5, y: noOneView.frame.height * 0.5)
        noOneLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        noOneLabel.text = "there is no one to spott here"
        noOneLabel.textAlignment = .center
        noOneView.addSubview(noOneLabel)
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView!.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.collectionView!.showsHorizontalScrollIndicator = false;
        self.collectionView!.isPagingEnabled = true;
        self.collectionView!.delegate = self;
        self.collectionView!.dataSource = self;
        self.view.addSubview(self.collectionView!)
        self.view.addSubview(noOneView)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
         print(1)
        
        segControl.frame = CGRect(x: C.w*0.1, y: C.h*0.11, width: C.w*0.8, height: C.h*0.03)
        segControl.selectedSegmentIndex = 0
        segControl.layer.cornerRadius = 5.0 
        segControl.backgroundColor = .white
        segControl.tintColor = C.goldishColor
        // spotSegControl.addTarget(self, action: "action:", forControlEvents: .ValueChanged)
        segControl.addTarget(self, action: #selector(changeView), for: UIControlEvents.valueChanged)
        segControl.setTitleTextAttributes([kCTFontAttributeName: UIFont(name: "FuturaPT-Light", size: 16)],
                                                for: .normal)
        self.view.addSubview(segControl)
        titleLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.02, width: C.w, height: C.h*0.1))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 30)
        titleLabel.text = "spott"
//        self.view.addSubview(titleLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        C.updateUserSpotted()
        C.updateSpottsAtUserLoc()
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
        if current.count == 0
        {
            self.noOneView.isHidden = false
        }
        else
        {
            self.noOneView.isHidden = true
        }
        return current.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) //as! CustomCell
        let profileView = MatchProfileView(user: current[indexPath.section])
        cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: profileView.frame.width, height: profileView.frame.width)
        let button = UIButton(frame: profileView.frame)
        cell.backgroundColor = UIColor.white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(touch(_:)), for: .touchUpInside)
        button.tag = indexPath.section
        cell.addSubview(profileView)
        cell.addSubview(button)
        return cell
        // Configure the cell
        
    }
    
    @objc func touch(_ button: UIButton)
    {
        let path = button.tag
        let userSpotted = C.user.spotted
        if self.sliderInt != 0
        {
            if C.user.spotted.count <= path
            {
                return
            }
            C.db.collection("user_info").document(C.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var friends : [String] = data!["friends"] as! [String]
                    friends.append(userSpotted![path].id)
                    var spotted : [String] = data!["friends"] as! [String]
                    var i = -1
                    for s in spotted
                    {
                        if s == userSpotted![path].id
                        {
                            i = spotted.index(of: s)!
                        }
                    }
                    if i > -1
                    {
                        spotted.remove(at: i)
                    }
                    C.db.collection("user_info").document(C.refid).updateData(["friends" : friends, "spotted" : spotted])
                    C.user.friends.append((userSpotted![path]))
                } else {
                    print("Document does not exist")
                }
            }
            let f = C.user.spotted[path]
            C.user.spotted.remove(at: path)
            C.db.collection("user_info").document(f.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var friends : [String] = data!["friends"] as! [String]
                    friends.append(C.user.id)
                    C.db.collection("user_info").document(f.refid).updateData(["friends" : friends])
                } else {
                    print("Document does not exist")
                }
            }
        }
        else
        {
            let f = self.current[path]
            C.db.collection("user_info").document(f.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var spotted : [String] = data!["spotted"] as! [String]
                    spotted.append(C.user.id)
                    C.currentLocation.spotts.remove(at: path)
                    C.db.collection("user_info").document(f.refid).updateData(["spotted" : spotted])
                } else {
                    print("Document does not exist")
                }
            }
        }
        current.remove(at: path)
        self.collectionView?.reloadData()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.sliderInt == 1
        {
            C.db.collection("user_info").document(C.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var friends : [String] = data!["friends"] as! [String]
                    friends.append(C.user.spotted[indexPath.section].id)
                    C.db.collection("user_info").document(C.refid).updateData(["friends" : friends])
                    C.user.friends.append((C.user.spotted[indexPath.row]))
                    C.user.spotted.remove(at: indexPath.row)
                } else {
                    print("Document does not exist")
                }
            }
            let f = C.user.spotted[indexPath.row]
            C.db.collection("user_info").document(f.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var friends : [String] = data!["friends"] as! [String]
                    friends.append(C.user.spotted[indexPath.section].id)
                    C.db.collection("user_info").document(f.refid).updateData(["friends" : friends, "spotted": C.user.spotted])
                } else {
                    print("Document does not exist")
                }
            }
        }
        else
        {
            C.currentLocation.spotts.remove(at: indexPath.row)
            let f = C.currentLocation.spotts[indexPath.row]
            C.db.collection("user_info").document(f.refid).getDocument { (document, error) in
                if let document = document {
                    let data = document.data()
                    var spotted : [String] = data!["spotted"] as! [String]
                    spotted.append(C.currentLocation.spotts[indexPath.section].id)
                    C.currentLocation.spotts.remove(at: indexPath.section)
                    C.db.collection("user_info").document(f.refid).updateData(["spotted" : spotted])
                } else {
                    print("Document does not exist")
                }
            }
        }
        current.remove(at: indexPath.row)
        self.collectionView?.reloadData()
        
    }
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.titleLabel.text = "spotted"
            current = C.user.spotted
            self.sliderInt = 1
            self.collectionView?.reloadData()
            self.noOneLabel.text = "no one has spotted you"
        default:
            self.titleLabel.text = "spott"
            self.noOneLabel.text = "there is no one to spott here"
            current = C.currentLocation.spotts
            self.sliderInt = 0
            self.collectionView?.reloadData()
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

