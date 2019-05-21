//
//  ParameterEncoding.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
