//
//  EndPointType.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//
import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
