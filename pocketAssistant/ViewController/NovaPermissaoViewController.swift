//
//  NovaPermissaoViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class NovaPermissaoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lerSwitch: UISwitch!
    @IBOutlet weak var criarSwitch: UISwitch!
    @IBOutlet weak var removerSwitch: UISwitch!
    @IBOutlet weak var atualizarSwitch: UISwitch!
    @IBOutlet weak var salvarButton: MDCButton!
    
    var usernameTextFieldController: MDCTextInputControllerOutlined?
    let networkManager = NetworkManager()
    var myAcl: aclStruct?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        salvarButton.applyContainedTheme(withScheme: globalContainerScheme())
        lerSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        criarSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        removerSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        atualizarSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)

        getAclRequest()
    }
    
    // MARK: - SWITCHES
    @objc func switchChanged(mySwitch: UISwitch) {
        switch mySwitch {
        case lerSwitch:
            if mySwitch.isOn == false {
                criarSwitch.isOn = false
                removerSwitch.isOn = false
                atualizarSwitch.isOn = false
            }

        default:
            print("Outro switch")
        }
    }
    
    func getIntFromSwitches() -> Int {
        var unionOfBits = aclStruct(rawValue: 0)
        if lerSwitch.isOn {
            unionOfBits = unionOfBits.union(.obj_read)
        }
        if criarSwitch.isOn {
            unionOfBits = unionOfBits.union(.obj_create)
        }
        if removerSwitch.isOn {
            unionOfBits = unionOfBits.union(.obj_del)
        }
        if atualizarSwitch.isOn {
            unionOfBits = unionOfBits.union(.obj_update)
        }
        print("Meu Int32: \(unionOfBits.rawValue)")
        print("Resultado interiro: \(Int(unionOfBits.rawValue))")
        return Int(unionOfBits.rawValue)
    }
    
    func setUpSwitches(aclInteger: Int) {
        myAcl = aclStruct(rawValue: UInt32(aclInteger))
        
        guard let myAcl = self.myAcl else {
            print("no ACL")
            return
        }
        
        if myAcl.contains(.obj_read) {
            lerSwitch.isOn = true
        }
        if myAcl.contains(.obj_create) {
            criarSwitch.isOn = true
        }
        if myAcl.contains(.obj_del) {
            removerSwitch.isOn = true
        }
        if myAcl.contains(.obj_update) {
            atualizarSwitch.isOn = true
        }
    }
    
    // MARK: - GET ACL
    func getAclRequest() {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let username = self.username else {
            return
        }
        
        networkManager.runGetAcl(token: token, usr: username) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                let theAcl = response.acl
                DispatchQueue.main.async {
                    self.setUpSwitches(aclInteger: theAcl)
                }
            }
        }
    }
    
    
    // MARK: - UPDATE ACL
    @IBAction func didTapSalvar(_ sender: Any) {
        let novoAcl = getIntFromSwitches()
//        updateAclRequest(acl: novoAcl)
    }
    
    func updateAclRequest(acl: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        guard let username = username else {
            return
        }
        networkManager.runUpdateAcl(token: token, acl: acl, usr: username) { (error) in
            if let error = error {
                print(error)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Permissão alterada com sucesso"
                    MDCSnackbarManager.show(message)
                }
            }
        }
    }
    
//    // MARK: - Keyboard Handling
//    func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.keyboardWillShow),
//            name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
//            object: nil)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.keyboardWillShow),
//            name: NSNotification.Name(rawValue: "UIKeyboardWillChangeFrameNotification"),
//            object: nil)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.keyboardWillHide),
//            name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
//            object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        let keyboardFrame =
//            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0);
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        self.scrollView.contentInset = UIEdgeInsets.zero;
//    }
}

//// MARK: - UITextFieldDelegate
//extension NovaPermissaoViewController: UITextFieldDelegate {
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        usernameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
//        return true
//    }
//
//    //Validation after press return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        if usernameTextField.text == nil || usernameTextField.text == "" {
//            usernameTextFieldController?.setErrorText("Campo obrigatório", errorAccessibilityValue: nil)
//        }
////        return true
//        return false
//    }
//
//    //Validation while typing
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//
//        return true
//    }
//}

