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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setupNetworkCommunication()
        socketIO()
    }
    
    func socketIO() {
        socket = manager.defaultSocket
        socket.connect()

        socket.on(clientEvent: .connect) {data, ack in
            print("KKKKKKK")
        }
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print("connected")
            self.socket.emit("MI_HELLO ", ["": ""])
        }
        
        socket.on("MI_ACK 00000000 ") {data, ack in
            print("Recebeu")
            self.socket.emit("MI_SVC_START 12345678 ", ["": ""])
        }
        
        socket.connect()
    }
    
    
    ////////
    func setupNetworkCommunication() {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "10.61.53.209" as CFString,
                                           3344,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendMessageRay(message: String) {
        //1
        let data = message.data(using: .utf8)!
        
        //3
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            //4
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    /////////
    
    
    @IBAction func didTapTryAgain(_ sender: Any) {
        print("CLICOU")
        self.socket.emit("MI_SVC_START 12345678 ", ["": ""])
//        sendMessageRay(message: "MI_HELLO ")
    }
    
    
    @IBAction func didTapConnect(_ sender: Any) {
        performSegue(withIdentifier: "discovery_to_svmk", sender: self)
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
}

extension DiscoveryViewController: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case .openCompleted:
            print("Open Completed")
        case .endEncountered:
            print("End Encountered")
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
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
                print("message: \(message) fim")
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> String? {
        //1
        guard
            let message = String(
                bytesNoCopy: buffer,
                length: length,
                encoding: .utf8,
                freeWhenDone: false)
            else {
                return nil
        }
        return message
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
