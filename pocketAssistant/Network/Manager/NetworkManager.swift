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

    func promptErrorToUser(resultCode: Result<String>) {
        DispatchQueue.main.async {
            let message: String?
            let title: String?
            switch resultCode {
            case .failure(NetworkResponse.authenticationError.rawValue):
                title = "Credenciais invalidas"
                message = "Faça o login novamente"
            default:
                title = "Erro"
                message = ""
            }
            guard let aTitle = title else {
                return
            }
            guard let aMessage = message else {
                return
            }
            
            
            let alertController = MDCAlertController(title: aTitle, message: aMessage)
            let action = MDCAlertAction(title: "OK", handler: nil)
            alertController.addAction(action)
            alertController.applyTheme(withScheme: globalContainerScheme())
            
            
            let stor = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = stor.instantiateViewController(withIdentifier: "MainViewController")
            let currentViewController = AppUtil().currentView()
            
            if currentViewController.isKind(of: MainViewController.self) {
                
                currentViewController.present(alertController, animated: true, completion: nil)
            }
            else {
                
                currentViewController.present(mainViewController, animated: true, completion: { () in
                    let newCurrentViewCOntroller = AppUtil().currentView()
                    newCurrentViewCOntroller.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            promptErrorToUser(resultCode: .failure(NetworkResponse.authenticationError.rawValue))
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            promptErrorToUser(resultCode: .failure(NetworkResponse.badRequest.rawValue))
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            promptErrorToUser(resultCode: .failure(NetworkResponse.outdated.rawValue))
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            promptErrorToUser(resultCode: .failure(NetworkResponse.failed.rawValue))
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    
    //UsuarioApi
    func runGetAcl(token: String, usr: String, completion: @escaping (_ body1:ResponseBody6?,_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.getAcl(token: completeToken, usr: usr)) { (data, response, error) in
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
                        let apiResponse = try JSONDecoder().decode(ResponseBody6.self, from: responseData)
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
    
    func runUpdateAcl(token: String, acl: Int, usr: String, completion: @escaping (_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        print("complete TOKEN: \(completeToken)")
        usuarioRouter.request(.updateAcl(token: completeToken, acl: acl, usr: usr)) { (data, response, error) in
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
    
    func runListUsrsTrust(token: String, op: Int, usr: String, completion: @escaping (_ body1:ResponseBody5?,_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.listUsrTrust(token: completeToken, op: op, usr: usr)) { (data, response, error) in
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
                        let apiResponse = try JSONDecoder().decode(ResponseBody5.self, from: responseData)
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
    
    func runListUsrs(token: String, completion: @escaping (_ body1:ResponseBody4?,_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        usuarioRouter.request(.listUsrs(token: completeToken)) { (data, response, error) in
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
                        let apiResponse = try JSONDecoder().decode(ResponseBody4.self, from: responseData)
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
    
    func runCreateUsr(token: String, usr: String, pwd: String, acl: Int, completion: @escaping (_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        print("complete TOKEN: \(completeToken)")
        usuarioRouter.request(.createUsr(token: completeToken, usr: usr, pwd: pwd, acl: acl)) { (data, response, error) in
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
    
    func runChangePwd(token: String, newPwd: String, completion: @escaping (_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        print("complete TOKEN: \(completeToken)")
        usuarioRouter.request(.changePwd(token: completeToken, pwd: newPwd)) { (data, response, error) in
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
    
    //ObjetosApi
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
    
    //SessaoApi
    func runProbeSynchronous(token: String, completion: @escaping (_ body1:ResponseBody3?,_ error: String?)->()) {
        let completeToken = "HSM \(token)"
        sessaoRouter.synchronousRequest(.probe(token: completeToken)) { (data, response, error) in
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
                        let apiResponse = try JSONDecoder().decode(ResponseBody3.self, from: responseData)
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
