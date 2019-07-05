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
    
    var tokenString: String?
    let networkManager = NetworkManager()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Usuário"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
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
                    let message = AppUtil.handleAPIError(viewController: self, mErrorBody: error)
                    let snackBar = MDCSnackbarMessage()
                    snackBar.text = message
                    MDCSnackbarManager.show(snackBar)
                }
                else {
                    print("Deu certo")
                    AppUtil.removeTokenFromSecureLocation()
                    AppUtil.goToLoginScreen(sourceViewController: self)
                }
            }
        }
        
        let alertController = MDCAlertController(title: "Encerrar sessão", message: "Deseja mesmo encerrar a sessão ?")
        alertController.addAction(MDCAlertAction(title: "Sim", emphasis: .medium, handler: actionComplitionHandler))
        alertController.addAction(MDCAlertAction(title: "Cancelar", emphasis: .high, handler: nil))
        self.present(alertController, animated:true, completion:nil)
    }
}
