//
//  Body1.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public struct ResponseBody1: Codable {
    public var token: String
    public var cid: Int
    public var pwd_expired: Int
}

//
public struct ResponseBody2: Codable {
    public var obj: [String]
}

//Probe
public struct ResponseBody3: Codable {
    public var probe_str: String
}

//
public struct ResponseBody4: Codable {
    public var usr: [String]
}

//
public struct ResponseBody5: Codable {
    public var trust: [item]
}

public struct item: Codable {
    public var acl: Int
    public var usr: String
}

//
public struct ResponseBody6: Codable {
    public var acl: Int
}

//
public struct ResponseBody7: Codable {
    public var version: Int
    public var type: Int
    public var attr: Int
}

//
struct aclStruct: OptionSet {
    let rawValue: UInt32
    static let obj_del =            aclStruct(rawValue: 1 << 0)
    static let obj_read =           aclStruct(rawValue: 1 << 1)
    static let obj_create =         aclStruct(rawValue: 1 << 2)
    static let obj_update =         aclStruct(rawValue: 1 << 3)
    static let usr_write =          obj_update
    static let usr_create =         aclStruct(rawValue: 1 << 4)
    static let usr_delete =         usr_create
    static let usr_remote_log =     aclStruct(rawValue: 1 << 5)
    static let usr_list =           aclStruct(rawValue: 1 << 6)
    static let sys_operator =       aclStruct(rawValue: 1 << 7)
    static let sys_backup =         aclStruct(rawValue: 1 << 8)
    static let sys_restore =        sys_backup
    static let sys_update_hsm =     aclStruct(rawValue: 1 << 9)
    static let ns_authorization =   aclStruct(rawValue: 1 << 10)
    static let virtual_x509_auth =  aclStruct(rawValue: 1 << 28)
    static let virtual_otp_auth =   aclStruct(rawValue: 1 << 29)
    static let change_pwd_next_time = aclStruct(rawValue: 1 << 30)
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
//#define ACL_DEFAULT_OWNER ( ACL_OBJ_DEL | ACL_OBJ_READ | ACL_OBJ_CREATE | \
//ACL_OBJ_UPDATE |ACL_OBJ_WRITE \
//)

