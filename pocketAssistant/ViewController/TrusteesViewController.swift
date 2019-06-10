//
//  TrusteesViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 07/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import MaterialComponents

class TrusteesViewController: UIViewController {
    
    var itemArray: [item]?
    var selectedUserPermissions: item?
    var collectionView: UICollectionView?
    var isTrustees: Bool?
    
    let noContentLabel : UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.textColor = .black
        lbl.font = MDCTypography.body2Font()
        lbl.alpha = MDCTypography.body2FontOpacity()
        lbl.text = "Nenhum usuário listado"
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView!.register(RelacaoCollectionViewCell.self, forCellWithReuseIdentifier: RelacaoCollectionViewCell.identifier)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.view.addSubview(noContentLabel)
        self.view.addSubview(collectionView!)
        diferences()
        makeRequestListUsers()
    }
    
    func setupViews() {
        NSLayoutConstraint.activate([
            noContentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noContentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
    }
    
    func diferences() {
        collectionView?.backgroundColor = .white

        guard let isTrustees = self.isTrustees else {
            return
        }
        if isTrustees {
            print("RED")
        }
        else {
            print("YELLOW")
        }
    }
    
    func makeRequestListUsers() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let usrName = KeychainWrapper.standard.string(forKey: "USR_NAME") else {
            return
        }
        guard let isTrustees = self.isTrustees else {
            return
        }
        let op = isTrustees ? 1 : 2
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
            self.noContentLabel.isHidden = false
            return 0
        }
        self.noContentLabel.isHidden = true
        return rowCounter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        
        guard let data = itemArray else {
            return  cell
        }
        cell.userPermission = data[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RelacaoCollectionViewCell
        guard let userPermission = cell.userPermission else {
            //TODO: present alert of error
            return
        }
        self.selectedUserPermissions = userPermission
        performSegue(withIdentifier: "to_NovaPermissaoViewController", sender: self)
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_NovaPermissaoViewController" {
            guard let destinationViewController = segue.destination as? NovaPermissaoViewController else {
                return
            }
            guard let selectedUserPermissions = self.selectedUserPermissions else {
                return
            }
            destinationViewController.currentUserPermission = selectedUserPermissions
        }
    }
}

extension TrusteesViewController : barButtonItemDelegate {
    func onRefreshTap() {
        makeRequestListUsers()
    }
}
