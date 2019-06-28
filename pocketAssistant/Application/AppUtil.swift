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
    
    class func goToLoginScreen(sourceViewController: UIViewController) {
        DispatchQueue.main.async {
            let stor = UIStoryboard.init(name: "Main", bundle: nil)
            let LoginViewController = stor.instantiateViewController(withIdentifier: "LoginViewController")
            sourceViewController.dismiss(animated: true, completion: {
                KeychainWrapper.standard.removeObject(forKey: "TOKEN")
                sourceViewController.present(LoginViewController, animated: true)
            })
        }
    }
    
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
        let snackBar = MDCSnackbarMessage()
        snackBar.text = message
        MDCSnackbarManager.show(snackBar)

        return isConnected
    }
    
    class func handleAPIError(viewController: UIViewController, mErrorBody: errorBody) -> String? {
        let message: String?
        
        switch mErrorBody.rd {
        case "ERR_ACCESS_DENIED":
            message = "Acesso negado"
            if (viewController is LoginViewController) == false {
                goToLoginScreen(sourceViewController: viewController)
            }
        case "ERR_USR_NOT_FOUND": message = "Usuário não encontrado"
        default:
            message = "Erro desconhecido"
            print(mErrorBody.rd)
        }
        
        if message != "Acesso negado" {
            let snackBar = MDCSnackbarMessage()
            snackBar.text = message
            MDCSnackbarManager.show(snackBar)
        }
        
        return message
    }
}
