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

class RelacoesCollectionViewController: UIViewController {

    @IBOutlet weak var tabBarContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var tokenString: String?
    var itemArray: [item]?
    var selectedUserName: String?
    lazy var tabBar: MDCTabBar = {
        let tabBar = MDCTabBar(frame: tabBarContainer.bounds)
        tabBar.delegate = self
        MDCTabBarColorThemer.applySemanticColorScheme(globalColorScheme(), toTabs: tabBar)
        tabBar.itemAppearance = .titles
        tabBar.tintColor = .black
        tabBar.items = [UITabBarItem(title: "TRUSTER", image: nil, tag:0),
                        UITabBarItem(title: "TRUSTEES", image: nil, tag:0)]
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Relação"
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        tabBarContainer.addSubview(tabBar)

        
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
extension RelacoesCollectionViewController: UICollectionViewDelegate,
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
        cell.titleLabel.text = data[indexPath.row].usr
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension RelacoesCollectionViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items.firstIndex(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
        //        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.bounds.width, y: 0),
        //                                    animated: true)
    }
}
