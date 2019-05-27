//
//  ViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class MainViewController: UIViewController {
    
    let networkManager = NetworkManager()
    var tokenString: String?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.backgroundColor = .white
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return scrollView
    }()
    
    var appBarViewController = MDCAppBarViewController()

    // Text Fields
    //TODO: Add text fields
    let usernameTextField: MDCTextField = {
        let usernameTextField = MDCTextField()
        usernameTextField.text = "master"
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.clearButtonMode = .unlessEditing
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        return usernameTextField
    }()
    let passwordTextField: MDCTextField = {
        let passwordTextField = MDCTextField()
        passwordTextField.text = "12345678"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    let otpTextField: MDCTextField = {
        let otpTextField = MDCTextField()
        otpTextField.translatesAutoresizingMaskIntoConstraints = false
        return otpTextField
    }()
    
    
    //TODO: Add text field controllers
    let usernameTextFieldController: MDCTextInputControllerOutlined
    let passwordTextFieldController: MDCTextInputControllerOutlined
    let otpTextFieldController: MDCTextInputControllerOutlined

    
    // Buttons
    let autenticarButton: MDCButton = {
        let autenticarButton = MDCButton()
        autenticarButton.translatesAutoresizingMaskIntoConstraints = false
        autenticarButton.setTitle("AUTENTICAR", for: .normal)
        autenticarButton.addTarget(self, action: #selector(didTapNext(sender:)), for: .touchUpInside)
        return autenticarButton
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo Pocket"

        // Set the tracking scroll view.
        self.appBarViewController.headerView.trackingScrollView = self.scrollView
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        self.addChild(self.appBarViewController)
        self.appBarViewController.didMove(toParent: self)
        view.addSubview(self.appBarViewController.view)
        
        // TextFields
        //TODO: Add text fields to scroll view and setup initial state
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(otpTextField)
        usernameTextFieldController.placeholderText = "Usuario"
        usernameTextField.delegate = self
        passwordTextFieldController.placeholderText = "Senha"
        passwordTextField.delegate = self
        otpTextFieldController.placeholderText = "OTP(Opcional)"
        otpTextField.delegate = self
        registerKeyboardNotifications()
        
        // Buttons
        //TODO: Add buttons to the scroll view
        scrollView.addSubview(autenticarButton)
        
        // Constraints
        var constraints = [NSLayoutConstraint]()
        
        // Text Fields
        constraints.append(NSLayoutConstraint(item: usernameTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 150))
        constraints.append(NSLayoutConstraint(item: usernameTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[username]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "username" : usernameTextField]))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: usernameTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[password]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "password" : passwordTextField]))
        //
        constraints.append(NSLayoutConstraint(item: otpTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: otpTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[otp]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "otp" : otpTextField]))
        
        // Buttons
        constraints.append(NSLayoutConstraint(item: autenticarButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: otpTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: autenticarButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[autenticar]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "autenticar" : autenticarButton]))
        
        NSLayoutConstraint.activate(constraints)
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
    
    @objc func didTapNext(sender: Any) {
        if validateAuth() == false {
            return
        }
        networkManager.runAuth(usr: usernameTextField.text!, pwd: passwordTextField.text!) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.tokenString = response.token
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "to_second" {
//            guard let navigationController = segue.destination as? UINavigationController else {
//                return
//            }
            guard let secondViewController = segue.destination as? SecondViewController else {
                return
            }
            guard let token = self.tokenString else {
                print("NO token")
                return
            }
            secondViewController.tokenString = token
            secondViewController.networkManager = self.networkManager
        }
    }
}


// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
    //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // TextField
        if (textField == passwordTextField &&
            passwordTextField.text != nil &&
            passwordTextField.text!.count < 8) {
            passwordTextFieldController.setErrorText("Senha muito curta",
                                                     errorAccessibilityValue: nil)
        }
        
        return false
    }
}

//MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                           willDecelerate decelerate: Bool) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity,
                                                     targetContentOffset: targetContentOffset)
        }
    }

}
