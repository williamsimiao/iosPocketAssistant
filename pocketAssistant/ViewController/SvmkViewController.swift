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
    var isFirstBoot = false

    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstBootAndService()
        
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
        guard AppUtil.validInitKey(svmkTextLayout!) else {
            print("Invalid initKey")
            return
        }
        if isFirstBoot {
            self.handleFirstBoot()
        }
        
        let initKey = svmkTextField.text!
        tryToStartService(initKey: initKey)
        
        let _ = KeychainWrapper.standard.set(initKey, forKey: "INIT_KEY")
        let _ = KeychainWrapper.standard.set(selectedIpAddress!, forKey: "BASE_URL")
    }
    
    // MARK: - MI Calls
    func checkIsServiceStarted() {
        self.miHelper.isServiceStarted(completionHandler: { (object) in
            let boolean = object as? Bool
            guard let isServiceStarted = boolean else { return }
            if isServiceStarted {
                print("Already Started")
                self.serviceIsStarted()
            }
            else {
                print("User must start")
                guard let initKey = KeychainWrapper.standard.string(forKey: "INIT_KEY") else {
                    return
                }
                self.tryToStartService(initKey: initKey)
            }
        })
    }
    
    func checkFirstBootAndService() {
        miHelper.isFirstBoot(address: selectedIpAddress!) { (object) in
            let boolean = object as? Bool
            guard let firstBoot = boolean else { return }
            self.isFirstBoot = firstBoot
            
            if self.isFirstBoot == false {
                self.checkIsServiceStarted()
            }
        }
    }
    
    func tryToStartService(initKey: String) {
        guard let ipAddress = self.selectedIpAddress else {
            return
        }
        
        self.miHelper.serviceStartProcess(address: ipAddress, initKey: initKey, completionHandler: { (object) in
            let serviceStartedWithSuccess = object as? Bool
            if serviceStartedWithSuccess ?? false {
                print("START SUCSESS")
                self.serviceIsStarted()
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
    
    func serviceIsStarted() {
        let snackBar = MDCSnackbarMessage()
        snackBar.text = "Serviço iniciado"
        MDCSnackbarManager.show(snackBar)
        
        KeychainWrapper.standard.set(selectedIpAddress!, forKey: "BASE_URL")
        
        miHelper.stopSession()
        
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController = stor.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true)
    }
    
    func handleFirstBoot() {
        print("NOT IMPLEMENTED")
        
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
