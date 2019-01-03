//
//  RequestType.swift
//  VK
//
//  Created by Maxim Tolstikov on 03/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation
import VK_ios_sdk

enum RequestType: FinalURLPoint {    
    
    case UserData()
    
    var id: NSNumber? {
        return VKSdk.accessToken()?.localUser.id
    }
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    var baseURL: URL {
        return URL(string: "https://api.vk.com")!
    }
    var version: String {
        return "&v=5.71"
    }
    
    var path: String? {
        
        guard let id = self.id,
           let token = self.token else {
            assertionFailure()
            return nil }
        
        switch self {
        case .UserData():
            let method = "users.get"
            let parametrs = "photo_100"
            return "/method/\(method)?user_id=\(id)&access_token=\(token)&fields=\(parametrs)\(self.version)"
        }
    }
    var request: URLRequest? {
        
        guard let path = self.path else {
            assertionFailure()
            return nil
        }
        let url = URL(string: path, relativeTo: baseURL)!
        
        return URLRequest(url: url)
    }
}
