//
//  ViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var otpTextField: MDCTextField!
    @IBOutlet weak var autenticarButton: MDCButton!
    
    var tokenHasExpired = false
    let networkManager = NetworkManager()

    //TODO: Add text field controllers
    var usernameTextFieldController: MDCTextInputControllerOutlined?
    var passwordTextFieldController: MDCTextInputControllerOutlined?
    var otpTextFieldController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo Pocket"

        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
        scrollView.addGestureRecognizer(tapGestureRecognizer)

        autenticarButton.applyContainedTheme(withScheme: globalContainerScheme())
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        otpTextField.delegate = self
        registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tokenHasExpired {
            let alertController = MDCAlertController(title: "Token expirou", message: "Faça o login novamente")
            let action = MDCAlertAction(title: "OK", handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated:true, completion:nil)
        }
    }
    
    // MARK: - Gesture Handling
    
    @objc func didTapTouch(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Action Handling
    func validateTextInput(text: String?) throws {
        if text == nil {
            throw inputError.stringNil
        }
        //TODO check more cases
    }
    
    func validateAuth() -> Bool {
        do {
            try validateTextInput(text: usernameTextField.text)
            try validateTextInput(text: passwordTextField.text)
        } catch {
            let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    @IBAction func didTapAutenticar(_ sender: Any) {
//        if validateAuth() == false {
//            return
//        }
//        let username = usernameTextField.text!
//        let password = passwordTextField.text!
//        networkManager.runAuth(usr: username, pwd: password) { (response, error) in
//            if let error = error {
//                print(error)
//            }
//            if let response = response {
//                let tokenSaved: Bool = KeychainWrapper.standard.set(response.token, forKey: "TOKEN")
//                let usrSaved: Bool = KeychainWrapper.standard.set(username, forKey: "usr")
//                let pwdSaved: Bool = KeychainWrapper.standard.set(password, forKey: "pwd")
//                if !(tokenSaved && usrSaved && pwdSaved) {
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "to_second", sender: self)
//                }
//            }
//        }
        self.performSegue(withIdentifier: "to_second", sender: self)

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
extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case passwordTextField:
            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case otpTextField:
            otpTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
        return true
    }
    
    func checkForValidPassword(_ textField: UITextField) {
        if (textField == passwordTextField &&
            passwordTextField.text != nil &&
            passwordTextField.text!.count < 8) {
            passwordTextFieldController!.setErrorText("Senha muito curta",
                                                      errorAccessibilityValue: nil)
        }
    }
    
    //Validation after press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkForValidPassword(textField)

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
