//
//  DrawerContentViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 31/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class DrawerContentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let listObetosInfo = DrawerCellinfo(title: "Listar Objetos")
    let outraCoisaInfo = DrawerCellinfo(title: "Outra coisa")
    let drawerCellInfoArray = [DrawerCellinfo(title: "Listar Objetos"),DrawerCellinfo(title: "Outra coisa")]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension DrawerContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = drawerCellInfoArray.count
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DrawerCell
        cell.titleLabel.text = drawerCellInfoArray[indexPath.row].title
        return cell
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DrawerCell
        guard let title = cell.titleLabel.text else {
            print("problema com title")
            return
        }
        print("TITLE: \(title)")
    }

    
}
