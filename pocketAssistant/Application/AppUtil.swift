//
//  AppUtil.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import UIKit

open class AppUtil {
    
    func currentView() -> UIViewController {
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
    func goToLoginScreen(viewController: UIViewController) {
        DispatchQueue.main.async {
            let stor = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = stor.instantiateViewController(withIdentifier: "MainViewController")
            viewController.dismiss(animated: true, completion: {
                KeychainWrapper.standard.removeObject(forKey: "TOKEN")
                viewController.present(mainViewController, animated: true)
            })
        }
    }
    
    func alertAboutConnectionError(viewController: UIViewController) {
        
    }
    
    func isNetworkConnected() {
        
    }
    
    func handleAPIError(viewController: UIViewController, error: String) -> String? {
        let message = String()
        
        return message
    }
}
