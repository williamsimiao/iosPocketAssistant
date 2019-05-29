//
//  URLSession+synchronous.swift
//  pocketAssistant
//
//  Created by William on 28/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
extension URLSession {
    func synchronousDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        completionHandler(data, response, error)
    }
    
    
    //
//    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
//        var data: Data?
//        var response: URLResponse?
//        var error: Error?
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        let dataTask = self.dataTask(with: urlrequest) {
//            data = $0
//            response = $1
//            error = $2
//
//            semaphore.signal()
//        }
//        dataTask.resume()
//
//        _ = semaphore.wait(timeout: .distantFuture)
//
//        return (data, response, error)
//    }
}
