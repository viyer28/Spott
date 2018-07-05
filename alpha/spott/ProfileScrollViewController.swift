//
//  ProfileScrollViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/27/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class ProfileScrollViewController: UIViewController {
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var placesCollectionView: UICollectionView!
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        
        musicCollectionView.delegate = self
        musicCollectionView.dataSource = self
        
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
    }

}

extension ProfileScrollViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.friendsCollectionView {
            return 2
        } else if collectionView == self.foodCollectionView {
            return 2
        } else if collectionView == self.placesCollectionView {
            return 2
        } else if collectionView == self.musicCollectionView {
            return 2
        } else { // recommendedCollectionView count
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.friendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath)
            return cell
        } else if collectionView == self.foodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath)
            return cell
        } else if collectionView == self.placesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placesCell", for: indexPath)
            return cell
        } else if collectionView == self.musicCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
            return cell
        } else { // recommendedCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedCell", for: indexPath)
            return cell
        }
    }
}
