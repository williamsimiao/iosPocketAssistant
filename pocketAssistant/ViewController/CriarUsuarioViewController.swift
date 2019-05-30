//
//  CriarUsuarioViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 28/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class CriarUsuarioViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var aclTextField: MDCTextField!
    @IBOutlet weak var criarUsuarioButton: MDCButton!
    
    var usernameTextFieldController: MDCTextInputControllerOutlined?
    var passwordTextFieldController: MDCTextInputControllerOutlined?
    var aclTextFieldController: MDCTextInputControllerOutlined?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar usuário"

        criarUsuarioButton.applyContainedTheme(withScheme: globalContainerScheme())
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        aclTextFieldController = MDCTextInputControllerOutlined(textInput: aclTextField)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        registerKeyboardNotifications()
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func validateTextInput(text: String?) throws {
        if text == nil {
            throw inputError.stringNil
        }
        //TODO check more cases
    }
    
    func validateFields() -> Bool {
        do {
            try validateTextInput(text: usernameTextField.text)
            try validateTextInput(text: passwordTextField.text)
            try validateTextInput(text: aclTextField.text)
        } catch {
            let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
            return false
        }
        return true
    }
    @IBAction func didTapCriar(_ sender: Any) {
        if validateFields() == false {
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let acl = Int(aclTextField.text!)
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            //TODO: mandar para login
            return
        }
        
        NetworkManager().runCreateUsr(token: token, usr: username, pwd: password, acl: acl!) { (error) in
            if let error = error {
                print(error)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Usuário criado com sucesso"
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
