//
//  GestaoUsuariosCollectionViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class GestaoUsuariosCollectionViewController: UICollectionViewController {

    var tokenString: String?
    var usrsArray: [String]?
    var networkManager: NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Usuários"
        makeListUsersRequest()
    }
    
    func makeListUsersRequest() {
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
        refreshButton.setImage(UIImage(named: "imagename"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(GestaoUsuariosCollectionViewController.didTapAddRefresh), for: .touchUpInside)
        let refreshBarItem = UIBarButtonItem(customView: refreshButton)
        
        let adduserButton = UIButton(type: .custom)
        adduserButton.setImage(UIImage(named: "imagename"), for: .normal)
        adduserButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        adduserButton.addTarget(self, action: #selector(GestaoUsuariosCollectionViewController.didTapAddUser), for: .touchUpInside)
        let addUserBarItem = UIBarButtonItem(customView: adduserButton)
        
        self.navigationItem.setRightBarButtonItems([refreshBarItem,addUserBarItem], animated: true)
    }
    
    @objc func didTapAddUser() {
        
    }
    
    @objc func didTapAddRefresh() {
        makeListUsersRequest()
    }
}

//Delegate, DataSource
extension GestaoUsuariosCollectionViewController: UICollectionViewDelegateFlowLayout {
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
        cell.actionDelegate = self
        cell.setUserName(data[indexPath.row])
        return cell
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GestaoUsuariosCollectionViewController: gestaoUsuariosCellDelegate {
    func onDeleteTapped(userName: String) {
        print("tap delete: \(userName)")
    }
    
    func onEditTapped(userName: String) {
        print("tap edit: \(userName)")
    }
}
