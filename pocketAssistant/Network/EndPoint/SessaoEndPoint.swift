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
    case probe(token: String)
}

extension SessaoApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://hsmlab64.dinamonetworks.com/api"
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
        case .probe:
            return "probe"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .auth:
            return .post
        case .close:
            return .post
        case .probe:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .auth(let usr, let pwd):
            return .requestParameters(bodyParameters: ["usr":usr, "pwd":pwd], urlParameters: nil)
            
        case .close(let token):
            return .requestParametersAndHeaders(bodyParameters: [:], urlParameters: nil, additionHeaders: ["Authorization": token])
        case .probe(let token):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: ["Authorization": token])
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

