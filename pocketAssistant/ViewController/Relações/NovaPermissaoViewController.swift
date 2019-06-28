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
    var systemAcl: Int?
    var userName: String?
    var userACL: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Permissões"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        turnAllSwitchesOff()
        salvarButton.applyContainedTheme(withScheme: globalContainerScheme())
        lerSwitch.addTarget(self, action: #selector(didTapASwitch), for: UIControl.Event.valueChanged)
        criarSwitch.addTarget(self, action: #selector(didTapASwitch), for: UIControl.Event.valueChanged)
        removerSwitch.addTarget(self, action: #selector(didTapASwitch), for: UIControl.Event.valueChanged)
        atualizarSwitch.addTarget(self, action: #selector(didTapASwitch), for: UIControl.Event.valueChanged)
        getSystemAclRequest(userName: userName!)
        //Se veio por essa tela então provavelmente o usuario nao estava na lista de Trustees,
        //logo nao deve ter nenhuma permissao
        if self.userACL == nil {
            self.userACL = 0
        }
        
        self.setUpSwitches(aclInteger: self.userACL!)
    }
    
    // MARK: - SWITCHES
    func turnAllSwitchesOff() {
        lerSwitch.isOn = false
        criarSwitch.isOn = false
        removerSwitch.isOn = false
        atualizarSwitch.isOn = false
    }
    
    func makeSwitchesHideOrNot(shouldHide: Bool) {
        lerSwitch.isHidden = shouldHide
        criarSwitch.isHidden = shouldHide
        removerSwitch.isHidden = shouldHide
        atualizarSwitch.isHidden = shouldHide
    }
    
    func setUpSwitches(aclInteger: Int) {
        let currentAcl = aclStruct(rawValue: UInt32(aclInteger))
        
        if currentAcl.contains(.obj_read) {
            lerSwitch.isOn = true
        }
        if currentAcl.contains(.obj_create) {
            criarSwitch.isOn = true
        }
        if currentAcl.contains(.obj_del) {
            removerSwitch.isOn = true
        }
        if currentAcl.contains(.obj_update) {
            atualizarSwitch.isOn = true
        }
    }
    
    @objc func didTapASwitch(mySwitch: UISwitch) {
        switch mySwitch {
        case lerSwitch:
            if mySwitch.isOn == false {
                criarSwitch.setOn(false, animated: true)
                removerSwitch.setOn(false, animated: true)
                atualizarSwitch.setOn(false, animated: true)
            }
//        case  criarSwitch:
//            if mySwitch.isOn == true {
//                lerSwitch.setOn(true, animated: true)
//            }
//        case removerSwitch:
//            if mySwitch.isOn == true {
//                lerSwitch.setOn(true, animated: true)
//            }
            
        //All others
        default:
            if mySwitch.isOn == true {
                lerSwitch.setOn(true, animated: true)
            }
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
    
    // MARK: - GET ACL
    func getSystemAclRequest(userName: String) {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }

        networkManager.runGetAcl(token: token, usr: userName) { (response, errorResponse) in
            if let errorResponse = errorResponse {
                let _ = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
            }
            if let response = response {
                self.systemAcl = response.acl
            }
        }
    }
    
    
    // MARK: - UPDATE ACL
    @IBAction func didTapSalvar(_ sender: Any) {
        let novoAcl = getIntFromSwitches()
        updateAclRequest(newAcl: novoAcl)
    }
    func composeFinalAcl(newAcl: Int) -> Int {
        let minusLastFourBits = systemAcl! >> 4
        let onlySystemAcl = minusLastFourBits << 4
        let finalAcl = onlySystemAcl | newAcl
        return finalAcl
    }

    func updateAclRequest(newAcl: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        let finalAcl = composeFinalAcl(newAcl: newAcl)
        networkManager.runUpdateAcl(token: token, acl: finalAcl, usr: userName!) { (errorResponse) in
            if let errorResponse = errorResponse {
                let _ = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
            }
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    let message = MDCSnackbarMessage()
                    message.text = "Permissão alterada com sucesso"
                    MDCSnackbarManager.show(message)
                }
            }
        }
    }
}

