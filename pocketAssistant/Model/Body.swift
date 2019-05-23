//
//  Body.swift
//  pocketAssistant
//
//  Created by William Simiao on 22/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public struct Body {
    
    /** O ID do usuário no HSM */
    public var usr: String
    
    /** A senha do usuário no HSM */
    public var pwd: String
    
    /** OTP (opcional) */
    public var otp: String
    
}

enum BodyCodingKeys: String, CodingKey {
    case usr
    case pdw
    case otp
}

extension Body: Codable {

    public init(from decoder: Decoder) throws {
        let bodyContainer = try decoder.container(keyedBy: BodyCodingKeys.self)
        usr = try bodyContainer.decode(String.self, forKey: .usr)
        pwd = try bodyContainer.decode(String.self, forKey: .pdw)
        
        do {
            otp = try bodyContainer.decode(String.self, forKey: .otp)
        } catch {
            otp = ""
        }
    }
}
