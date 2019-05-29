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
    
    var tokenHasExpired = false
    let networkManager = NetworkManager()
    var appBarViewController = MDCAppBarViewController()
    
    //TODO: Add text field controllers
    var usernameTextFieldController: MDCTextInputControllerOutlined?
    var passwordTextFieldController: MDCTextInputControllerOutlined?
    var otpTextFieldController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tokenHasExpired {
            let alertController = MDCAlertController(title: "Token experou", message: "O token experou, faça login novamente")
            let action = MDCAlertAction(title: "OK", handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated:true, completion:nil)
        }
        
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextFieldController = MDCTextInputControllerOutlined(textInput: otpTextField)

        self.title = "Dinâmo Pocket"
        // Set the tracking scroll view.
        scrollView.delegate = self
        
        self.appBarViewController.headerView.trackingScrollView = self.scrollView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        self.addChild(self.appBarViewController)
        self.appBarViewController.didMove(toParent: self)
        view.addSubview(self.appBarViewController.view)

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        otpTextField.delegate = self
        registerKeyboardNotifications()
        
        
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
        if validateAuth() == false {
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        networkManager.runAuth(usr: username, pwd: password) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                let tokenSaved: Bool = KeychainWrapper.standard.set(response.token, forKey: "TOKEN")
                let usrSaved: Bool = KeychainWrapper.standard.set(username, forKey: "usr")
                let pwdSaved: Bool = KeychainWrapper.standard.set(password, forKey: "pwd")
                if !(tokenSaved && usrSaved && pwdSaved) {
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
            passwordTextFieldController!.setErrorText("Senha muito curta",
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
