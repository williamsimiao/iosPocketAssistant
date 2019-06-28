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
    @IBOutlet weak var pwdConfirmationTextField: MDCTextField!
    @IBOutlet weak var atualizarSenhaButton: MDCButton!
    
    let networkmanager = NetworkManager()
    let pwdMinimumLength = 8
    var newPwdTextFieldController: MDCTextInputControllerOutlined?
    var pwdConfirmationTextFieldController: MDCTextInputControllerOutlined?
    var newPwdLayout: textLayout?
    var pwdConfirmationLayout: textLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Trocar senha"
        
        atualizarSenhaButton.applyContainedTheme(withScheme: globalContainerScheme())
        newPwdTextFieldController = MDCTextInputControllerOutlined(textInput: newPwdTextField)
        pwdConfirmationTextFieldController = MDCTextInputControllerOutlined(textInput: pwdConfirmationTextField)
        
        newPwdLayout = textLayout(textField: newPwdTextField, controller: newPwdTextFieldController!)
        pwdConfirmationLayout = textLayout(textField: pwdConfirmationTextField, controller: pwdConfirmationTextFieldController!)
        
        newPwdTextField.delegate = self
        pwdConfirmationTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        registerKeyboardNotifications()
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapChangePwd(_ sender: Any) {
        guard AppUtil.fieldsAreValid(textLayoutArray: [newPwdLayout!]) &&
              AppUtil.validPwd(newPwdLayout!) &&
              newPwdTextField.text == pwdConfirmationTextField.text else {
            return
        }
        
        changePwdRequest()
    }
    
    func changePwdRequest() {
        let newPwd = newPwdTextField.text!
        let tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")

        networkmanager.runChangePwd(token: tokenString!, newPwd: newPwd) { (errorResponse) in
            if let errorResponse = errorResponse {
                let _ = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
            }
            else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    let message = MDCSnackbarMessage()
                    message.text = "Senha alterada com sucesso"
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

extension TrocarSenhaViewController: UITextFieldDelegate {
    func clearErrorMenssageOnTextLayout(_ textField: UITextField) {
        switch textField {
        case newPwdTextField:
            newPwdTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case pwdConfirmationTextField:
            pwdConfirmationTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearErrorMenssageOnTextLayout(textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearErrorMenssageOnTextLayout(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == newPwdTextField {
            let _ = AppUtil.validPwd(newPwdLayout!)
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return false
//    }
    
    //Validation while typing
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let textFieldController: MDCTextInputControllerOutlined?
//        if textField != newPwdTextField && textField != pwdConfirmationTextField {
//            return true
//        }
//
//        switch textField {
//        case newPwdTextField:
//            textFieldController = newPwdTextFieldController
//        default:
//            textFieldController = pwdConfirmationTextFieldController
//        }
//
//
//        guard let text = textField.text,
//            let range = Range(range, in: text) else {
//                return true
//        }
//
//        let finishedString = text.replacingCharacters(in: range, with: string)
//        if finishedString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "%@#*!")) != nil {
//            textFieldController?.setErrorText("Apenas letras e numeros são permitidas", errorAccessibilityValue: nil)
//        } else {
//            textFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
//        }
//
//        return true
//    }
    
}
