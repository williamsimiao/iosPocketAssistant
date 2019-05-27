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
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    //    @IBOutlet weak var usrTextField: MDCTextField!
    //    @IBOutlet weak var pwdTextField: MDCTextField!
    //    @IBOutlet weak var otpTextField: MDCTextField!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.backgroundColor = .white
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return scrollView
    }()
    
    let logoImageView: UIImageView = {
        let baseImage = UIImage.init(named: "ShrineLogo")
        let templatedImage = baseImage?.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(image: templatedImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "SHRINE"
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    // Text Fields
    //TODO: Add text fields
    let usernameTextField: MDCTextField = {
        let usernameTextField = MDCTextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.clearButtonMode = .unlessEditing
        return usernameTextField
    }()
    let passwordTextField: MDCTextField = {
        let passwordTextField = MDCTextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    let otpTextField: MDCTextField = {
        let passwordTextField = MDCTextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    //TODO: Add text field controllers
    let usernameTextFieldController: MDCTextInputControllerOutlined
    let passwordTextFieldController: MDCTextInputControllerOutlined
    let otpTextFieldController: MDCTextInputControllerOutlined

    
    // Buttons
    //TODO: Add buttons
    let cancelButton: MDCButton = {
        let cancelButton = MDCButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchUpInside)
        return cancelButton
    }()
    let nextButton: MDCButton = {
        let nextButton = MDCButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext(sender:)), for: .touchUpInside)
        return nextButton
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
        
        view.tintColor = .black
        scrollView.backgroundColor = .white
        
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
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(logoImageView)
        
        // TextFields
        //TODO: Add text fields to scroll view and setup initial state
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(otpTextField)
        usernameTextFieldController.placeholderText = "Username"
        usernameTextField.delegate = self
        passwordTextFieldController.placeholderText = "Password"
        passwordTextField.delegate = self
        otpTextFieldController.placeholderText = "OTP(Opcional)"
        otpTextField.delegate = self
        registerKeyboardNotifications()
        
        // Buttons
        //TODO: Add buttons to the scroll view
        scrollView.addSubview(nextButton)
        scrollView.addSubview(cancelButton)
        
        // Constraints
        var constraints = [NSLayoutConstraint]()
        if #available(iOS 11.0, *) {
            constraints.append(NSLayoutConstraint(item: logoImageView,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: scrollView.contentLayoutGuide,
                                                  attribute: .top,
                                                  multiplier: 1,
                                                  constant: 49))
        } else {
            // Fallback on earlier versions
        }
        constraints.append(NSLayoutConstraint(item: logoImageView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: logoImageView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 22))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        // Text Fields
        //TODO: Setup text field constraints
        constraints.append(NSLayoutConstraint(item: usernameTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 22))
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
        //TODO: Setup button constraints
        constraints.append(NSLayoutConstraint(item: cancelButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: cancelButton,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: nextButton,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:[cancel]-[next]-|",
                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                           metrics: nil,
                                           views: [ "cancel" : cancelButton, "next" : nextButton]))
        if #available(iOS 11.0, *) {
            constraints.append(NSLayoutConstraint(item: nextButton,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: scrollView.contentLayoutGuide,
                                                  attribute: .bottomMargin,
                                                  multiplier: 1,
                                                  constant: -20))
        } else {
            // Fallback on earlier versions
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Gesture Handling
    
    @objc func didTapTouch(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Action Handling
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
    
    @objc func didTapCancel(sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // TextField
        if (textField == passwordTextField &&
            passwordTextField.text != nil &&
            passwordTextField.text!.count < 8) {
            passwordTextFieldController.setErrorText("Password is too short",
                                                     errorAccessibilityValue: nil)
        }
        
        return false
    }
}
