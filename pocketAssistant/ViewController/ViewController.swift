//
//  ViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var usrTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var odtTextField: UITextField!
    
    var networkManager: NetworkManager!
    var tokenString: String?
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.networkManager = NetworkManager()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateTextInput(text: String?) throws {
        if text == nil {
            throw inputError.stringNil
        }
        //TODO check more cases
    }
    
    func validateAuth() -> Bool {
        do {
            try validateTextInput(text: usrTextField.text)
            try validateTextInput(text: pwdTextField.text)
        } catch {
            let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    @IBAction func autenticar(_ sender: Any) {
        if validateAuth() == false {
            return
        }
        networkManager.runAuth(usr: usrTextField.text!, pwd: pwdTextField.text!) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.tokenString = response.token
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "to_second", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "to_second" {
            guard let navigationController = segue.destination as? UINavigationController else {
                return
            }
            guard let secondViewController = navigationController.viewControllers.first as? SecondViewController else {
                return
            }
            guard let token = self.tokenString else {
                print("NO token")
                return
            }
            secondViewController.tokenString = token
            secondViewController.networkManager = self.networkManager
        }
    }
}

