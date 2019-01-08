//
//  SwinjectStoryboard+Extension.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.register(AbstractRealmManager.self) { _ in
            let realm = RealmManager()
            return realm
        }
        defaultContainer.register(AbstractLoadData.self, name: "myData") { resolver in
            LoadMyData(realm: resolver ~> AbstractRealmManager.self)
        }
        defaultContainer.register(AbstractLoadData.self, name: "myFriends") { resolver in
            LoadMyFriendsData.init(realm: resolver ~> AbstractRealmManager.self)
        }
        defaultContainer.register(AbstractLoadData.self, name: "myGroups") { resolver in
            LoadMyGroupsData.init(realm: resolver ~> AbstractRealmManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(AboutMeViewController.self) { (resolver, controler) in
            controler.realm = resolver ~> AbstractRealmManager.self
            controler.service = resolver ~> ( AbstractLoadData.self, name: "myData")
        }
        
        defaultContainer.storyboardInitCompleted(MyFriendsTableViewController.self) { (resolver, controller) in
            controller.realm = resolver ~> AbstractRealmManager.self
            controller.service = resolver ~> (AbstractLoadData.self, name: "myFriends")
        }
        
        defaultContainer.storyboardInitCompleted(MyGroupsTableViewController.self) { (resolver, controller) in
            controller.realm = resolver ~> AbstractRealmManager.self
            controller.service = resolver ~> (AbstractLoadData.self, name: "myGroups")
        }

    }
}
