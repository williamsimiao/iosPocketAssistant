//
//  SecondViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
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
        tokenLabel.text = tokenString

    }
    
    @IBAction func listarObjetos(_ sender: Any) {
        guard let token = self.tokenString else {
            return
        }
        networkManager.runListObjs(token: token) { (response, error) in
            print("Objetos Listados")
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
    

    @IBAction func close(_ sender: Any) {
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
                    let alert = UIAlertController(title: "Sessão encerrada", message: "Sessão encerrada com sucesso", preferredStyle: UIAlertController.Style.alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(dismissAction)

                    self.present(alert, animated: true)
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
