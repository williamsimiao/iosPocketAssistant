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
    case createUsr(token: String, usr: String, pwd: String, acl: Int)
    case listUsrs(token: String)
}

//#define ACL_NOP                 (0x00000000)       // "may the Force be with ya'!"
//#define ACL_OBJ_DEL             (ACL_NOP + 1)      // delete objects
//#define ACL_OBJ_READ            (ACL_OBJ_DEL << 1) // read obj content
//#define ACL_OBJ_LIST            (ACL_OBJ_READ)     // list usr objs
//#define ACL_OBJ_CREATE          (ACL_OBJ_DEL << 2) // create obj
//#define ACL_OBJ_UPDATE          (ACL_OBJ_DEL << 3) // update obj (hdr and alike)
//#define ACL_OBJ_WRITE           (ACL_OBJ_UPDATE)   // update obj
//#define ACL_USR_CREATE          (ACL_OBJ_DEL << 4) // create usr
//#define ACL_USR_DELETE          (ACL_USR_CREATE)   // makes no sense only to create
//#define ACL_USR_REMOTE_LOG      (ACL_OBJ_DEL << 5) // can usr use remote log/info?
//#define ACL_USR_LIST            (ACL_OBJ_DEL << 6) // can usr get user-list?
//#define ACL_SYS_OPERATOR        (ACL_OBJ_DEL << 7) // operate as master (adm mode)
//#define ACL_SYS_BACKUP          (ACL_OBJ_DEL << 8) // extract full appliance backup
//#define ACL_SYS_RESTORE         (ACL_SYS_BACKUP)   // restore full appliance backup
//#define ACL_SYS_UDATE_HSM       (ACL_OBJ_DEL << 9) // firmware and stuff like that
//#define ACL_NS_AUTHORIZATION    (ACL_OBJ_DEL << 10) // user must be authorized with "m of n"
//#define ACL_VIRTUAL_X509_AUTH    (ACL_OBJ_DEL << 28) // presence means SA (user must use 2F PKI)
//#define ACL_VIRTUAL_OTP_AUTH    (ACL_OBJ_DEL << 29) // presence means SA (user must use 2-F OTP)
//#define ACL_CHANGE_PWD_NEXT_TIME (ACL_OBJ_DEL << 30) // can force usrs to change pwd on next login
//
//
//#define ACL_DEFAULT_OWNER ( ACL_OBJ_DEL | ACL_OBJ_READ | ACL_OBJ_CREATE | \
//ACL_OBJ_UPDATE |ACL_OBJ_WRITE \
//)

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
        case .createUsr:
            return "create_usr"
        case .listUsrs:
            return "list_usrs"
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
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
