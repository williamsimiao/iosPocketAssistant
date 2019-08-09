//
//  PerfilViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 03/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class PerfilViewController: UIViewController {
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var collectionView: UICollectionView?
    
    var tokenString: String?
    let networkManager = NetworkManager()
    var optionsArray: [String]?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        navigationItem.title = "Usuário"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
//        let userName = KeychainWrapper.standard.string(forKey: "USR")
        userNameLabel.text = "Usuário"
        
        optionsArray = ["Conectar-se a outro HSM",
                        "Opções do HSM",
                        "Trocar senha",
                        "Fechar sessão"]
    }
    
    func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 15

        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        flowLayout.headerReferenceSize = CGSize(width: self.collectionView!.frame.size.width, height: 50)

        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        collectionView!.register(OptionsCollectionViewCell.self, forCellWithReuseIdentifier: OptionsCollectionViewCell.identifier)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView?.backgroundColor = .white
        self.view.addSubview(collectionView!)
        
        //Constraints
        NSLayoutConstraint.activate([
            collectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            collectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            collectionView!.topAnchor.constraint(equalTo: userImgView.bottomAnchor, constant: 0),
            collectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        
    }

    func didTapTrocarSenha() {
        self.performSegue(withIdentifier: "to_TrocarSenhaViewController", sender: self)
    }
    
    func didTapFecharSessao() {
        guard let token = self.tokenString else {
            print("No token")
            return
        }
        let actionComplitionHandler: MDCActionHandler = {_ in
            self.networkManager.runClose(myDelegate: self, token: token) { (error) in
                if let error = error {
                    let message = AppUtil.handleAPIError(viewController: self, mErrorBody: error)
                    let snackBar = MDCSnackbarMessage()
                    snackBar.text = message
                    MDCSnackbarManager.show(snackBar)
                }
                else {
                    print("Deu certo")
                    AppUtil.removeTokenFromSecureLocation()
                    AppUtil.goToLoginScreen(sourceViewController: self)
                }
            }
        }
        
        let alertController = MDCAlertController(title: "Encerrar sessão", message: "Deseja mesmo encerrar a sessão ?")
        alertController.addAction(MDCAlertAction(title: "Sim", emphasis: .medium, handler: actionComplitionHandler))
        alertController.addAction(MDCAlertAction(title: "Cancelar", emphasis: .high, handler: nil))
        self.present(alertController, animated:true, completion:nil)
    }
}

extension PerfilViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width*0.95, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return optionsArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GestaoUsuariosCollectionViewCell.identifier, for: indexPath) as! OptionsCollectionViewCell
//        cell.optionTitle = optionsArray![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCollectionViewCell.identifier, for: indexPath) as! OptionsCollectionViewCell
        cell.optionTitle = optionsArray![indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OptionsCollectionViewCell
        let optionTitle = cell.optionTitle
        
        switch optionTitle {
        case "Conectar-se a outro HSM":
            print("1")
        case "Opções do HSM":
            print("2")
        case "Trocar senha":
            print("3")
            didTapTrocarSenha()
        case "Fechar sessão":
            print("4")
            didTapFecharSessao()
        default:
            print("Outro")
        }
    }
    
}

extension PerfilViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("AQUIIIIII")
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            print("Olha o IP \(challenge.protectionSpace.host)")
            let myHost = "10.61.53.209"
            if(challenge.protectionSpace.host == myHost) {
                print("LALA")
                let secTrust = challenge.protectionSpace.serverTrust
                let credential = URLCredential(trust: secTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }
    }
}
