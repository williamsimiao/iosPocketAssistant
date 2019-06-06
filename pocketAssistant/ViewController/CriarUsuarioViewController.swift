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
    
    let newUserDefaultACL = 6
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
            try validateTextInput(text: confirmPasswordTextField.text)
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
