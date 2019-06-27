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

class MainViewController: mainViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")

        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        // To make the activity indicator appear:
        activityIndicator.startAnimating()
        
        //HIDE IT ALL
        usernameTextField.isHidden = true
        passwordTextField.isHidden = true
        otpTextField.isHidden = true
        autenticarButton.isHidden = true
        
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)
        
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: usernameTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: passwordTextFieldController!)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: otpTextFieldController!)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)

        autenticarButton.applyContainedTheme(withScheme: globalContainerScheme())
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        otpTextField.delegate = self
        registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tokenString != nil {
            probeRequest()
        }
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
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
        if validateAuth() == false {
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        networkManager.runAuth(usr: username, pwd: password) { (response, error) in
            if let error = error {
                let message = AppUtil.handleAPIError(viewController: self, error: error)
            }
            if let response = response {
                let tokenSaved: Bool = KeychainWrapper.standard.set(response.token, forKey: "TOKEN")
                let userNameSaved: Bool = KeychainWrapper.standard.set(username, forKey: "USR_NAME")
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
        
        let networkManager = NetworkManager()
        guard let token = tokenString else {
            //then go to MainViewController without setting "tokenHasExpired" to true
            //because thre is no token yet or the session has been properly closed
            showLoginFields()
            return
        }
        
        networkManager.runProbeSynchronous(token: token) { (response, error) in
            if let error = error {
                print(error)
//                let alertController = MDCAlertController(title: "Token expirou", message: "Faça o login novamente")
//                let action = MDCAlertAction(title: "OK", handler: nil)
//                alertController.addAction(action)
//                alertController.applyTheme(withScheme: globalContainerScheme())
//                self.present(alertController, animated:true, completion:nil)
            }
            else if let response = response {
                print(response.probe_str)
                self.performSegue(withIdentifier: "to_second", sender: self)
            }
            self.showLoginFields()
        }
    }
    
    func showLoginFields() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
        //SHOW IT ALL
        self.usernameTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.otpTextField.isHidden = false
        self.autenticarButton.isHidden = false
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
