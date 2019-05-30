//
//  CustomNavigationController.swift
//  pocketAssistant
//
//  Created by William Simiao on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class CustomNavigationController: UINavigationController {

    @objc var colorScheme = MDCSemanticColorScheme()
    let bottomAppBar = MDCBottomAppBarView()
    
    let headerViewController = DrawerHeaderViewController()
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
        bottomAppBar.isUserInteractionEnabled = false
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 102
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let colorPick = indexPath.row % 2 == 0
        print(indexPath.item)
        cell.backgroundColor = colorPick ? colorScheme.surfaceColor : colorScheme.primaryColorVariant
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension CustomNavigationController {
    
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Navigation Drawer", "Bottom Drawer Scrollable Content"],
            "primaryDemo": false,
            "presentable": false,
        ]
    }
}

class DrawerHeaderViewController: UIViewController, MDCBottomDrawerHeader {
    
}

