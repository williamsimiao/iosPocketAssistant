//
//  SecondViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class SecondViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var tokenString: String?
    let networkManager = NetworkManager()
    var objIdArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ações"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        let navController = self.navigationController as! CustomNavigationController
        navController.contentViewController.transitionDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "to_ObjetosViewController" {
            guard let objetosViewController = segue.destination as? ObjetosViewController else {
                return
            }
            objetosViewController.tokenString = self.tokenString
            objetosViewController.networkManager = self.networkManager
            objetosViewController.objIdArray = self.objIdArray
        }
    }
}

extension SecondViewController: drawerTransitionDelegate {
    func makeTransition(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "to_ObjetosViewController", sender: self)
            case 1:
                print("Relacoes")
            default:
                print("NADA")
            }
        case 1:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "to_CriarUsuarioViewController", sender: self)
                
            default:
                print("NADA")
            }
        default:
            print("NOTHING")
        }
    }
}
