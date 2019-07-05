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
    @IBOutlet weak var confirmPasswordTextField: MDCTextField!
    @IBOutlet weak var criarUsuarioButton: MDCButton!
    
    let newUserDefaultACL = 80
    //1 0 1 0 0 0 0
    //#define ACL_USR_CREATE          (ACL_OBJ_DEL << 4) // create usr
    //#define ACL_USR_LIST            (ACL_OBJ_DEL << 6) // can usr get user-list?

    var usernameTextFieldController: MDCTextInputControllerOutlined?
    var passwordTextFieldController: MDCTextInputControllerOutlined?
    var confirmPasswordTextFieldController: MDCTextInputControllerOutlined?
    
    var usernameTextLayout: textLayout?
    var passwordTextLayout: textLayout?
    var confirmationTextLayout: textLayout?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar usuário"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        confirmPasswordTextFieldController =
            MDCTextInputControllerOutlined(textInput: confirmPasswordTextField)
        
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: usernameTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: passwordTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: confirmPasswordTextFieldController!)
        
        usernameTextLayout = textLayout(textField: usernameTextField, controller: usernameTextFieldController!)
        passwordTextLayout = textLayout(textField: passwordTextField, controller: passwordTextFieldController!)
        confirmationTextLayout = textLayout(textField: confirmPasswordTextField, controller: confirmPasswordTextFieldController!)

        criarUsuarioButton.applyContainedTheme(withScheme: globalContainerScheme())

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        registerKeyboardNotifications()
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapCriar(_ sender: Any) {
        guard AppUtil.fieldsAreValid([usernameTextLayout!, passwordTextLayout!, confirmationTextLayout!]) else {
            return
        }
        guard AppUtil.validUsr(usernameTextLayout!) else {
            return
        }
        guard AppUtil.validPwd(passwordTextLayout!) else {
            return
        }
        guard AppUtil.validPwdConfirmation(passwordTextLayout!, confirmationTextLayout!) else {
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            //TODO: mandar para login
            return
        }
        
        NetworkManager().runCreateUsr(token: token, usr: username, pwd: password, acl: newUserDefaultACL) { (errorResponse) in
            if let errorResponse = errorResponse {
                let _ = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Usuário criado com sucesso"
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
extension CriarUsuarioViewController: UITextFieldDelegate {
    
//    //Validation after press return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        let _ = isValidInput(textField)
//        return false
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            let _ = AppUtil.validUsr(usernameTextLayout!)
        }
        else if textField == passwordTextField {
            let _ = AppUtil.validPwd(passwordTextLayout!)
        }
        else if textField == confirmPasswordTextField {
            let _ = AppUtil.validPwdConfirmation(passwordTextLayout!, confirmationTextLayout!)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            usernameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case passwordTextField:
            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
    
    //Validation while typing
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text,
//            let range = Range(range, in: text),
//            textField == passwordTextField else {
//                return true
//        }
//
//        let finishedString = text.replacingCharacters(in: range, with: string)
//        if finishedString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "%@#*!")) != nil {
//            passwordTextFieldController?.setErrorText("Use ap", errorAccessibilityValue: nil)
//        } else {
//            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
//        }
//
//        return true
//    }
}

