//
//  ObjetosViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class ObjetosViewController: UICollectionViewController {
    
    var appBarViewController = MDCAppBarViewController()

    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo Pocket 3"
        
        self.addChild(self.appBarViewController)
        self.view.addSubview(self.appBarViewController.view)
        self.appBarViewController.didMove(toParent: self)
        
        // Set the tracking scroll view.
        self.appBarViewController.headerView.trackingScrollView = self.collectionView
    }

}

//Delegate, DataSource
extension ObjetosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rowCounter = objIdArray?.count else {
            return 0
        }
        return rowCounter
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjetoCell", for: indexPath) as! ObjetoCell
        guard let data = objIdArray else {
            return  cell
        }
        cell.keyLabel.text = data[indexPath.row]
        return cell
    }
    
}

extension ObjetosViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                           willDecelerate decelerate: Bool) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity,
                                                     targetContentOffset: targetContentOffset)
        }
    }
    
}
