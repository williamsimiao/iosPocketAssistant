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
    @IBOutlet weak var mudarSenhaButton: MDCButton!
    @IBOutlet weak var fecharSessaoButton: MDCButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    var tokenString: String?
    let networkManager = NetworkManager()
    var optionsArray: [String]?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Usuário"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tokenString = KeychainWrapper.standard.string(forKey: "TOKEN")
        
        mudarSenhaButton.applyContainedTheme(withScheme: globalContainerScheme())
        fecharSessaoButton.applyContainedTheme(withScheme: globalContainerScheme())
        
        let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = UIColor(red: 170, green: 170, blue: 170)
        view.addSubview(barView)
        

        
        optionsArray = ["Conectar-se a outro HSM",
                        "Opções do HSM",
                        "Trocar senha",
                        "Fechar sessão"]
    }

    @IBAction func didTapTrocarSenha(_ sender: Any) {
        self.performSegue(withIdentifier: "to_TrocarSenhaViewController", sender: self)
    }
    
    @IBAction func didTapFecharSessao(_ sender: Any) {
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
        
        return CGSize(width: width, height: 108.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return optionsArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GestaoUsuariosCollectionViewCell.identifier, for: indexPath) as! GestaoUsuariosCollectionViewCell
        cell.userName = optionsArray![indexPath.row]
        return cell
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
