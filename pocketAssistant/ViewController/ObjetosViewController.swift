//
//  ObjetosViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class ObjetosViewController: UICollectionViewController {

    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    //
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let rowCounter = objIdArray?.count else {
//            return 0
//        }
//        return rowCounter
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        guard let data = objIdArray else {
//            return  cell
//        }
//        cell.textLabel?.text = data[indexPath.row]
//        return cell
//    }
    
    
}
