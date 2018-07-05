//
//  WYDViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/30/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class WYDViewController: UIViewController {
    @IBOutlet weak var wydCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wydCollectionView.delegate = self
        wydCollectionView.dataSource = self
        
    }
}

extension WYDViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wydCell", for: indexPath)
        return cell
    }
}
