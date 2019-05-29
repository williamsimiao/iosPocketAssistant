//
//  TrocarSenhaViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 28/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class TrocarSenhaViewController: UIViewController {

    @IBOutlet weak var newPwdTextField: MDCTextField!
    var newPwdTextFieldController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPwdTextFieldController = MDCTextInputControllerOutlined(textInput: newPwdTextField)
    }
    @IBAction func didTapChangePwd(_ sender: Any) {
        let networkmanager = NetworkManager()
        let newPwd = newPwdTextField.text!
        let tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
        networkmanager.runChangePwd(token: tokenString!, newPwd: newPwd) { (error) in
            if let error = error {
                print(error)
            }
            else {
                DispatchQueue.main.async {
                    let actionComplitionHandler: MDCActionHandler = {_ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    let alertController = MDCAlertController(title: "Senha alterada", message: "Senha alterada com sucesso")
                    let action = MDCAlertAction(title: "OK", handler: actionComplitionHandler)
                    alertController.addAction(action)
                    self.present(alertController, animated:true, completion:nil)
                }
            }
        }
    }
}
