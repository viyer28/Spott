//
//  SpottScrollCollectionViewCell.swift
//  spott
//
//  Created by Varun Iyer on 6/28/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SpottScrollCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mutualsCollectionView: UICollectionView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var placesCollectionVIew: UICollectionView!
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var spottingCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        mutualsCollectionView.delegate = self
        mutualsCollectionView.dataSource = self
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        placesCollectionVIew.delegate = self
        placesCollectionVIew.dataSource = self
        
        musicCollectionView.delegate = self
        musicCollectionView.dataSource = self
        
        spottingCollectionView.delegate = self
        spottingCollectionView.dataSource = self
    }
}

extension SpottScrollCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mutualsCollectionView {
            return 2
        } else if collectionView == self.foodCollectionView {
            return 2
        } else if collectionView == self.placesCollectionVIew {
            return 2
        } else if collectionView == self.musicCollectionView {
            return 2
        } else { // spottingCollectionView count
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mutualsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mutualsCell", for: indexPath)
            return cell
        } else if collectionView == self.foodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath)
            return cell
        } else if collectionView == self.placesCollectionVIew {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placesCell", for: indexPath)
            return cell
        } else if collectionView == self.musicCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
            return cell
        } else { // spottingCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spottingCell", for: indexPath)
            return cell
        }
    }
}
