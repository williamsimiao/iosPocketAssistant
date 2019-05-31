//
//  CustomNavigationController.swift
//  pocketAssistant
//
//  Created by William Simiao on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class CustomNavigationController: UINavigationController {

    @objc var colorScheme = MDCSemanticColorScheme()
    let bottomAppBar = MDCBottomAppBarView()
    
//    let headerViewController = DrawerHeaderViewController()
    let contentViewController = DrawerContentWithScrollViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.backgroundColor
        contentViewController.colorScheme = colorScheme

        bottomAppBar.isFloatingButtonHidden = true
        let barButtonLeadingItem = UIBarButtonItem()
        let menuImage = UIImage(named:"baseline_menu_black_24pt_")?.withRenderingMode(.alwaysTemplate)
        barButtonLeadingItem.image = menuImage
        barButtonLeadingItem.target = self
        barButtonLeadingItem.action = #selector(presentNavigationDrawer)
        bottomAppBar.leadingBarButtonItems = [ barButtonLeadingItem ]
        MDCBottomAppBarColorThemer.applySurfaceVariant(withSemanticColorScheme: colorScheme,
                                                       to: bottomAppBar)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeOnBottomAppBar))
        bottomAppBar.addGestureRecognizer(swipeGestureRecognizer)
        view.addSubview(bottomAppBar)
    }
    @objc func didSwipeOnBottomAppBar(sender: UIGestureRecognizer) {
        
    }
    
    private func layoutBottomAppBar() {
        let size = bottomAppBar.sizeThatFits(view.bounds.size)
        var bottomBarViewFrame = CGRect(x: 0,
                                        y: view.bounds.size.height - size.height,
                                        width: size.width,
                                        height: size.height)
        if #available(iOS 11.0, *) {
            bottomBarViewFrame.size.height += view.safeAreaInsets.bottom
            bottomBarViewFrame.origin.y -= view.safeAreaInsets.bottom
        }
        bottomAppBar.frame = bottomBarViewFrame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutBottomAppBar()
    }
    
    @objc func presentNavigationDrawer() {
        let bottomDrawerViewController = MDCBottomDrawerViewController()
        bottomDrawerViewController.maximumInitialDrawerHeight = 400;
        bottomDrawerViewController.contentViewController = contentViewController
//        bottomDrawerViewController.headerViewController = headerViewController
        bottomDrawerViewController.trackingScrollView = contentViewController.collectionView
        MDCBottomDrawerColorThemer.applySemanticColorScheme(colorScheme,
                                                            toBottomDrawer: bottomDrawerViewController)
        present(bottomDrawerViewController, animated: true, completion: nil)
    }
    
}

class DrawerContentWithScrollViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @objc var colorScheme: MDCSemanticColorScheme!
    let collectionView: UICollectionView
    let layout = UICollectionViewFlowLayout()
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                      height: self.view.bounds.height)
        collectionView.register(DrawerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let s = self.view.frame.size.width / 3
        layout.itemSize = CGSize(width: s, height: s)
        self.preferredContentSize = CGSize(width: view.bounds.width,
                                           height: layout.collectionViewContentSize.height)
    }
    
    // MARK: - UICollectionView protocols
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let val = drawerTabs.allCases.count
        return val
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrawerCell
        let theText = drawerTabs.allCases[indexPath.row].rawValue
        cell.titleLabel.text = theText
        cell.backgroundColor = .orange
//        let colorPick = indexPath.row % 2 == 0
//        print(indexPath.item)
//        cell.backgroundColor = colorPick ? colorScheme.surfaceColor : colorScheme.primaryColorVariant
        return cell
    }
    
    func didTapListarObjetos() {
        self.performSegue(withIdentifier: "to_ObjetosViewController", sender: self)
    }
    
    func didTapCriarUsuario() {
        self.performSegue(withIdentifier: "to_CriarUsuarioViewController", sender: self)
    }
    func didTapMudarSenha() {
        self.performSegue(withIdentifier: "to_TrocarSenhaViewController", sender: self)
    }
    
    func didTapClose() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        let actionComplitionHandler: MDCActionHandler = {_ in
            NetworkManager().runClose(token: token) { (error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("Sessão encerrada")
                    DispatchQueue.main.async {
                        let stor = UIStoryboard.init(name: "Main", bundle: nil)
                        let mainViewController = stor.instantiateViewController(withIdentifier: "MainViewController")
                        self.present(mainViewController, animated: true, completion: { () in
                            print("Done")
                        })
                    }
                }
            }
        }
        
        let alertController = MDCAlertController(title: "Encerrar sessão", message: "Deseja mesmo encerrar a sessão ?")
        alertController.addAction(MDCAlertAction(title: "Sim", emphasis: .medium, handler: actionComplitionHandler))
        alertController.addAction(MDCAlertAction(title: "Cancelar", emphasis: .high, handler: nil))
        self.present(alertController, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DrawerCell
        switch cell.drawerItem {
            case .listarObjetos:
                didTapListarObjetos()
            case .criarUsuario:
                didTapCriarUsuario()
            case .mudarSenha:
                didTapMudarSenha()
            case .fecharSessao:
                didTapClose()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

class DrawerHeaderViewController: UIViewController, MDCBottomDrawerHeader {
    
}

