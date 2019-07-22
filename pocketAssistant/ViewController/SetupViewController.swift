//
//  SetupViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 16/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class SetupViewController: UIViewController {
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var tryAgainButton: MDCButton!
    @IBOutlet weak var ipTextField: MDCTextField!
    @IBOutlet weak var devicesCollectionView: UICollectionView!
    
    var stringArray = ["lele", "lolo", "lili", "lala", "lulu"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupViews() {
        devicesCollectionView.register(RelacaoCollectionViewCell.self, forCellWithReuseIdentifier: RelacaoCollectionViewCell.identifier)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        performSegue(withIdentifier: "to_login", sender: self)
    }
    
}

extension SetupViewController: UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        
        cell.titleLabel.text = stringArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RelacaoCollectionViewCell
        print("Click \(cell.titleLabel.text ?? "nada")")
        //        segueDelegate?.goToNovaPermisao(userACLpair: userPermission)
    }
    
    
}
