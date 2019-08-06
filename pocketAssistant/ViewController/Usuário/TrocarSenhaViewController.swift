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
    var tokenString: String?
    let pwdMinimumLength = 8
    var newPwdTextFieldController: MDCTextInputControllerOutlined?
    var pwdConfirmationTextFieldController: MDCTextInputControllerOutlined?
    var newPwdLayout: textLayout?
    var pwdConfirmationLayout: textLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Trocar senha"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")

        setUpViews()
        registerKeyboardNotifications()
    }
    
    func setUpViews() {
        atualizarSenhaButton.applyContainedTheme(withScheme: globalContainerScheme())
        
        newPwdTextFieldController = MDCTextInputControllerOutlined(textInput: newPwdTextField)
        pwdConfirmationTextFieldController = MDCTextInputControllerOutlined(textInput: pwdConfirmationTextField)
        
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: newPwdTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: pwdConfirmationTextFieldController!)
        
        newPwdLayout = textLayout(textField: newPwdTextField, controller: newPwdTextFieldController!)
        pwdConfirmationLayout = textLayout(textField: pwdConfirmationTextField, controller: pwdConfirmationTextFieldController!)
        
        newPwdTextField.delegate = self
        pwdConfirmationTextField.delegate = self
        
        newPwdTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        pwdConfirmationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapChangePwd(_ sender: Any) {
    
        guard  AppUtil.fieldsAreValid([newPwdLayout!, pwdConfirmationLayout!]) else {
            return
        }
        
        guard AppUtil.validPwd(newPwdLayout!) else {
            return
        }
        
        guard AppUtil.validPwdConfirmation(newPwdLayout!, pwdConfirmationLayout!) else {
            return
        }
        
        changePwdRequest()
    }
    
    func changePwdRequest() {
        let newPwd = newPwdTextField.text!

        networkmanager.runChangePwd(myDelegate: self, token: tokenString!, newPwd: newPwd) { (errorResponse) in
            if let errorResponse = errorResponse {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
                let snackBar = MDCSnackbarMessage()
                snackBar.text = message
                MDCSnackbarManager.show(snackBar)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case newPwdTextField:
            pwdConfirmationTextField.becomeFirstResponder()
        case pwdConfirmationTextField:
            pwdConfirmationTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == newPwdTextField {
            let _ = AppUtil.validPwd(newPwdLayout!)
        }
        else if textField == pwdConfirmationTextField {
            let _ = AppUtil.validPwdConfirmation(newPwdLayout!, pwdConfirmationLayout!)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case newPwdTextField:
            newPwdTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case pwdConfirmationTextField:
            pwdConfirmationTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
}

extension TrocarSenhaViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("AQUIIIIII")
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            print("Olha o IP \(challenge.protectionSpace.host)")
            let myHost = "10.61.53.209"
            if(challenge.protectionSpace.host == myHost) {
                print("LALA")
                let secTrust = challenge.protectionSpace.serverTrust
                let credential = URLCredential(trust: secTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }
    }
}
