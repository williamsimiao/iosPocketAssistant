//
//  NetworkError.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
public enum inputError : String, Error {
    case stringNil = "Empty String"
    case invalidString = "invalid String"
}

public enum NetworkError : String, Error {
    case parameterNil = "Parameter were nil"
    case encodingFailed = "Parameters encoding failed"
    case missingURL = "URL is nil"
}
