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

    @IBAction func close(_ sender: Any) {
        guard let token = self.tokenString else {
            return
        }
        networkManager.runClose(token: token) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}
