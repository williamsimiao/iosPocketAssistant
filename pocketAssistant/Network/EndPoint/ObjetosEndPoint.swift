//
//  MovieEndPoint.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public enum ObjetosApi {
    case listObjs(token: String)
}

extension ObjetosApi: EndPointType {
    
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
        case .listObjs:
            return "list_objs"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .listObjs:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .listObjs(let token):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: ["Authorization": token])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
//        switch self {
//        case .listObjs(let token):
//            let autorizationValue = "HSM" + token
//            return ["Authorization":autorizationValue]
//        }
    }
}

