//
//  SecondViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class SecondViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var appBarViewController = MDCAppBarViewController()
    
    var tokenString: String?
    let networkManager = NetworkManager()
    var objIdArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo Pocket 2"
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
        //AppBar
        self.addChild(self.appBarViewController)
        self.appBarViewController.headerView.trackingScrollView = self.scrollView
        self.appBarViewController.didMove(toParent: self)
        view.addSubview(self.appBarViewController.view)

    }
    @IBAction func didTapListarObjetos(_ sender: Any) {
        guard let token = self.tokenString else {
            return
        }
        networkManager.runListObjs(token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.objIdArray = response.obj
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "to_objetos", sender: self)
                }
            }
        }
    }
    
    @IBAction func didTapCriarUsuario(_ sender: Any) {
    }
    @IBAction func didTapMudarSenha(_ sender: Any) {
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        guard let token = self.tokenString else {
            print("No token")
            return
        }
        networkManager.runClose(token: token) { (error) in
            print("Closed")
            if let error = error {
                print(error)
            }
            else {
                DispatchQueue.main.async {
                    let actionComplitionHandler: MDCActionHandler = {_ in
                        let stor = UIStoryboard.init(name: "Main", bundle: nil)
                        let mainViewController = stor.instantiateViewController(withIdentifier: "MainViewController")
                        self.present(mainViewController, animated: true, completion: { () in
                            print("Done")
                        })
                    }

                    let alertController = MDCAlertController(title: "Sessão encerrada", message: "Sessão encerrada com sucesso")
                    let action = MDCAlertAction(title: "OK", handler: actionComplitionHandler)
                    alertController.addAction(action)
                    self.present(alertController, animated:true, completion:nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "to_objetos" {
            guard let objetosViewController = segue.destination as? ObjetosViewController else {
                return
            }
            objetosViewController.tokenString = self.tokenString
            objetosViewController.networkManager = self.networkManager
            objetosViewController.objIdArray = self.objIdArray
        }
    }
}

//MARK: - UIScrollViewDelegate

extension SecondViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.appBarViewController.headerView.trackingScrollView) {
            self.appBarViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = self.appBarViewController.headerView
        if (scrollView == headerView.trackingScrollView) {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity,
                                                     targetContentOffset: targetContentOffset)
        }
    }
    
}

