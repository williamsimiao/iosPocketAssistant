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
        
        let backItemImage = UIImage(named: "sharp_arrow_back_ios_black_24pt_")
        let templatedMenuItemImage = backItemImage?.withRenderingMode(.alwaysTemplate)
        let backItem = UIBarButtonItem(image: templatedMenuItemImage,
                                       style: .plain,
                                       target: self,
                                       action: #selector(backItemTapped(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }

}

//Delegate, DataSource
extension ObjetosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width * 0.9

        return CGSize(width: width, height: 50.0)
    }

    
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
        cell.keyLabel.font = MDCTypography.titleFont()
        cell.keyLabel.alpha = MDCTypography.titleFontOpacity()
        cell.keyLabel.text = data[indexPath.row]
        return cell
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
