//
//  ViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class LoginViewController: UIViewController, URLSessionDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
        
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...499:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 500:
            return .failure(NetworkResponse.serverError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func makeRequest() {
        // server endpoint
        let endpoint = URL(string: "https://10.61.53.209/api/auth")
        
        //Make JSON to send to send to server
        var json = [String:Any]()
        
        json["usr"] = "william"
        json["pwd"] = "87654321"
        
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            
            var request = URLRequest(url: endpoint!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    let _ = AppUtil.alertAboutConnectionError()
                }
                if let response = response as? HTTPURLResponse {
                    
                    
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        do {
                            let apiResponse = try JSONDecoder().decode(ResponseBody1.self, from: data!)
                            print("I have a token: \(apiResponse.token)")
                        } catch {
                            print(NetworkResponse.unableToDecode.rawValue)
                        }
                        
                    case .failure(let networkFailureError):
                        do {
                            let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                            print("ERROR: \(errorResponse)")
                        } catch {
                            print(NetworkResponse.unableToDecode.rawValue)
                        }
                        print(networkFailureError)
                    }
                    
                }
                else {
                    print("OXI")
                }
                
                
            }
            task.resume()
            
        }catch{
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("AQUIIIIII")
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            print("Olha o IP \(challenge.protectionSpace.host)")
//            let myHost = "https://hsmlab64.dinamonetworks.com"
            let myHost = "10.61.53.209"
            if(challenge.protectionSpace.host == myHost) {
                print("CHEGOU")
                let secTrust = challenge.protectionSpace.serverTrust
                let credential = URLCredential(trust: secTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }
    }
}

