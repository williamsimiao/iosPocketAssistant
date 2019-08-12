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
        let isFirstTime = KeychainWrapper.standard.bool(forKey: "FIRST_TIME")
        guard let mFirtTime = isFirstTime else {
            let _ = KeychainWrapper.standard.set(false, forKey: "FIRST_TIME")
            goToDeviceSelection()
            return
        }
        if baseUrl != nil || !mFirtTime {
            goToDeviceSelection()
        }
        else {
            setupViews()
        }
        
    }
    
    func setupViews() {
        titleLabel.isHidden = false
        descriptionLabel.isHidden = false
        iniciarButton.isHidden = false
        
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())
    }
    
    @IBAction func didTapIniciar(_ sender: Any) {
        goToDeviceSelection()
    }
    
    func goToDeviceSelection() {
        performSegue(withIdentifier: "wellcome_to_discovery", sender: self)
    }
    
}
