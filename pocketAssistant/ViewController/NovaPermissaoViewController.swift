//
//  NovaPermissaoViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class NovaPermissaoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: MDCTextField!
    @IBOutlet weak var lerSwitch: UISwitch!
    @IBOutlet weak var criarSwitch: UISwitch!
    @IBOutlet weak var removerSwitch: UISwitch!
    @IBOutlet weak var atualizarSwitch: UISwitch!
    
    var usernameTextFieldController: MDCTextInputControllerOutlined?

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)

        
        usernameTextField.delegate = self
        registerKeyboardNotifications()

    }
    
    func makeRequest() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let username = usernameTextField.text else {
            return
        }
        //TODO: Mudar, montando a partir dos valores dos switches
        let acl = 15
        NetworkManager().runUpdateAcl(token: token, acl: acl, usr: username) { (error) in
            if let error = error {
                print(error)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Permissão alterada com sucesso"
                    MDCSnackbarManager.show(message)
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

// MARK: - UITextFieldDelegate
extension NovaPermissaoViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        usernameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        return true
    }
    
    //Validation after press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if usernameTextField.text == nil || usernameTextField.text == "" {
            usernameTextFieldController?.setErrorText("Campo obrigatório", errorAccessibilityValue: nil)
        }
//        return true
        return false
    }
    
    //Validation while typing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        return true
    }
}

