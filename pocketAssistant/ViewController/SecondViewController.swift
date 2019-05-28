//
//  SecondViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class SecondViewController: UIViewController {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.backgroundColor = .white
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return scrollView
    }()
    let listarObjetosButton: MDCButton = {
        let listarObjetosButton = MDCButton()
        listarObjetosButton.translatesAutoresizingMaskIntoConstraints = false
        listarObjetosButton.setTitle("Listar Objetos", for: .normal)
        listarObjetosButton.addTarget(self, action: #selector(didListarObjetos(sender:)), for: .touchUpInside)
        return listarObjetosButton
    }()
    let listarUsuariosButton: MDCButton = {
        let listarUsuariosButton = MDCButton()
        listarUsuariosButton.translatesAutoresizingMaskIntoConstraints = false
        listarUsuariosButton.setTitle("Listar Usuários", for: .normal)
        listarUsuariosButton.addTarget(self, action: #selector(didTapListarUsuarios(sender:)), for: .touchUpInside)
        return listarUsuariosButton
    }()
    let closeButton: MDCButton = {
        let closeButton = MDCButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Fechar Sessão", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapClose(sender:)), for: .touchUpInside)
        return closeButton
    }()
    var appBarViewController = MDCAppBarViewController()
    
    var tokenString: String?
    var networkManager: NetworkManager!
    var objIdArray: [String]?

    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.networkManager = NetworkManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dinâmo Pocket 2"

        //ScrollView\
        scrollView.delegate = self
        self.appBarViewController.headerView.trackingScrollView = self.scrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        
        //AppBar
        self.addChild(self.appBarViewController)
        self.appBarViewController.didMove(toParent: self)
        view.addSubview(self.appBarViewController.view)

        scrollView.addSubview(listarObjetosButton)
        scrollView.addSubview(listarUsuariosButton)
        scrollView.addSubview(closeButton)

        setConstrainst()
    }
    
    func setConstrainst() {
        var constraints = [NSLayoutConstraint]()
        //Listar objetos button
        constraints.append(NSLayoutConstraint(item: listarObjetosButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 250))
        constraints.append(NSLayoutConstraint(item: listarObjetosButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[listarObjetos]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "listarObjetos" : listarObjetosButton]))
        //Listar Usuarios button
        constraints.append(NSLayoutConstraint(item: listarUsuariosButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: listarObjetosButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: listarUsuariosButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[listarUsuarios]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "listarUsuarios" : listarUsuariosButton]))
        //Close button
        constraints.append(NSLayoutConstraint(item: closeButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: listarUsuariosButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: closeButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[close]-|",
                                           options: [],
                                           metrics: nil,
                                           views: [ "close" : closeButton]))
        
        NSLayoutConstraint.activate(constraints)

    }
    @objc func didTapClose(sender: Any) {
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
                    let alertController = MDCAlertController(title: "Sessão encerrada", message: "Sessão encerrada com sucesso")
                    let action = MDCAlertAction(title: "OK", handler: { (MDCAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated:true, completion:nil)
                    
                    
//                    let alert = UIAlertController(title: "Sessão encerrada", message: "Sessão encerrada com sucesso", preferredStyle: UIAlertController.Style.alert)
//                    let dismissAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                    alert.addAction(dismissAction)
//
//                    self.present(alert, animated: true)
                }
            }
        }
    }

    
    @objc func didListarObjetos(sender: Any) {
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
    @objc func didTapListarUsuarios(sender: Any) {
        
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

