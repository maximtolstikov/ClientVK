//
//  User.swift
//  VK
//
//  Created by Maxim Tolstikov on 27/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

struct User: Decodable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var photo: String
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_100"
    }
}

struct UserService: Decodable {
    
    let response: [User]
}

extension User {

    var fullName: String {
        return self.firstName + " " + self.lastName
    }
}


