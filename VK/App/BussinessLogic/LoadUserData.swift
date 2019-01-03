//
//  NetworkService.swift
//  VK
//
//  Created by Maxim Tolstikov on 27/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import Foundation

class LoadUserData: ApiManager {
    
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfiguration)
    }()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchUserData(completionHandler: @escaping (ApiResult<User>) -> Void) {
        
        guard let request = RequestType.UserData().request else {
            assertionFailure()
            return }
        
        fetch(request: request, parse: { (data) -> User? in
            
            do {
                let responseInfo = try JSONDecoder().decode(UserService.self, from: data)
                let user = responseInfo.response.first
                return user
                
            } catch (let error) {
                print(error.localizedDescription)
                return nil
            }
            
        }, completionHandler: completionHandler)
    }

}
