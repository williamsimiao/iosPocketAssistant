//
//  NetworkManager.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to authenticate first"
    case badRequest = "Bad request"
    case outdated = "The url is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    private let sessaoRouter = Router<SessaoApi>()
    private let objetosRouter = Router<ObjetosApi>()
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    //OBJS
    func runListObjs(token: String, completion: @escaping (_ body2:ResponseBody2?,_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        print("complete TOKEN: \(completeToken)")
        objetosRouter.request(.listObjs(token: completeToken)) { (data, response, error) in
            if error != nil {
                completion(nil, "Check your internet connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody2.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    func runClose(token: String, completion: @escaping (_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        sessaoRouter.request(.close(token: completeToken)) { (data, response, error) in
            if error != nil {
                completion("Check your internet connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    //responseData is empty
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
        }
    }
    
    func runAuth(usr: String, pwd: String, completion: @escaping (_ body1:ResponseBody1?,_ error: String?)->()) {
        sessaoRouter.request(.auth(usr: usr, pwd: pwd)) { (data, response, error) in
            if error != nil {
                completion(nil, "Check your internet connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody1.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
