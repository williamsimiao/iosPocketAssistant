//
//  UsuarioEndPoint.swift
//  pocketAssistant
//
//  Created by William Simiao on 28/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public enum UsuariosApi {
    case changePwd(token: String, pwd: String)
    case createUsr(token: String, usr: String, pwd: String, acl: Int)
    case listUsrs(token: String)
    case listUsrTrust(token: String, op: Int, usr: String)
    case updateAcl(token: String, acl: Int, usr: String)
    case getAcl(token: String, usr: String)
}

extension UsuariosApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
            case .production: return "https://\(KeychainWrapper.standard.string(forKey: "BASE_URL")!)/api/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL nao pode ser configurada.")}
        return url
    }
    
    var path: String {
        switch self {
        case .changePwd:
            return "change_pwd"
        case .createUsr:
            return "create_usr"
        case .listUsrs:
            return "list_usrs"
        case .listUsrTrust:
            return "list_usr_trust"
        case .updateAcl:
            return "update_acl"
        case .getAcl:
            return "get_acl"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .changePwd:
            return .post
        case .createUsr:
            return .post
        case .listUsrs:
            return .get
        case .listUsrTrust:
            return .post
        case .updateAcl:
            return .post
        case .getAcl:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .changePwd(let token, let pwd):
            return .requestParametersAndHeaders(bodyParameters: ["pwd":pwd], urlParameters: nil, additionHeaders: ["Authorization": token])
        case .createUsr(let token, let usr, let pwd, let acl):
            return .requestParametersAndHeaders(bodyParameters: ["usr":usr, "pwd":pwd, "acl": acl], urlParameters: nil, additionHeaders: ["Authorization": token])
        case .listUsrs(let token):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: ["Authorization": token])
        case .listUsrTrust(let token, let op, let usr):
            return .requestParametersAndHeaders(bodyParameters: ["op": op, "usr": usr], urlParameters: nil, additionHeaders: ["Authorization": token])
        case .updateAcl(let token, let acl, let usr):
            return .requestParametersAndHeaders(bodyParameters: ["acl": acl, "usr": usr], urlParameters: nil, additionHeaders: ["Authorization": token])
        case .getAcl(let token, let usr):
            return .requestParametersAndHeaders(bodyParameters: ["usr": usr], urlParameters: nil, additionHeaders: ["Authorization": token])

        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
