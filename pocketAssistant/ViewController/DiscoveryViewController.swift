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

    var inputStream: InputStream!
    var outputStream: OutputStream!
    let maxReadLength = 4096
    let manager = SocketManager(socketURL: URL(string: "http://10.61.53.209:3344")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNetworkCommunication()
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
    
    func setupNetworkCommunication() {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "10.61.53.225" as CFString,
                                           3344,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .default)
        outputStream.schedule(in: .current, forMode: .default)
        
        /////////
        // Enable SSL/TLS on the streams
        inputStream!.setProperty(kCFStreamSocketSecurityLevelNegotiatedSSL, forKey:  Stream.PropertyKey.socketSecurityLevelKey)
        outputStream!.setProperty(kCFStreamSocketSecurityLevelNegotiatedSSL, forKey: Stream.PropertyKey.socketSecurityLevelKey)
        
        
        // Defin custom SSL/TLS settings
        let sslSettings : [NSString: Any] = [
            // NSStream automatically sets up the socket, the streams and creates a trust object and evaulates it before you even get a chance to check the trust yourself. Only proper SSL certificates will work with this method. If you have a self signed certificate like I do, you need to disable the trust check here and evaulate the trust against your custom root CA yourself.
            NSString(format: kCFStreamSSLValidatesCertificateChain): kCFBooleanFalse,
            //
            NSString(format: kCFStreamSSLPeerName): kCFNull,
            // We are an SSL/TLS client, not a server
            NSString(format: kCFStreamSSLIsServer): kCFBooleanFalse
        ]
        
        // Set the SSL/TLS settingson the streams
        inputStream!.setProperty(sslSettings, forKey:  kCFStreamPropertySSLSettings as Stream.PropertyKey)
        outputStream!.setProperty(sslSettings, forKey: kCFStreamPropertySSLSettings as Stream.PropertyKey)


        /////////
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendMessageRay(message: String) {
        let data = message.data(using: .utf8)!
        _ = data.withUnsafeBytes { (unsafePointer:UnsafePointer<UInt8>) in
            print("Mandando mensagem")
            _ = self.outputStream?.write(unsafePointer, maxLength: data.count);

//            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
//                print("Error joining chat")
//                return
//            }
//            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func stopSession() {
        print("Fechou a sessão")
        inputStream.close()
        outputStream.close()
    }
    /////////
    
    
    @IBAction func didTapTryAgain(_ sender: Any) {
        print("CLICOU")
        sendMessageRay(message: "MI_HELLO\n")
    }
    
    
    @IBAction func didTapConnect(_ sender: Any) {
        stopSession()
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

extension DiscoveryViewController: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("Open Completed")
        case .hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            print("new message received END")
            stopSession()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
            
            // If you try and obtain the trust object (aka kCFStreamPropertySSLPeerTrust) before the stream is available for writing I found that the oject is always nil!
            var sslTrustInput: SecTrust? =  inputStream! .property(forKey:kCFStreamPropertySSLPeerTrust as Stream.PropertyKey) as! SecTrust?
            var sslTrustOutput: SecTrust? = outputStream!.property(forKey:kCFStreamPropertySSLPeerTrust as Stream.PropertyKey) as! SecTrust?
            
            if (sslTrustInput == nil) {
                print("INPUT TRUST NIL")
            }
            else {
                print("INPUT TRUST NOT NIL")
            }
            
            if (sslTrustOutput == nil) {
                print("OUTPUT TRUST NIL")
            }
            else {
                print("OUTPUT TRUST NOT NIL")
            }
            
            // Get our certificate reference. Make sure to add your root certificate file into your project.
            let rootCert: SecCertificate? = createCertificateFromFile(filename: "ca", ext: "der")
            
            // TODO: Don't want to keep adding the certificate every time???
            // Make sure to add your trusted root CA to the list of trusted anchors otherwise trust evaulation will fail
            sslTrustInput  = addAnchorToTrust(trust: sslTrustInput!,  certificate: rootCert!)
            sslTrustOutput = addAnchorToTrust(trust: sslTrustOutput!, certificate: rootCert!)
            
            // convert kSecTrustResultUnspecified type to SecTrustResultType for comparison
            var result: SecTrustResultType = SecTrustResultType.unspecified
            
            // This is it! Evaulate the trust.
            let error: OSStatus = SecTrustEvaluate(sslTrustInput!, &result)
            
            // An error occured evaluating the trust check the OSStatus codes for Apple at osstatus.com
            if (error != noErr) {
                print("Evaluation Failed")
            }
            
            if (result != SecTrustResultType.proceed && result != SecTrustResultType.unspecified) {
                // Trust failed. This will happen if you faile to add the trusted anchor as mentioned above
                print("Peer is not trusted :(")
            }
            else {
                // Peer certificate is trusted. Now we can send data. Woohoo!
                print("Peer is trusted :)")
            }
            
            
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        //2
        while stream.hasBytesAvailable {
            //3
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            //4
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            
            // Construct the Message object
            if let message =
                processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                // Notify interested parties
                print("MESSAGE: \(message) FIM")
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> String? {
        guard
            let message = String(
                bytesNoCopy: buffer,
                length: length,
                encoding: .utf8,
                freeWhenDone: false)
            else {
                print("RUIM 1")
                return nil
        }
        return message
    }
}
