//
//  PerfilViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 03/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class PerfilViewController: UIViewController {
    @IBOutlet weak var mudarSenhaButton: MDCButton!
    @IBOutlet weak var fecharSessaoButton: MDCButton!
    @IBOutlet weak var tabBarContainer: UIView!
    lazy var tabBar: MDCTabBar = {
        let tabBar = MDCTabBar()
        tabBar.delegate = self
        let anyImage = UIImage(named: "baseline_menu_black_24pt_")
        
        MDCTabBarColorThemer.applySemanticColorScheme(globalColorScheme(), toTabs: tabBar)
        tabBar.itemAppearance = .titledImages
        tabBar.items = [UITabBarItem(title: "Atributos", image: anyImage, tag:0),
                        UITabBarItem(title: "Permissões", image: anyImage, tag:0),
                        UITabBarItem(title: "Alterar senha", image: anyImage, tag:0)]
        tabBar.items[1].badgeValue = "1"
        return tabBar
    }()
    
    var tokenString: String?
    let networkManager = NetworkManager()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
//        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//        tabBar.sizeToFit()
//        tabBarContainer.addSubview(tabBar)
        let atabBar = MDCTabBar(frame: view.bounds)
        atabBar.items = [
            UITabBarItem(title: "Recents", image: UIImage(named: "baseline_menu_black_24pt_"), tag: 0),
            UITabBarItem(title: "Favorites", image: UIImage(named: "baseline_menu_black_24pt_"), tag: 0),
        ]
        MDCTabBarColorThemer.applySemanticColorScheme(globalColorScheme(), toTabs: atabBar)
        atabBar.itemAppearance = .titledImages
        atabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        atabBar.sizeToFit()
        view.addSubview(atabBar)
        
        mudarSenhaButton.applyContainedTheme(withScheme: globalContainerScheme())
        fecharSessaoButton.applyContainedTheme(withScheme: globalContainerScheme())
        
        
        
        let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = UIColor(red: 170, green: 170, blue: 170)
        view.addSubview(barView)
    }

    @IBAction func didTapTrocarSenha(_ sender: Any) {
        self.performSegue(withIdentifier: "to_TrocarSenhaViewController", sender: self)
    }
    
    @IBAction func didTapFecharSessao(_ sender: Any) {
        guard let token = self.tokenString else {
            print("No token")
            return
        }
        let actionComplitionHandler: MDCActionHandler = {_ in
            self.networkManager.runClose(token: token) { (error) in
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
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PerfilViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items.index(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
//        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.bounds.width, y: 0),
//                                    animated: true)
    }
}
