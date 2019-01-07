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
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfiguration)
    }()
    
    required init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    required convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func load(completionHandler: @escaping () -> Void) {
        
    }
    

    
}
