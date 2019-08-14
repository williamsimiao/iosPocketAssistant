//
//  MIHelper.swift
//  pocketAssistant
//
//  Created by William Simiao on 08/08/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import SocketIO
import SwiftKeychainWrapper

public enum MI_message : String {
    case hello = "MI_HELLO\n"
    case isFirstBoot = "MI_FIRST_BOOT\n"
    case start = "MI_SVC_START\n"
    case stop = "MI_SVC_STOP\n"
    case status = "MI_SVC_STATUS\n"
    case auth = "MI_MINI_AUTH"
    case close = "MI_CLOSE\n"
    case ack0 = "MI_ACK 00000000 \n"
    case ack1 = "MI_ACK 00000001 \n"
}

class MIHelper: NSObject {
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    let maxReadLength = 4096
//    var currentSendedMessage: MI_message?
//    var currentHandler: ((Any?) -> Void)?
    
    var list = [(mesage: MI_message, handler: ((Any?) -> Void))]()
    
    func serviceStartProcess(address: String, initKey: String, completionHandler: @escaping (Any?) -> Void) {
        setupNetworkCommunication(address: address)
        let authCompletedHandler = { (message: Any?) -> Void in
            self.sendMessage(message: .start, parameter: nil, completionHandler: completionHandler)
        }
        sendMessage(message: .auth, parameter: initKey, completionHandler: authCompletedHandler)
    }
    
    func isServiceStarted(completionHandler: @escaping (Any?) -> Void) {
        sendMessage(message: .status, parameter: nil, completionHandler: completionHandler)
    }
    
    func sendHello(address: String, completionHandler: @escaping (Any?) -> Void) {
        setupNetworkCommunication(address: address)
        sendMessage(message: .hello, parameter: nil, completionHandler: completionHandler)
    }
    
    private func setupNetworkCommunication(address: String) {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           address as CFString,
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
    
    private func sendMessage(message: MI_message, parameter: String?, completionHandler: @escaping (Any?) -> Void) {
//        currentSendedMessage = message
//        currentHandler = completionHandler
        let tuple = (message, completionHandler)
        list.append(tuple)
        
        var messageString = message.rawValue
        
        if parameter != nil {
            print("Adicionou parametro")
            messageString = "\(messageString) \(parameter!)\n"
        }
        
        let data = messageString.data(using: .utf8)!
        _ = data.withUnsafeBytes { (unsafePointer:UnsafePointer<UInt8>) in
            _ = self.outputStream?.write(unsafePointer, maxLength: data.count)
            
            //            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
            //                print("Error joining chat")
            //                return
            //            }
            //            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    private func stopSession() {
        print("Fechou a sessão")
        inputStream.close()
        outputStream.close()
    }

}

extension MIHelper: StreamDelegate {
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
            if let receivedMessage = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                // Notify interested parties
                callHandler(receivedMessage: receivedMessage)
            }
            
        }
    }
    
    private func callHandler(receivedMessage: String) {
        guard list.isEmpty == false else {
            print("Empity list")
            return
        }
        
        let currentTuple = list.removeFirst()
        let currentSendedMessage = currentTuple.mesage
        let currentHandler = currentTuple.handler
        switch currentSendedMessage {
        case .isFirstBoot, .status:
            if receivedMessage == MI_message.ack0.rawValue {
                currentHandler(false)
            }
            else {
                currentHandler(true)
            }
        case .auth, .start:
            if receivedMessage == MI_message.ack0.rawValue {
                currentHandler(true)
            }
            else {
                currentHandler(receivedMessage)
            }

        default:
            currentHandler(receivedMessage)
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
                print("Error reading buffer")
                return nil
        }
        return message
    }
}
