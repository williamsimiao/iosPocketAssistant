//
//  SvmkViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class SvmkViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var svmkTextField: MDCTextField!
    @IBOutlet weak var iniciarButton: MDCButton!
    
    var svmkTextFieldController: MDCTextInputControllerOutlined?
    var svmkTextLayout: textLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func didTapIniciar(_ sender: Any) {
        
    }
    
    func setupViews() {
        
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())

        svmkTextFieldController = MDCTextInputControllerOutlined(textInput: svmkTextField)
        svmkTextLayout = textLayout(textField: svmkTextField, controller: svmkTextFieldController!)
    }
  

}
