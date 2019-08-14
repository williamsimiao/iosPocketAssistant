//
//  WellcomeViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class WellcomeViewController: UIViewController {
    @IBOutlet weak var iniciarButton: MDCButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseUrl = KeychainWrapper.standard.string(forKey: "BASE_URL")
        if baseUrl != nil {
            goToDeviceSelection()
            return
        }
        setupViews()
    }
    
    func setupViews() {
        titleLabel.isHidden = false
        titleLabel.font = MDCTypography.display1Font()
        titleLabel.alpha = MDCTypography.display1FontOpacity()
        
        descriptionLabel.isHidden = false
        descriptionLabel.font = MDCTypography.display1Font()
        descriptionLabel.alpha = MDCTypography.display1FontOpacity()
        
        iniciarButton.isHidden = false
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())
    }
    
    @IBAction func didTapIniciar(_ sender: Any) {
        goToDeviceSelection()
    }
    
    func goToDeviceSelection() {
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController = stor.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true)
    }
    
}
