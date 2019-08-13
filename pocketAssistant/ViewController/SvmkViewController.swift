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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var svmkTextField: MDCTextField!
    @IBOutlet weak var iniciarButton: MDCButton!
    
    var svmkTextFieldController: MDCTextInputControllerOutlined?
    var svmkTextLayout: textLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        setupViews()
    }
    
    @IBAction func didTapIniciar(_ sender: Any) {
        
    }
    
    func setupViews() {
        
        iniciarButton.applyContainedTheme(withScheme: globalContainerScheme())

        svmkTextFieldController = MDCTextInputControllerOutlined(textInput: svmkTextField)
        svmkTextLayout = textLayout(textField: svmkTextField, controller: svmkTextFieldController!)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillChangeFrameNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0);
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero;
    }

}
