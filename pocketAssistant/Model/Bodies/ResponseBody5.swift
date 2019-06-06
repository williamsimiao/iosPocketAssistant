//
//  ResponseBody5.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
public struct ResponseBody5: Codable {
    public var trust: [item]
}

public struct item: Codable {
    public var acl: Int
    public var usr: String
}

