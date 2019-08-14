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
    @IBOutlet weak var devicesCollectionView: UICollectionView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var ipAddressTextField: MDCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    lazy var activityIndicator: MDCActivityIndicator = {
        let aActivityIndicator = MDCActivityIndicator()
        aActivityIndicator.sizeToFit()
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.primaryColor = .black
        MDCActivityIndicatorColorThemer.applySemanticColorScheme(colorScheme, to: aActivityIndicator)
        
        return aActivityIndicator
    }()
    
    var stringArray = ["lele", "lolo", "lili", "lala", "lulu"]
    let miHelper = MIHelper()
    
    var addressTextFieldController: MDCTextInputControllerUnderline?
    var addressTextLayout: textLayout?
    var hsmWasFound = false
    var selectedIpAddress : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        setUpViews()
        hsmWasFound = false
    }
    
    func setUpViews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.devicesCollectionView.isHidden = !self.hsmWasFound
            let newTitle = self.hsmWasFound ? "Pockets encontrados na rede" : "Não encontramos pockets em sua rede"
            self.mainTitle.text = newTitle
            self.activityIndicator.stopAnimating()
        }
        //activityIndicator
        contentView.addSubview(activityIndicator)
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: devicesCollectionView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        activityIndicator.startAnimating()
        
        //Main title
        mainTitle.font = MDCTypography.display1Font()
        mainTitle.alpha = MDCTypography.display1FontOpacity()
        
        //tryAgainButton
        tryAgainButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        
        //subtitle
        subtitle.font = MDCTypography.subheadFont()
        subtitle.alpha = MDCTypography.subheadFontOpacity()
        
        //ipAddressTextField
        addressTextFieldController = MDCTextInputControllerUnderline(textInput: ipAddressTextField)
        MDCTextFieldColorThemer.applySemanticColorScheme(textFieldColorScheme(), to: addressTextFieldController!)
        
        addressTextLayout = textLayout(textField: ipAddressTextField, controller: addressTextFieldController!)
        ipAddressTextField.delegate = self
        ipAddressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

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
        guard AppUtil.validIPAdress(addressTextLayout!) else {
            return
        }
        prepareConnection(address: ipAddressTextField.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? SvmkViewController else {
            return
        }
        guard let ipAddress = self.selectedIpAddress else {
            return
        }
        destinationViewController.selectedIpAddress = ipAddress
    }
    
    func prepareConnection(address: String) {
        miHelper.sendHello(address: address) { (object) in
            let message = object as? String
            if message == MI_message.ack0.rawValue {
                let snackBar = MDCSnackbarMessage()
                snackBar.text = "Conectado"
                MDCSnackbarManager.show(snackBar)
                
                self.selectedIpAddress = address
                self.performSegue(withIdentifier: "discovery_to_svmk", sender: self)
            }
            else {
                print("message: \(message)")
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
//        self.selectedIpAddress = cell.ipAddress
        //perfome segue
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
        if textField == ipAddressTextField {
            let _ = AppUtil.validIPAdress(addressTextLayout!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case ipAddressTextField:
            ipAddressTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case ipAddressTextField:
            addressTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            break
        }
    }
}
