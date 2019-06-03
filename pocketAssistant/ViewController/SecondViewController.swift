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
    @IBOutlet weak var listarObjetosButton: MDCButton!
    @IBOutlet weak var criarUsuarioButton: MDCButton!
    @IBOutlet weak var mudarSenhaButton: MDCButton!
    @IBOutlet weak var fecharSessaoButton: MDCButton!
    
    var tokenString: String?
    let networkManager = NetworkManager()
    var objIdArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ações"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
        listarObjetosButton.applyContainedTheme(withScheme: globalContainerScheme())
        criarUsuarioButton.applyContainedTheme(withScheme: globalContainerScheme())

    }
    @IBAction func didTapListarObjetos(_ sender: Any) {
        guard let token = self.tokenString else {
            return
        }
        networkManager.runListObjs(token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.objIdArray = response.obj
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "to_ObjetosViewController", sender: self)
                }
            }
        }
    }
    
    @IBAction func didTapCriarUsuario(_ sender: Any) {
        self.performSegue(withIdentifier: "to_CriarUsuarioViewController", sender: self)

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
