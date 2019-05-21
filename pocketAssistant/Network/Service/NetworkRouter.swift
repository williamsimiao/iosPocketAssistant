//
//  NetworkRouter.swift
//  pocketAssistant
//
//  Created by William Simiao on 14/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
