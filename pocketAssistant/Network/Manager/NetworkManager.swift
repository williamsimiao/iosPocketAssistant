//
//  NetworkManager.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to authenticate first"
    case badRequest = "Bad request"
    case outdated = "The url is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
    case serverError = "Internal Server error"
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    private let sessaoRouter = Router<SessaoApi>()
    private let objetosRouter = Router<ObjetosApi>()
    private let usuarioRouter = Router<UsuariosApi>()
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
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
    
    
    // MARK: - UsuarioApi
    func runGetAcl(myDelegate: URLSessionDelegate, token: String, usr: String, completion: @escaping (_ body1:ResponseBody6?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.getAcl(token: completeToken, usr: usr), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody6.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    func runUpdateAcl(myDelegate: URLSessionDelegate, token: String, acl: Int, usr: String, completion: @escaping (_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        usuarioRouter.request(.updateAcl(token: completeToken, acl: acl, usr: usr), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                //responseData is empty
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    func runListUsrsTrust(myDelegate: URLSessionDelegate, token: String, op: Int, usr: String, completion: @escaping (_ body1:ResponseBody5?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.listUsrTrust(token: completeToken, op: op, usr: usr), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody5.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
    
    func runListUsrs(myDelegate: URLSessionDelegate, token: String, completion: @escaping (_ body1:ResponseBody4?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.listUsrs(token: completeToken), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody4.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
    
    func runCreateUsr(myDelegate: URLSessionDelegate, token: String, usr: String, pwd: String, acl: Int, completion: @escaping (_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        usuarioRouter.request(.createUsr(token: completeToken, usr: usr, pwd: pwd, acl: acl), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                //responseData is empty
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    func runChangePwd(myDelegate: URLSessionDelegate, token: String, newPwd: String, completion: @escaping (_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        usuarioRouter.request(.changePwd(token: completeToken, pwd: newPwd), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                //responseData is empty
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    // MARK: - ObjetosApi
    
    func runObjExp(myDelegate: URLSessionDelegate, objId: String, token: String, completion: @escaping (_ body2:CFData?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        objetosRouter.request(.objExp(token: completeToken, obj: objId), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        print(NetworkResponse.noData.rawValue)
                        return
                    }
                    completion(responseData as CFData, nil)
                    
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    func runGetObjInfo(myDelegate: URLSessionDelegate, objId: String, token: String, completion: @escaping (_ body2:ResponseBody7?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        objetosRouter.request(.getObjInfo(token: completeToken, obj: objId), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody7.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
    
    func runListObjs(myDelegate: URLSessionDelegate, token: String, completion: @escaping (_ body2:ResponseBody2?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"

        objetosRouter.request(.listObjs(token: completeToken), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody2.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }

                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }

    //SessaoApi
    func runProbeSynchronous(myDelegate: URLSessionDelegate, token: String, completion: @escaping (_ body1:ResponseBody3?,_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"
        sessaoRouter.request(.probe(token: completeToken), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let mErroBody = errorBody(rc: 0, rd: "ERR_NO_CONNECTION")
                completion(nil, mErroBody)
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody3.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
    
    func runClose(myDelegate: URLSessionDelegate, token: String, completion: @escaping (_ error: errorBody?)->()) {
        let completeToken = "HSM \(token)"
        sessaoRouter.request(.close(token: completeToken), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    //responseData is empty
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
    
    func runAuth(myDelegate: URLSessionDelegate, usr: String, pwd: String, completion: @escaping (_ body1:ResponseBody1?,_ error: errorBody?)->()) {
        sessaoRouter.request(.auth(usr: usr, pwd: pwd), myDelegate: myDelegate) { (data, response, error) in
            if error != nil {
                let _ = AppUtil.alertAboutConnectionError()
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(ResponseBody1.self, from: data!)
                        completion(apiResponse, nil)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    do {
                        let errorResponse = try JSONDecoder().decode(errorBody.self, from: data!)
                        completion(nil, errorResponse)
                    } catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                    print(networkFailureError)
                }
            }
        }
    }
}
