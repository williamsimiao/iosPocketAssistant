//
//  AppUtil.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import SystemConfiguration
import UIKit
import MaterialComponents

open class AppUtil {
    
    class func currentView() -> UIViewController {
        var currentViewController: UIViewController!
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            currentViewController = topController
        }
        return currentViewController
    }
    
    class func removeTokenFromSecureLocation() {
        KeychainWrapper.standard.removeObject(forKey: "TOKEN")
    }
    
    class func goToLoginScreen(sourceViewController: UIViewController) {
        DispatchQueue.main.async {
            let stor = UIStoryboard.init(name: "Main", bundle: nil)
            let LoginViewController = stor.instantiateViewController(withIdentifier: "LoginViewController")
            sourceViewController.present(LoginViewController, animated: true, completion: {
//                sourceViewController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - CONNECTION ERROR HANDLING
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    class func alertAboutConnectionError() -> Bool {
        let message: String?
        
        let isConnected = isInternetAvailable()
        if isConnected == false {
            message = "Verifique sua conecção com a internet e tente novamente"
        }
        else {
            message = "Erro ao conectar-se"
        }
        
        let alertController = MDCAlertController(title: "Sem conexão", message: message)
        alertController.addAction(MDCAlertAction(title: "Ok", emphasis: .high, handler: nil))
        DispatchQueue.main.async {
            currentView().present(alertController, animated:true, completion:nil)
        }

        return isConnected
    }
    
    class func handleAPIError(viewController: UIViewController, mErrorBody: errorBody) -> String? {
        let message: String?
        
        switch mErrorBody.rd {
        case "ERR_INVALID_KEY":
            message = "Sessão expirou"
            if (viewController is LoginViewController) == false {
                goToLoginScreen(sourceViewController: viewController)
            }
        case "ERR_ACCESS_DENIED":
            message = "Acesso negado"
            if (viewController is LoginViewController) == false {
                goToLoginScreen(sourceViewController: viewController)
            }
        case "ERR_USR_ALREADY_EXISTS": message = "Usuário já existe"
        case "ERR_USR_NOT_FOUND": message = "Usuário não encontrado"
        case "ERR_INVALID_PAYLOAD": message = "Entrada inválida"
        default:
            message = "Erro desconhecido"
            print(mErrorBody.rd)
        }
        
        return message
    }
    
    // MARK: - INPUT ERROR HANDLING
    class func validUsr(_ usrTextLayout: textLayout) -> Bool {
        if usrTextLayout.textField.text == "" {
            return false
        }
        let isAlphaNumeric = usrTextLayout.textField.text!.isAlphanumeric
        if isAlphaNumeric == false {
            usrTextLayout.controller.setErrorText("O Nome deve conter apenas caracteres alfanuméricos", errorAccessibilityValue: nil)
        }
        return isAlphaNumeric
    }
    
    class func validPwdConfirmation(_ pwdTextLayout: textLayout, _ confirmationTextLayout: textLayout) -> Bool {
        if confirmationTextLayout.textField.text == "" {
            return false
        }
        if pwdTextLayout.textField.text == confirmationTextLayout.textField.text {
            return true
        }
        else {
            confirmationTextLayout.controller.setErrorText("Confirmação difere da senha", errorAccessibilityValue: nil)
            return false
        }
    }
    
    class func validPwd(_ pwdTextLayout: textLayout) -> Bool {
        let pwdMinimumLength = 8
        if pwdTextLayout.textField.text == "" {
            return false
        }
        if pwdTextLayout.textField.text!.count >= pwdMinimumLength {
            return true
        }
        else {
            pwdTextLayout.controller.setErrorText("Senhas devem conter pelo menos 8 caracteres", errorAccessibilityValue: nil)
            return false
        }
    }
    
    class func fieldsAreValid(_ textLayoutArray: [textLayout]) -> Bool {
        var isValid = true
        for textLayout in textLayoutArray {
            if textLayout.textField.text == "" {
                textLayout.controller.setErrorText("Campo Obrigatório", errorAccessibilityValue: nil)
                isValid = false
            }
        }
        return isValid
    }
    
    //fun fieldsAreValid(context: Context?, mTextInputLayoutArray: Array<TextInputLayout>): Boolean {
    //    var isValid = true
    //
    //    for(mTextInputlayout: TextInputLayout in mTextInputLayoutArray) {
    //        val input = mTextInputlayout.editText!!.text.toString()
    //        if(input == "") {
    //            mTextInputlayout.error = context!!.getString(R.string.required_field)
    //            isValid = false
    //        }
    //    }
    //    return isValid
    //}
    
    
    
    //    fun didTapAlterar() {
    //        if(fieldsAreValid(context, arrayOf(newPwdEditText,
    //                newPwdConfirmationEditText)) == false) {
    //            return
    //        }
    //
    //        if(validPwd(context, newPwdEditText) ==  false) return
    //
    //        if(validPwdConfirmation(context, newPwdEditText.editText!!.text.toString(),
    //                newPwdConfirmationEditText) == false) {
    //            return
    //        }
    //
    //        changePwdRequest()
    //    }
}
