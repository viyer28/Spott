//
//  MesssagingViewController.swift
//  spott
//
//  Created by Varun Iyer on 6/30/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class MesssagingViewController: UIViewController {
    @IBOutlet weak var recipientCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipientCollectionView.delegate = self
        recipientCollectionView.dataSource = self
    }
}

extension MesssagingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipientCell", for: indexPath)
        return cell
    }
}
