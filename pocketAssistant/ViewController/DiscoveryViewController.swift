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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //TODO:
//        stopSession()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO
//        miHelper.setupNetworkCommunication(address: "10.61.53.225")
    }
    
    ////////
    // Add a trusted root CA to out SecTrust object
    func addAnchorToTrust(trust: SecTrust, certificate: SecCertificate) -> SecTrust {
        let array: NSMutableArray = NSMutableArray()
        
        array.add(certificate)
        
        SecTrustSetAnchorCertificates(trust, array)
        
        return trust
    }
    
    // Create a SecCertificate object from a DER formatted certificate file
    func createCertificateFromFile(filename: String, ext: String) -> SecCertificate {
        let rootCertPath = Bundle.main.path(forResource:filename, ofType: ext)
        
        let rootCertData = NSData(contentsOfFile: rootCertPath!)
        
        return SecCertificateCreateWithData(kCFAllocatorDefault, rootCertData!)!
    }
    
    /////////
    
    
    @IBAction func didTapTryAgain(_ sender: Any) {
        print("CLICOU")
    }
    
    @IBAction func didTapConnect(_ sender: Any) {
        miHelper.serviceStartProcess(address: "10.61.53.225", initKey: "12345678") { (object) in
            let message = object as! String
            print("AQUI: \(message)")
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
        
//        miHelper.sendMessage(message: MI_message.hello) { (message) in
//            print("Recebido: \(message)")
//        }
        
//        performSegue(withIdentifier: "discovery_to_svmk", sender: self)
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
