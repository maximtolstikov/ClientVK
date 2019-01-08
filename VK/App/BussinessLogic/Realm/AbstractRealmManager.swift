//
//  AbstractRealmManager.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import RealmSwift

protocol AbstractRealmManager {
    
    init?(configuration: Realm.Configuration)
    init?()
    
    func loadDataBy<T: Object>(type: T.Type, predicate: NSPredicate) -> Results<T>?
    func saveObject(_ object: Object)
    func saveCollection<T: Sequence>(_ objects: T) where T.Element: Object
    func deleteAll()
}
