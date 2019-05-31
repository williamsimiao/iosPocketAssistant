//
//  ObjetosViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class ObjetosViewController: UICollectionViewController {
    
    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Objetos"
        makeRequest()
    }
    
    func makeRequest() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runListObjs(token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.objIdArray = response.obj
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

//Delegate, DataSource
extension ObjetosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width

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
        cell.keyLabel.text = data[indexPath.row]
        return cell
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
