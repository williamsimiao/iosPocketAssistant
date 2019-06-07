//
//  TrusteesViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 07/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class TrusteesViewController: UIViewController {
    
    var itemArray: [item]?
    var selectedUserName: String?
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView!.register(RelacaoCollectionViewCell.self, forCellWithReuseIdentifier: RelacaoCollectionViewCell.identifier)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = .red
        
        self.view.addSubview(collectionView!)
        
        makeRequestListUsers()
    }
    
    func makeRequestListUsers() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let usrName = KeychainWrapper.standard.string(forKey: "USR_NAME") else {
            return
        }
        let op = 1
        NetworkManager().runListUsrsTrust(token: token, op: op, usr: usrName) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.itemArray = response.trust
                DispatchQueue.main.async {
                    self.collectionView!.reloadData()
                }
            }
        }
    }

}

//Delegate, DataSource
extension TrusteesViewController: UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rowCounter = itemArray?.count else {
            return 0
        }
        return rowCounter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        
        guard let data = itemArray else {
            return  cell
        }
        cell.myItem = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        guard let username = cell.myItem?.usr else {
            //TODO: present alert of error
            return
        }
        self.selectedUserName = username
        performSegue(withIdentifier: "to_NovaPermissaoViewController", sender: self)
        //        cellDelegate?.onTapRelacaoCell(isTruster: false, username: username)
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_NovaPermissaoViewController" {
            guard let destinationViewController = segue.destination as? NovaPermissaoViewController else {
                return
            }
            guard let theUsername = self.selectedUserName else {
                return
            }
            destinationViewController.username = theUsername
        }
    }
}

extension TrusteesViewController : barButtonItemDelegate {
    func onRefreshTap() {
        //makeRequest
    }
}
