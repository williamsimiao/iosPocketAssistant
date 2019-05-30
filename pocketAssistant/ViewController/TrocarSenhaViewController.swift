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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newPwdTextField: MDCTextField!
    @IBOutlet weak var atualizarSenhaButton: MDCButton!
    
    var newPwdTextFieldController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trocar senha"

        atualizarSenhaButton.applyContainedTheme(withScheme: globalContainerScheme())
        newPwdTextFieldController = MDCTextInputControllerOutlined(textInput: newPwdTextField)
        
        newPwdTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        registerKeyboardNotifications()
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
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
                    self.navigationController?.popViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Senha alterada com sucesso"
                    MDCSnackbarManager.show(message)
                    
//                    let actionComplitionHandler: MDCActionHandler = {_ in
//                        self.navigationController?.popViewController(animated: true)
//                    }
//
//                    let alertController = MDCAlertController(title: "Senha alterada", message: "Senha alterada com sucesso")
//                    let action = MDCAlertAction(title: "OK", handler: actionComplitionHandler)
//                    alertController.addAction(action)
//                    self.present(alertController, animated:true, completion:nil)
                }
            }
        }
    }
    
    // MARK: - Keyboard Handling
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillChangeFrameNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0);
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero;
    }

}

extension TrocarSenhaViewController: UITextFieldDelegate {
    
}
