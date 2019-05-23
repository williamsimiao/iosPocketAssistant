//
//  JSONParameterEncoder.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let jsonString = String(data: jsonAsData, encoding: String.Encoding.ascii)!
            print("body:")
            print(jsonString)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
