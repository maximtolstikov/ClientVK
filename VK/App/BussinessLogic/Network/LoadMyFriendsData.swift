//
//  LoadMyFriendsData.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation
import RealmSwift

class LoadMyFriendsData: AbstractLoadData {
    
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
        
        fetchFriendsData { [weak self] (result) in
            
            switch result {
            case .Success(let users):
                self?.saveToBase(friends: users)
                completionHandler()
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveToBase(friends: [User]) {
        realm.saveCollection(friends)
    }
    
    private func fetchFriendsData(completionHandler: @escaping (ApiResult<[User]>) -> Void) {
        
        guard let request = RequestType.myFriends.request else {
            assertionFailure()
            return }
        
        fetch(request: request, parse: { (data) -> [User]? in
            
            do {
                let responseInfo = try JSONDecoder().decode(FriendsService.self, from: data)
                let users = responseInfo.response.items
                
                return users
                
            } catch (let error) {
                print(error.localizedDescription)
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
}

