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

protocol performeSegueDelegate {
    func goToNovaPermisao(userACLpair: item)
}

class RelacoesCollectionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tabBarContainer: UIView!
    
    lazy var tabBar: MDCTabBar = {
        let tabBar = MDCTabBar(frame: tabBarContainer.bounds)
        tabBar.delegate = self
        MDCTabBarColorThemer.applySemanticColorScheme(globalColorScheme(), toTabs: tabBar)
        tabBar.itemAppearance = .titles
        tabBar.alignment = .center
        tabBar.tintColor = .black
        tabBar.items = [UITabBarItem(title: "TRUSTEES", image: nil, tag:0),
                        UITabBarItem(title: "TRUSTERS", image: nil, tag:0)]
        return tabBar
    }()
    
    var viewControllertrusters: TrusteesViewController?
    var viewControllerTrustees: TrusteesViewController?
    var selectedUserPermissions: item?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Relação"
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        tabBarContainer.addSubview(tabBar)
        
        viewControllerTrustees = TrusteesViewController()
        viewControllerTrustees!.segueDelegate = self
        viewControllerTrustees!.isTrustees = true
        
        viewControllertrusters = TrusteesViewController()
        viewControllertrusters!.segueDelegate = self
        viewControllertrusters!.isTrustees = false

        
        add(viewControllerTrustees!, frame: CGRect(x: scrollView.bounds.origin.x, y: scrollView.bounds.origin.y, width: scrollView.bounds.width, height: scrollView.bounds.height))
        
        let windowWidth = UIScreen.main.bounds.width
        add(viewControllertrusters!, frame: CGRect(x: windowWidth, y: scrollView.bounds.origin.y, width: scrollView.bounds.width, height: scrollView.bounds.height))
        
        setUpBarButtonItens()
    }
    
    func setUpBarButtonItens() {
        let refreshButton = UIButton(type: .custom)
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(RelacoesCollectionViewController.didTapAddRefresh), for: .touchUpInside)
        let refreshBarItem = UIBarButtonItem(customView: refreshButton)
        
//        let adduserButton = UIButton(type: .custom)
//        adduserButton.setImage(UIImage(named: "addUser"), for: .normal)
//        adduserButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        adduserButton.addTarget(self, action: #selector(RelacoesCollectionViewController.didTapAdd), for: .touchUpInside)
//        let addUserBarItem = UIBarButtonItem(customView: adduserButton)
        
//        self.navigationItem.setRightBarButtonItems([addUserBarItem, refreshBarItem], animated: true)
        self.navigationItem.setRightBarButtonItems([refreshBarItem], animated: true)

    }
    
//    @objc func didTapAdd() {
//        performSegue(withIdentifier: "to_CriarUsuarioViewController", sender: self)
//    }
    
    @objc func didTapAddRefresh() {
        guard let index = tabBar.items.firstIndex(of: tabBar.selectedItem!) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        //Trusttes
        if index == 0 {
            print("O Index 0")
            viewControllerTrustees?.onRefreshTap()
        }
        else {
            print("O Index 1")
            viewControllerTrustees?.onRefreshTap()

        }
    }
}

extension RelacoesCollectionViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items.firstIndex(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        if index == 0 {
            print("Index 0")
        }
        else {
            print("Index 1")
        }
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.bounds.width, y: 0),
                                    animated: true)
    }
}

extension RelacoesCollectionViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        scrollView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        scrollView.removeFromSuperview()
        removeFromParent()
    }
}

extension RelacoesCollectionViewController: performeSegueDelegate {
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
    
    func goToNovaPermisao(userACLpair: item) {
        self.selectedUserPermissions = userACLpair
        performSegue(withIdentifier: "to_NovaPermissaoViewController", sender: self)
    }
}
