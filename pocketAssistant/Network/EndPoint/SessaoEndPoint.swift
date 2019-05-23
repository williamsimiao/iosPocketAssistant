//
//  MovieEndPoint.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum SessaoApi {
    case auth(usr: String, pwd: String)
    case close(token: String)
}

extension SessaoApi: EndPointType {
    
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
        case .auth:
            return "auth"
        case .close:
            return "close"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .auth:
            return .post
        case .close:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .auth(let usr, let pwd):
            return .requestParameters(bodyParameters: ["usr":usr, "pwd":pwd], urlParameters: nil)
            
        case .close(let token):
            print("FULL TOKEN: \(token)")
            return .requestParametersAndHeaders(bodyParameters: [:], urlParameters: nil, additionHeaders: ["Authorization": token])
            //TODO: testar
//            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: ["Authorization": autorizationValue])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
//        switch self {
//        case .auth:
//            return nil
//        case .close(let token):
//            let autorizationValue = "HSM" + token
//            print("LOLO: \(autorizationValue)")
//            return ["Authorization": autorizationValue]
//        }
    }
}

