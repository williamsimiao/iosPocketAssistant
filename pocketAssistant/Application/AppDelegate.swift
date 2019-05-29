//
//  AppDelegate.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let networkManager = NetworkManager()
        let token = KeychainWrapper.standard.string(forKey: "TOKEN")
        guard let tokenString = token else {
            return true
        }
        networkManager.runProbeSynchronous(token: tokenString) { (response, error) in
            if let error = error {
                print(error)
                let stor = UIStoryboard.init(name: "Main", bundle: nil)
                let homeView = stor.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                homeView.tokenHasExpired = true
                self.window?.rootViewController = homeView

            }
            else if let response = response {
                print(response.probe_str)
                let stor = UIStoryboard.init(name: "Main", bundle: nil)
                let homeView = stor.instantiateViewController(withIdentifier: "SecondViewController")
                let nav = UINavigationController(rootViewController: homeView)
//                nav.navigationBar.isHidden = true
                self.window?.rootViewController = nav
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

