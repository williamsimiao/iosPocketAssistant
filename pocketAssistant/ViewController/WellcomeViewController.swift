//
//  WellcomeViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class WellcomeViewController: UIViewController {
    @IBOutlet weak var iniciarButton: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())
    }
        
    
    @IBAction func didTapIniciar(_ sender: Any) {
        performSegue(withIdentifier: "wellcome_to_discovery", sender: self)
    }
    
}
