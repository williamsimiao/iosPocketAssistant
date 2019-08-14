//
//  SvmkViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class SvmkViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var svmkTextField: MDCTextField!
    @IBOutlet weak var iniciarButton: MDCButton!
    
    var svmkTextFieldController: MDCTextInputControllerOutlined?
    var svmkTextLayout: textLayout?
    var selectedIpAddress : String?
    let miHelper = MIHelper.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstBoot()
        registerKeyboardNotifications()
        setupViews()
    }
    
    func setupViews() {
        //scrollView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        //titleLabel
        titleLabel.font = MDCTypography.subheadFont()
        titleLabel.alpha = MDCTypography.subheadFontOpacity()
        
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())

        svmkTextFieldController = MDCTextInputControllerOutlined(textInput: svmkTextField)
        svmkTextLayout = textLayout(textField: svmkTextField, controller: svmkTextFieldController!)
        svmkTextField.delegate = self
        svmkTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapIniciar(_ sender: Any) {
        
    }
    
    // MARK: - MI Calls
    func checkFirstBoot() {
        miHelper.isFirstBoot(address: selectedIpAddress!) { (object) in
            let boolean = object as? Bool
            guard let isFirstBoot = boolean else { return }
            if isFirstBoot {
                self.handleFirstBoot()
            }
            else {
                self.miHelper.isServiceStarted(completionHandler: { (object) in
                    let boolean = object as? Bool
                    guard let isServiceStarted = boolean else { return }
                    if isServiceStarted {
                        print("Already Started")
                        self.serviceDidStarted()
                    }
                    else {
                        print("User must start")
                        self.tryToStartService()
                    }
                })
            }
        }
    }
    
    func tryToStartService() {
        guard let initKey = KeychainWrapper.standard.string(forKey: "INIT_KEY") else {
            return
        }
        self.miHelper.serviceStartProcess(address: self.selectedIpAddress!, initKey: initKey, completionHandler: { (object) in
            let serviceStartedWithSuccess = object as? Bool
            if serviceStartedWithSuccess ?? false {
                print("START SUCSESS")
                self.serviceDidStarted()
            }
            else {
                self.showFields()
                let message = object as? String
                print("START FAIL: \(message ?? "Outro erro")")
            }
        })
    }
    
    func showFields() {
        titleLabel.isHidden = false
        svmkTextField.isHidden = false
        iniciarButton.isHidden = false
    }
    
    func serviceDidStarted() {
        let snackBar = MDCSnackbarMessage()
        snackBar.text = "Conectado"
        MDCSnackbarManager.show(snackBar)
        
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController = stor.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true)
    }
    
    func handleFirstBoot() {
        print("NOT IMPLEMENTED")
    }
    
    func sendAuthMessage() {
        guard let ipAddress = self.selectedIpAddress else {
            return
        }
        guard AppUtil.validIPAdress(svmkTextLayout!) else {
            return
        }
        let initKey = svmkTextField.text
        miHelper.sendAuth(initKey: initKey!) { (object) in
            let isAutenticated = object as? Bool
            if isAutenticated ?? false {
                self.miHelper.serviceStartProcess(address: ipAddress, initKey: initKey!, completionHandler: { (object) in
                    guard let _ = object as? Bool else {
                        let message = object as? String
                        print("START FAIL: \(message ?? "Outro erro")")
                        
                        return
                    }
                    print("START SUCSESS")
                    
                })
            }
        }
    }
    
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
extension SvmkViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == svmkTextField {
            let _ = AppUtil.validIPAdress(svmkTextLayout!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case svmkTextField:
            svmkTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case svmkTextField:
            svmkTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
}
