//
//  RelacoesCollectionViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

//protocol relacoesCellDelegate {
//    func onTapRelacaoCell(isTruster: Bool, username: String)
//}

class RelacoesCollectionViewController: UICollectionViewController {

    var tokenString: String?
    var itemArray: [item]?
    var selectedUserName: String?
//    var cellDelegate: relacoesCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Relação"
        makeRequestListUsers()
        setUpBarButtonItens()
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
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setUpBarButtonItens() {
        let refreshButton = UIButton(type: .custom)
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(RelacoesCollectionViewController.didTapAddRefresh), for: .touchUpInside)
        let refreshBarItem = UIBarButtonItem(customView: refreshButton)
        
        let adduserButton = UIButton(type: .custom)
        adduserButton.setImage(UIImage(named: "addUser"), for: .normal)
        adduserButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        adduserButton.addTarget(self, action: #selector(RelacoesCollectionViewController.didTapAdd), for: .touchUpInside)
        let addUserBarItem = UIBarButtonItem(customView: adduserButton)
        
        self.navigationItem.setRightBarButtonItems([addUserBarItem, refreshBarItem], animated: true)
    }
    
    @objc func didTapAdd() {
        performSegue(withIdentifier: "to_CriarUsuarioViewController", sender: self)
    }
    
    @objc func didTapAddRefresh() {
        makeRequestListUsers()
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

//Delegate, DataSource
extension RelacoesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rowCounter = itemArray?.count else {
            return 0
        }
        return rowCounter
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        
        guard let data = itemArray else {
            return  cell
        }
        cell.titleLabel.text = data[indexPath.row].usr
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        guard let username = cell.titleLabel.text else {
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
}
