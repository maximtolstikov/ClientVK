//
//  ApiManager.swift
//  VK
//
//  Created by Maxim Tolstikov on 03/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

typealias DataTask = URLSessionDataTask
typealias DataCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

protocol FinalURLPoint {
    var id: NSNumber? { get }
    var token: String? { get }
    var baseURL: URL { get }
    var version: String { get }
    var path: String? { get }
    var request: URLRequest? { get }
}

enum ApiResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol ApiManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func dataTaskWith(request: URLRequest,
                      completionHandler: @escaping DataCompletionHandler) -> DataTask
    func fetch<T: Codable>(request: URLRequest,
                                 parse: @escaping (Data) -> T?,
                                 completionHandler: @escaping (ApiResult<T>) -> Void)
}

extension ApiManager {
    
    func dataTaskWith(request: URLRequest, completionHandler: @escaping DataCompletionHandler) -> DataTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [ NSLocalizedDescriptionKey: NSLocalizedString("Missing hhtp response!", comment: "")]
                let error = NSError(domain: APPNetworkingErrorDomain, code: 100, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                        completionHandler(data, HTTPResponse, nil)
         
                default: print("We have response status code: \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest,
                  parse: @escaping (Data) -> T?,
                  completionHandler: @escaping (ApiResult<T>) -> Void) {
        
        let dataTask = dataTaskWith(request: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    if let error = error {
                        completionHandler(.Failure(error))
                    }
                    return
                }
                if let value = parse(data) {
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: APPNetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
