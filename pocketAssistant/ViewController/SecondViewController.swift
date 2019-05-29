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
        self.title = "Dinâmo Pocket 2"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
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
    @IBAction func didTapMudarSenha(_ sender: Any) {
        self.performSegue(withIdentifier: "to_TrocarSenhaViewController", sender: self)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "to_objetos" {
            guard let objetosViewController = segue.destination as? ObjetosViewController else {
                return
            }
            objetosViewController.tokenString = self.tokenString
            objetosViewController.networkManager = self.networkManager
            objetosViewController.objIdArray = self.objIdArray
        }
    }
}
