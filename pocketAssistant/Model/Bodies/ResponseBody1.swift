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
