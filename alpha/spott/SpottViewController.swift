//
//  SpottViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/27/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SpottViewController: UIViewController {
    @IBOutlet weak var spottCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spottCollectionView.delegate = self
        spottCollectionView.dataSource = self
    }
}

extension SpottViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spottCell", for: indexPath)
        return cell
    }
}
