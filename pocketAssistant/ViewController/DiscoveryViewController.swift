//
//  SetupViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 16/07/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SocketIO
import SwiftSocket

class DiscoveryViewController: UIViewController {
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var tryAgainButton: MDCButton!
    @IBOutlet weak var lele: UICollectionView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var enderecoTextField: MDCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var stringArray = ["lele", "lolo", "lili", "lala", "lulu"]
    let miHelper = MIHelper()
    
    var addressTextFieldController: MDCTextInputControllerUnderline?
    var addressTextLayout: textLayout?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
    }
    
    func setUpViews() {
        addressTextFieldController = MDCTextInputControllerUnderline(textInput: enderecoTextField)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: addressTextFieldController!)
        
        addressTextLayout = textLayout(textField: enderecoTextField, controller: addressTextFieldController!)
        enderecoTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    // MARK: - Gesture Handling
    @objc func didTapScrollView(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapTryAgain(_ sender: Any) {
        print("CLICOU")
    }
    
    @IBAction func didTapConnect(_ sender: Any) {
        
        miHelper.serviceStartProcess(address: "10.61.53.225", initKey: "12345678") { (object) in
            let serviceStartedWithSuccess = object as? Bool
            if serviceStartedWithSuccess ?? false {
                print("START SUCSESS")
            }
            else {
                let message = object as? String
                print("START FAIL: \(message ?? "Outro erro")")
            }
        }
        
        miHelper.isServiceStarted { (object) in
            let isServiceStarted = object as! Bool
            if isServiceStarted {
                print("SIM ESTA")
            }
            else {
                print("NAO ESTA")
            }
        }
    }
}

extension DiscoveryViewController: UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelacaoCollectionViewCell.identifier, for: indexPath) as! RelacaoCollectionViewCell
        
        cell.titleLabel.text = stringArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RelacaoCollectionViewCell
        print("Click \(cell.titleLabel.text ?? "nada")")
        //        segueDelegate?.goToNovaPermisao(userACLpair: userPermission)
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

// MARK: - UITextFieldDelegate
extension DiscoveryViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == enderecoTextField {
            let _ = AppUtil.validIPAdress(addressTextLayout!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case enderecoTextField:
            enderecoTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case enderecoTextField:
            addressTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
}
