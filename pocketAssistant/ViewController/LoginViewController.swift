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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var otpTextField: MDCTextField!
    @IBOutlet weak var autenticarButton: MDCButton!
    
    let networkManager = NetworkManager()
    var tokenString: String?
    
    lazy var activityIndicator: MDCActivityIndicator = {
        let aActivityIndicator = MDCActivityIndicator()
        aActivityIndicator.sizeToFit()
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.primaryColor = .black
        MDCActivityIndicatorColorThemer.applySemanticColorScheme(colorScheme, to: aActivityIndicator)

        return aActivityIndicator
    }()

    var usernameTextFieldController: MDCTextInputControllerOutlined?
    var passwordTextFieldController: MDCTextInputControllerOutlined?
    var otpTextFieldController: MDCTextInputControllerOutlined?
    
    var usernameTextLayout: textLayout?
    var passwordTextLayout: textLayout?
    var otpTextLayout: textLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //This null verification is not suitable for viewDidLoad because de Token is
        //modified after the creation
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        if tokenString != nil {
            hideLoginFields()
            probeRequest()
        }
    }
    
    func setUpViews() {
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)
        
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: usernameTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: passwordTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: otpTextFieldController!)
        
        usernameTextLayout = textLayout(textField: usernameTextField, controller: usernameTextFieldController!)
        passwordTextLayout = textLayout(textField: passwordTextField, controller: passwordTextFieldController!)
        otpTextLayout = textLayout(textField: otpTextField, controller: otpTextFieldController!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        autenticarButton.applyContainedTheme(withScheme: globalContainerScheme())
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        otpTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }
    
    func showInvalidTokenDialog() {
        let alertController = MDCAlertController(title: "Credenciais inválidas", message: "Faça o login novamente.")
        alertController.addAction(MDCAlertAction(title: "Ok", emphasis: .high, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated:true, completion:nil)
        }
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapAutenticar(_ sender: Any) {
        guard AppUtil.fieldsAreValid([usernameTextLayout!, passwordTextLayout!]) else {
                return
        }
        guard AppUtil.validPwd(passwordTextLayout!) else  {
            return
        }

        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        networkManager.runAuth(usr: username, pwd: password) { (response, errorResponse) in
            if let errorResponse = errorResponse {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
                
                //Show message(Acesso negado) em snackBar já que o alerta nao vai aparecer
                let snackBar = MDCSnackbarMessage()
                snackBar.text = message
                MDCSnackbarManager.show(snackBar)
            }
            
            if let response = response {
                let tokenSaved : Bool = KeychainWrapper.standard.set(response.token, forKey: "TOKEN")
                let _ : Bool = KeychainWrapper.standard.set(username, forKey: "USR_NAME")
                if !tokenSaved {
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "to_second", sender: self)
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
    
    // MARK: - Requests
    func probeRequest() {
        
        guard let token = tokenString else {
            return
        }
        
        networkManager.runProbeSynchronous(token: token) { (response, errorResponse) in
            if let errorResponse = errorResponse {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
                if message == "Sessão expirou" || message == "Acesso negado" {
                    self.showInvalidTokenDialog()
                }
            }
            else if let _ = response {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "to_second", sender: self)
                }
            }
            self.showLoginFields()
        }
    }
    
    func hideLoginFields() {
        usernameTextField.isHidden = true
        passwordTextField.isHidden = true
        otpTextField.isHidden = true
        autenticarButton.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    
    func showLoginFields() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            //SHOW IT ALL
            self.usernameTextField.isHidden = false
            self.passwordTextField.isHidden = false
            self.otpTextField.isHidden = false
            self.autenticarButton.isHidden = false
        }
    }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            let _ = AppUtil.validPwd(passwordTextLayout!)
        }
    }
    
    
    
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        resetTextFieldError(textField)
//        return true
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        resetTextFieldError(textField)
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
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
    }
}
