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
        defaultContainer.autoregister(AbstractRealmManager.self) { _ in
            let realm = RealmManager()!
            return realm
        }
        defaultContainer.autoregister(AbstractLoadData.self,
                                      name: "myData",
                                      initializer: LoadMyData.init)
        defaultContainer.autoregister(AbstractLoadData.self,
                                      name: "myFriends",
                                      initializer: LoadMyFriendsData.init)
        
        
        defaultContainer.storyboardInitCompleted(AboutMeViewController.self) { (resolver, controler) in
            controler.realm = resolver ~> AbstractRealmManager.self
            controler.service = resolver ~> ( AbstractLoadData.self, name: "myData")
        }
        
        defaultContainer.storyboardInitCompleted(MyFriendsTableViewController.self) { (resolver, controller) in
            controller.realm = resolver ~> AbstractRealmManager.self
            controller.service = resolver ~> (AbstractLoadData.self, name: "myFriends")
        }

    }
}
