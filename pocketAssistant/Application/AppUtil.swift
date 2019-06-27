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
    
    //DAQUI pra baixo
    class func goToLoginScreen(sourceViewController: UIViewController) {
        DispatchQueue.main.async {
            let stor = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = stor.instantiateViewController(withIdentifier: "MainViewController")
            sourceViewController.dismiss(animated: true, completion: {
                KeychainWrapper.standard.removeObject(forKey: "TOKEN")
                sourceViewController.present(mainViewController, animated: true)
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
    
    class func alertAboutConnectionError(viewController: UIViewController) -> Bool {
        let title: String?
        let message: String?
        
        let isConnected = isInternetAvailable()
        if isConnected == false {
            title = "Erro ao conectar-se"
            message = "Verifique sua conecção com a internet e tente novamente"
        }
        else {
            title = "Erro"
            message = "Erro desconhecido"
        }
        let alertController = MDCAlertController(title: title, message: message)
        alertController.addAction(MDCAlertAction(title: "Ok", emphasis: .high, handler: nil))
        viewController.present(alertController, animated:true, completion:nil)
        
        return isConnected
    }
    
    class func handleAPIError(viewController: UIViewController, mErrorBody: errorBody) -> String? {
        let message: String?
        
        switch mErrorBody.rd {
        case "ERR_ACCESS_DENIED":
            message = "Acesso negado"
            if (viewController is MainViewController) == false {
                goToLoginScreen(sourceViewController: viewController)
            }
        case "ERR_USR_NOT_FOUND": message = "Usuário não encontrado"
        default:
            message = "Erro desconhecido"
            print(mErrorBody.rd)
        }
        return message
    }
}
