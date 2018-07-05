//
//  SpottScrollViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/28/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SpottScrollViewController: UIViewController {
    @IBOutlet weak var scrollCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollCollectionView.delegate = self
        scrollCollectionView.dataSource = self
    }
}

extension SpottScrollViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrollCell", for: indexPath)
        return cell
    }
}
