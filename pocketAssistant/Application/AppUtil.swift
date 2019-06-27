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
    
    class func handleAPIError(viewController: UIViewController, error: String) -> String? {
        let message = String()
        let rc: Int? = nil
        let rd: String? = nil
        
        if let range = error.range(of: "\"rc\": ")  {
            print(error[range.upperBound...])
            print(error[range.upperBound...])
        }
        
        
        
        return message
    }
    
    
    //fun handleAPIError(activity: Activity, mErrorBody: ResponseBody?): String? {
    //    val message: String
    //
    //    val errorStream = mErrorBody?.byteStream().toString()
    //    val rc = errorStream.substringAfter("\"rc\": ").substringBefore(",")
    //    val rd = errorStream.substringAfter("\"rd\":  \"").substringBefore("\"")
    //    val errorBody = errorBody(rc.toLong(), rd)
    //
    //    when(errorBody.rd) {
    //        "ERR_ACCESS_DENIED" -> {
    //            message = activity.getString(R.string.ERR_ACCESS_DENIED_message)
    //            if(activity !is MainActivity) {
    //                goToLoginScreen(activity)
    //            }
    //        }
    //        "ERR_USR_NOT_FOUND" -> message = activity.getString(R.string.ERR_USR_NOT_FOUND_message)
    //        else -> {
    //            message = activity.getString(R.string.ERR_DESCONHECIDO_message)
    //            Log.d(TAG, errorBody.rd)
    //        }
    //    }
    //    return message
    //}
}
