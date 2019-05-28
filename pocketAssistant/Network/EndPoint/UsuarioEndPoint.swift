//
//  UsuarioEndPoint.swift
//  pocketAssistant
//
//  Created by William Simiao on 28/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public enum UsuariosApi {
    case changePwd(token: String, pwd: String)
}

extension UsuariosApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://hsmlab63.dinamonetworks.com/api"
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
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .changePwd:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .changePwd(let token, let pwd):
            return .requestParametersAndHeaders(bodyParameters: ["pwd":pwd], urlParameters: nil, additionHeaders: ["Authorization": token])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
