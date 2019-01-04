//
//  User.swift
//  VK
//
//  Created by Maxim Tolstikov on 27/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import Realm
import RealmSwift

@objcMembers class User: Object, Decodable {
    
    dynamic var id: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photo: String = ""
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_200"
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idJson = try container.decode(Int.self, forKey: .id)
        id = String(idJson)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        photo = try container.decode(String.self, forKey: .photo)
        
        super.init()
    }
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    required init()
    {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema)
    {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema)
    {
        super.init(realm: realm, schema: schema)
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


