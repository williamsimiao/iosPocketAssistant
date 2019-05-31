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
    
    let headerViewController = DrawerHeaderViewController()
    let contentViewController = DrawerContentWithScrollViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.backgroundColor

        bottomAppBar.isFloatingButtonHidden = true
        let barButtonLeadingItem = UIBarButtonItem()
        let menuImage = UIImage(named:"baseline_menu_black_24pt_")?.withRenderingMode(.alwaysTemplate)
        barButtonLeadingItem.image = menuImage
        barButtonLeadingItem.target = self
        barButtonLeadingItem.action = #selector(presentNavigationDrawer)
        bottomAppBar.leadingBarButtonItems = [ barButtonLeadingItem ]
        
        let barButtonTrailingItem = UIBarButtonItem()
        let userImage = UIImage(named:"baseline_person_black_24pt_")?.withRenderingMode(.alwaysTemplate)
        barButtonTrailingItem.image = userImage
        barButtonTrailingItem.target = self
        barButtonTrailingItem.action = #selector(presentNavigationDrawer)
        bottomAppBar.trailingBarButtonItems = [ barButtonTrailingItem ]
        
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
        bottomDrawerViewController.headerViewController = headerViewController
        bottomDrawerViewController.trackingScrollView = contentViewController.collectionView
        MDCBottomDrawerColorThemer.applySemanticColorScheme(colorScheme,
                                                            toBottomDrawer: bottomDrawerViewController)
        present(bottomDrawerViewController, animated: true, completion: nil)
    }
    
}

class DrawerContentWithScrollViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource {
    let listObjetosInfo = DrawerCellinfo(title: "Listar Objetos")
    let outraCoisaInfo = DrawerCellinfo(title: "Outra coisa")
    var drawerItens: [DrawerCellinfo]!
    
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
        drawerItens = [listObjetosInfo, outraCoisaInfo]
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                      height: self.view.bounds.height)
        collectionView.backgroundColor = .orange
        collectionView.register(DrawerCell.self, forCellWithReuseIdentifier: DrawerCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 34)
        self.view.addSubview(collectionView)
        
//        if #available(iOS 11.0, *) {
//            NSLayoutConstraint.activate([
////                collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
////                collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
////                collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//                collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
//                ])
//        } else {
//            // Fallback on earlier versions
//        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = self.view.frame.size.width
        layout.itemSize = CGSize(width: width, height: 50.0)
        self.preferredContentSize = CGSize(width: view.bounds.width,
                                           height: layout.collectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = drawerItens.count
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerCell.identifier, for: indexPath) as! DrawerCell
        cell.titleLabel.text = drawerItens[indexPath.row].title
        cell.backgroundColor = .white
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


class DrawerHeaderViewController: UIViewController, MDCBottomDrawerHeader {
    weak var titleLabel: UILabel!
    init() {
        super.init(nibName: nil, bundle: nil)
        commomInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commomInit()
    }
    func commomInit() {
        view.backgroundColor = .white
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = MDCTypography.body2Font()
        titleLabel.alpha = MDCTypography.body2FontOpacity()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            self.view.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ])
        self.titleLabel = titleLabel
        self.titleLabel.text = "Header"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

