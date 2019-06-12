
//
//  UserSelectionCollectionCollectionViewController.swift
//  pocketAssistant
//
//  Created by William on 11/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class UserSelectionCollectionCollectionViewController: UICollectionViewController {

    var tokenString: String?
    var usrsArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Seleção de Usuários"
        makeRequestListUsers()
        setUpBarButtonItens()
    }
    
    func makeRequestListUsers() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runListUsrs(token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.usrsArray = response.usr
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setUpBarButtonItens() {
        let refreshButton = UIButton(type: .custom)
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(GestaoUsuariosCollectionViewController.didTapAddRefresh), for: .touchUpInside)
        let refreshBarItem = UIBarButtonItem(customView: refreshButton)
        
       
        self.navigationItem.setRightBarButtonItems([refreshBarItem], animated: true)
    }
    
    @objc func didTapAddRefresh() {
        makeRequestListUsers()
    }
    
}

//Delegate, DataSource
extension UserSelectionCollectionCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rowCounter = usrsArray?.count else {
            return 0
        }
        return rowCounter
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GestaoUsuariosCollectionViewCell.identifier, for: indexPath) as! GestaoUsuariosCollectionViewCell
        
        guard let data = usrsArray else {
            return  cell
        }
        cell.setUserName(data[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
