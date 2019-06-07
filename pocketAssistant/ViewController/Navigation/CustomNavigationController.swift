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

protocol drawerTransitionDelegate {
    func makeTransition(indexPath: IndexPath)
}

protocol drawerDismissDelegate {
    func dismissDrawer()
}

class CustomNavigationController: UINavigationController {

    @objc var colorScheme = MDCSemanticColorScheme()
    let bottomAppBar = MDCBottomAppBarView()
    
    let headerViewController = DrawerHeaderViewController()
    let contentViewController = DrawerContentWithScrollViewController()
    var bottomDrawerViewController: MDCBottomDrawerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.backgroundColor
        
//        view.
        
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
        barButtonTrailingItem.action = #selector(presentPerfilController)
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
    
    @objc func presentPerfilController() {
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let mainViewController = stor.instantiateViewController(withIdentifier: "PerfilViewController")
        self.present(mainViewController, animated: true, completion: { () in
            print("Done")
        })
    }
    
    @objc func presentNavigationDrawer() {
        bottomDrawerViewController = MDCBottomDrawerViewController()
        guard let bottomDrawerViewController = self.bottomDrawerViewController else {
            return
        }
        bottomDrawerViewController.maximumInitialDrawerHeight = 400
        contentViewController.dismissDelegate = self
        bottomDrawerViewController.contentViewController = contentViewController
        bottomDrawerViewController.headerViewController = headerViewController
        bottomDrawerViewController.trackingScrollView = contentViewController.collectionView
        MDCBottomDrawerColorThemer.applySemanticColorScheme(colorScheme,
                                                            toBottomDrawer: bottomDrawerViewController)
        present(bottomDrawerViewController, animated: true, completion: nil)
    }
}

extension CustomNavigationController: drawerDismissDelegate {
    func dismissDrawer() {
        bottomDrawerViewController?.dismiss(animated: true, completion: nil)
    }
}
