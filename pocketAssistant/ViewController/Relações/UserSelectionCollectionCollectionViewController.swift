
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
    var selectedUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Seleção de usuário"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        makeRequestListUsers()
        setUpBarButtonItens()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeRequestListUsers()
    }
    
    func makeRequestListUsers() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
//        NetworkManager().runListUsrs(token: token) { (response, errorResponse) in
//            if let errorResponse = errorResponse {
//                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
//                let snackBar = MDCSnackbarMessage()
//                snackBar.text = message
//                MDCSnackbarManager.show(snackBar)
//            }
//            if let response = response {
//                self.usrsArray = response.usr
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "from_selection_novaPermissao" {
            guard let destinationViewController = segue.destination as? NovaPermissaoViewController else {
                return
            }
            destinationViewController.userName = self.selectedUserName
        }
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        cell.userName = data[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GestaoUsuariosCollectionViewCell
        self.selectedUserName = cell.userName
        performSegue(withIdentifier: "from_selection_novaPermissao", sender: self)
    }
}
