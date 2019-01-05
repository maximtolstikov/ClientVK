//
//  NetworkService.swift
//  VK
//
//  Created by Maxim Tolstikov on 27/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import Foundation
import RealmSwift

class LoadMyData: ApiManager {
    
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
    
    func load() {
        
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
        
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL?.absoluteString ?? "")
            
            try realm.write {
                realm.add(user, update: true)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
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
