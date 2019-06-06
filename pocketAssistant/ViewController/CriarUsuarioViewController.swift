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
    
    //#define ACL_NOP                 (0x00000000)       // "may the Force be with ya'!"
    //#define ACL_OBJ_DEL             (ACL_NOP + 1)      // delete objects
    //#define ACL_OBJ_READ            (ACL_OBJ_DEL << 1) // read obj content
    //#define ACL_OBJ_LIST            (ACL_OBJ_READ)     // list usr objs
    //#define ACL_OBJ_CREATE          (ACL_OBJ_DEL << 2) // create obj
    //#define ACL_OBJ_UPDATE          (ACL_OBJ_DEL << 3) // update obj (hdr and alike)
    
    //#define ACL_OBJ_WRITE           (ACL_OBJ_UPDATE)   // update obj
    //#define ACL_USR_CREATE          (ACL_OBJ_DEL << 4) // create usr
    //#define ACL_USR_DELETE          (ACL_USR_CREATE)   // makes no sense only to create
    //#define ACL_USR_REMOTE_LOG      (ACL_OBJ_DEL << 5) // can usr use remote log/info?
    //#define ACL_USR_LIST            (ACL_OBJ_DEL << 6) // can usr get user-list?
    //#define ACL_SYS_OPERATOR        (ACL_OBJ_DEL << 7) // operate as master (adm mode)
    //#define ACL_SYS_BACKUP          (ACL_OBJ_DEL << 8) // extract full appliance backup
    //#define ACL_SYS_RESTORE         (ACL_SYS_BACKUP)   // restore full appliance backup
    //#define ACL_SYS_UDATE_HSM       (ACL_OBJ_DEL << 9) // firmware and stuff like that
    //#define ACL_NS_AUTHORIZATION    (ACL_OBJ_DEL << 10) // user must be authorized with "m of n"
    //#define ACL_VIRTUAL_X509_AUTH    (ACL_OBJ_DEL << 28) // presence means SA (user must use 2F PKI)
    //#define ACL_VIRTUAL_OTP_AUTH    (ACL_OBJ_DEL << 29) // presence means SA (user must use 2-F OTP)
    //#define ACL_CHANGE_PWD_NEXT_TIME (ACL_OBJ_DEL << 30) // can force usrs to change pwd on next login
    //
    //
    //#define ACL_DEFAULT_OWNER ( ACL_OBJ_DEL | ACL_OBJ_READ | ACL_OBJ_CREATE | \
    //ACL_OBJ_UPDATE |ACL_OBJ_WRITE \
    //)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar usuário"

        criarUsuarioButton.applyContainedTheme(withScheme: globalContainerScheme())
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        confirmPasswordTextFieldController =
            MDCTextInputControllerOutlined(textInput: confirmPasswordTextField)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        registerKeyboardNotifications()
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapCriar(_ sender: Any) {
        if  !isValidInput(usernameTextField) ||
            !isValidInput(passwordTextField) ||
            !isValidInput(confirmPasswordTextField) {
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            //TODO: mandar para login
            return
        }
        
        NetworkManager().runCreateUsr(token: token, usr: username, pwd: password, acl: newUserDefaultACL) { (error) in
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

// MARK: - UITextFieldDelegate
extension CriarUsuarioViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case passwordTextField:
            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case confirmPasswordTextField:
            confirmPasswordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
        return true
    }
    
    func checkTextFieldEmpity(_ textField: UITextField) -> Bool {
        return textField.text == nil || textField.text == ""
    }
    
    func isValidInput(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            if checkTextFieldEmpity(usernameTextField) {
                usernameTextFieldController?.setErrorText("Campo Obirgatorio", errorAccessibilityValue: nil)
                return false
            }
            
        case passwordTextField:
            if checkTextFieldEmpity(passwordTextField) {
                passwordTextFieldController?.setErrorText("Campo Obirgatorio", errorAccessibilityValue: nil)
                return false
            }
            else if passwordTextField.text!.count < 8 {
                passwordTextFieldController?.setErrorText("Senha muito curta",
                                                          errorAccessibilityValue: nil)
                return false
            }
        case confirmPasswordTextField:
            if checkTextFieldEmpity(confirmPasswordTextField) {
                confirmPasswordTextFieldController?.setErrorText("Campo Obirgatorio", errorAccessibilityValue: nil)
                return false
            }
            else if confirmPasswordTextField.text != passwordTextField.text {
                confirmPasswordTextFieldController?.setErrorText("Confirmação e senha não conferem", errorAccessibilityValue: nil)
                return false
            }
        default:
            break
        }
        return true
    }
    
    //Validation after press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let _ = isValidInput(textField)
        return false
    }
    
    //Validation while typing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let range = Range(range, in: text),
            textField == passwordTextField else {
                return true
        }
        
        let finishedString = text.replacingCharacters(in: range, with: string)
        if finishedString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "%@#*!")) != nil {
            passwordTextFieldController?.setErrorText("Apenas letras e numeros são permitidas", errorAccessibilityValue: nil)
        } else {
            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        return true
    }
}

