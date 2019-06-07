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

protocol barButtonItemDelegate {
    func onRefreshTap()
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
        
        let trustees = TrusteesViewController()
        let trusters = TrustersViewController()
        
        add(trustees)
//        add(trusters)
        
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
        if index == 0 {
            
        }
        else {
            
        }
    }
}

extension RelacoesCollectionViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items.firstIndex(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.bounds.width, y: 0),
                                    animated: true)
    }
}

extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

//extension RelacoesCollectionViewController {
//    func setUpSrollView() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//
//    }
//}
