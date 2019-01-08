//
//  LoadMyGroupData.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation
import RealmSwift

class LoadMyGroupsData: AbstractLoadData {
    
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
        
        fetchGroupsData { [weak self] (result) in
            
            switch result {
            case .Success(let groups):
                self?.saveToBase(groups: groups)
                completionHandler()
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveToBase(groups: [Group]) {
        realm.saveCollection(groups)
    }
    
    private func fetchGroupsData(completionHandler: @escaping (ApiResult<[Group]>) -> Void) {
        
        guard let request = RequestType.myGroups.request else {
            assertionFailure()
            return }

        fetch(request: request, parse: { (data) -> [Group]? in
            
            do {
                let responseInfo = try JSONDecoder().decode(GroupsService.self,
                                                            from: data)
                let groups = responseInfo.response.items
                
                return groups
                
            } catch (let error) {
                print(error.localizedDescription)
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
}
