//
//  Group.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Group: Object, Decodable {

    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var photo50: String = ""

    private enum CodingKeys: String, CodingKey {

        case id
        case name = "name"
        case photo50 = "photo_50"
    }

    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idJson = try container.decode(Int.self, forKey: .id)
        id = String(idJson)
        name = try container.decode(String.self, forKey: .name)
        photo50 = try container.decode(String.self, forKey: .photo50)

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

struct GroupsService: Decodable {
    let response: Items

    struct Items: Decodable {
        let items: [Group]
    }
}
