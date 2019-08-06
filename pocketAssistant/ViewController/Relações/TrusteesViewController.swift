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

protocol barButtonItemDelegate {
    func didTapRefresh()
    func didTapAdd()
}

class TrusteesViewController: UIViewController {
    
    var itemArray: [item]?
    var collectionView: UICollectionView?
    var isTrustees: Bool?
    var segueDelegate: performeSegueDelegate?

    let noContentLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = MDCTypography.titleFont()
        lbl.alpha = MDCTypography.titleFontOpacity()
        lbl.text = "Nenhum usuário listado"
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView!.register(RelacaoCollectionViewCell.self, forCellWithReuseIdentifier: RelacaoCollectionViewCell.identifier)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.view.addSubview(collectionView!)
        self.view.addSubview(noContentLabel)
        collectionView?.backgroundColor = .white
        setupViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeRequestListUsrTrust()
    }
    
    func setupViews() {
        noContentLabel.textAlignment = .center
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noContentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noContentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
    }
    
    func makeRequestListUsrTrust() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let usrName = KeychainWrapper.standard.string(forKey: "USR_NAME") else {
            return
        }
        guard let isTrustees = self.isTrustees else {
            return
        }
        let op = isTrustees ? 2 : 1
//        NetworkManager().runListUsrsTrust(token: token, op: op, usr: usrName) { (response, errorResponse) in
//            if let errorResponse = errorResponse {
//                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
//                let snackBar = MDCSnackbarMessage()
//                snackBar.text = message
//                MDCSnackbarManager.show(snackBar)
//            }
//            if let response = response {
//                self.itemArray = response.trust
//                DispatchQueue.main.async {
//                    self.collectionView!.reloadData()
//                }
//            }
//        }
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
        guard let rowCount = itemArray?.count else {
            self.noContentLabel.isHidden = false
            return 0
        }
        if(rowCount == 0) {
            self.noContentLabel.isHidden = false
        }
        else {
            self.noContentLabel.isHidden = true
        }
        
        return rowCount
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
        segueDelegate?.goToNovaPermisao(userACLpair: userPermission)
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TrusteesViewController : barButtonItemDelegate {
    
    func didTapRefresh() {
        makeRequestListUsrTrust()
    }
    
    func didTapAdd() {
        segueDelegate?.gotoUserSelection()
    }
}
