//
//  FriendsViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/29/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
    }
}

extension FriendsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath)
        return cell
    }
}
