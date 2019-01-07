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
    
    case aboutMe
    case myFriends
    case myGroups
    
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
        
        print("token: \(token)")
        
        switch self {
        case .aboutMe:
            let method = "users.get"
            let parameters = "&fields=photo_50,photo_200_orig,photo_400_orig"
            return "/method/\(method)?user_id=\(id)&access_token=\(token)\(parameters)\(self.version)"
        case .myFriends:
            let method = "friends.get"
            let parameters = "&fields=photo_50,photo_200_orig,photo_400_orig"
            return "/method/\(method)?user_id=\(id)&access_token=\(token)\(parameters)\(self.version)"
        case .myGroups:
            let method = "groups.get"
            let parameters = "&extended=1"
            return "/method/\(method)?user_id=\(id)&access_token=\(token)\(parameters)\(self.version)"
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
