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
    case start = "MI_SVC_START\n"
    case stop = "MI_SVC_STOP\n"
    case auth = "MI_MINI_AUTH"
    case close = "MI_CLOSE\n"
    case post = "MI_ACK 00000000\n"
}

class MIHelper: NSObject {
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    let maxReadLength = 4096
    var currentHandler: ((String?) -> Void)?

    func setupNetworkCommunication(address: String) {
        
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
    
    func sendMessage(message: MI_message, completionHandler: @escaping (String?) -> Void) {
        currentHandler = completionHandler
        
        var messageString = message.rawValue
        if message == MI_message.auth {
            guard let initKey = KeychainWrapper.standard.string(forKey: "INIT_KEY") else {
                print("NO 'INIT_KEY' on user keychain")
                return
            }
            
            messageString = "\(messageString) \(initKey)\n"
        }
        
        let data = messageString.data(using: .utf8)!
        _ = data.withUnsafeBytes { (unsafePointer:UnsafePointer<UInt8>) in
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
            if let message =
                processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                // Notify interested parties
                currentHandler!(message)
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
                print("Error reading buffer")
                return nil
        }
        return message
    }
}
