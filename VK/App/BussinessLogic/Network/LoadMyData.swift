//
//  NetworkService.swift
//  VK
//
//  Created by Maxim Tolstikov on 27/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import Foundation
import RealmSwift

class LoadMyData: AbstractLoadData {
    
    var sessionConfiguration: URLSessionConfiguration
    var realm: AbstractRealmManager
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfiguration)
    }()
    
    
    required init(sessionConfiguration: URLSessionConfiguration,
                  realm: AbstractRealmManager) {
        self.sessionConfiguration = sessionConfiguration
        self.realm = realm
    }
    
    required convenience init(realm: AbstractRealmManager) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, realm: realm)
    }
    
    func load(completionHandler: @escaping () -> Void) {
        
        fetchUserData { [weak self] (result) in
            
            switch result {
            case .Success(let user):
                self?.saveToBase(user: user)
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveToBase(user: User) {
       realm.saveObject(user)
    }
    
    private func fetchUserData(completionHandler: @escaping (ApiResult<User>) -> Void) {
        
        guard let request = RequestType.aboutMe.request else {
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
