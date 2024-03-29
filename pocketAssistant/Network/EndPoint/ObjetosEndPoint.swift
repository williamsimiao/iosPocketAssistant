//
//  MovieEndPoint.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public enum ObjetosApi {
    case listObjs(token: String)
    case getObjInfo(token: String, obj: String)
    case objExp(token: String, obj: String)
}

extension ObjetosApi: EndPointType {
    
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
        case .listObjs:
            return "list_objs"
        case .getObjInfo:
            return "get_obj_info"
        case .objExp:
            return "obj_exp"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .listObjs:
            return .get
        case .getObjInfo:
            return .post
        case .objExp:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .listObjs(let token):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: ["Authorization": token])
            
        case .getObjInfo(let token, let obj):
            return .requestParametersAndHeaders(bodyParameters: ["obj": obj], urlParameters: nil, additionHeaders: ["Authorization": token])
            
        case .objExp(let token, let obj):
            return .requestParametersAndHeaders(bodyParameters: ["obj": obj], urlParameters: nil, additionHeaders: ["Authorization": token])
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

