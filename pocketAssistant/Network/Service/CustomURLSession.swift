////
////  CustomURLSession.swift
////  pocketAssistant
////
////  Created by William Simiao on 31/07/19.
////  Copyright © 2019 William Simiao. All rights reserved.
////
//
//import Foundation
//
//class CustomURLSession: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//            print("Olha o IP \(challenge.protectionSpace.host)")
//            if(challenge.protectionSpace.host == "10.61.53.209") {
//                let secTrust = challenge.protectionSpace.serverTrust
//                let credential = URLCredential(trust: secTrust!)
//                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
//            }
//        }
//    }
//
//    //    typealias CallbackBlock = (_ result: String, _ error: String?) -> ()
//    //    var callback: CallbackBlock = {
//    //        (resultString, error) -> Void in
//    //        if error == nil {
//    //            print(resultString)
//    //        } else {
//    //            print(error)
//    //        }
//    //    }
//    //
//    //    func httpGet(request: NSMutableURLRequest!, callback: (String,
//    //        String?) -> Void) {
//    //        var configuration =
//    //            URLSessionConfiguration.default
//    //        var session = URLSession(session: configuration,
//    //                                 didReceiveChallenge: self,
//    //                                 completionHandler:OperationQueue.mainQueue())
//    //        var task = session.dataTaskWithRequest(request){
//    //            (data: NSData!, response: URLResponse!, error: NSError!) -> Void in
//    //            if error != nil {
//    //                callback("", error.localizedDescription)
//    //            } else {
//    //                var result = NSString(data: data, encoding:
//    //                    NSASCIIStringEncoding)!
//    //                callback(result, nil)
//    //            }
//    //        }
//    //        task.resume()
//    //    }
//    //    func URLSession(session: URLSession,
//    //                    didReceiveChallenge challenge:
//    //        URLAuthenticationChallenge,
//    //                    completionHandler:
//    //        (URLSession.AuthChallengeDisposition,
//    //        URLCredential?) -> Void) {
//    //        completionHandler(
//    //            URLSession.AuthChallengeDisposition.UseCredential,
//    //            URLCredential(forTrust:
//    //                challenge.protectionSpace.serverTrust))
//    //    }
//    //
//    //    func URLSession(session: URLSession,
//    //                    task: URLSessionTask,
//    //                    willPerformHTTPRedirection response:
//    //        HTTPURLResponse,
//    //                    newRequest request: NSURLRequest,
//    //                    completionHandler: (NSURLRequest?) -> Void) {
//    //        var newRequest : NSURLRequest? = request
//    //        print(newRequest?.description)
//    //        completionHandler(newRequest)
//    //    }
//}
