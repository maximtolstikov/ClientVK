//
//  LoadMyFriendsData.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation
import RealmSwift

class LoadMyFriendsData: ApiManager {
    
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
        
        let realmManager = RealmManager()
        
        realmManager?.saveCollection(friends)
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

