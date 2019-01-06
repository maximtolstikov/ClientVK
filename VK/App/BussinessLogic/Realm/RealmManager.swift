//
//  RealmManager.swift
//  VK
//
//  Created by Maxim Tolstikov on 06/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import RealmSwift

/// Управляет методами Realm
class RealmManager {
    
    private let realm: Realm
    
    init?(configuration: Realm.Configuration) {
        self.realm = try! Realm(configuration: configuration)
    }
    
    convenience init?() {
        self.init(configuration: Realm.Configuration.defaultConfiguration)
        print(realm.configuration.fileURL?.absoluteString ?? "")
    }
    
    func loadDataBy<T: Object>(type: T.Type, predicate: NSPredicate) -> Results<T>? {
        
            let result = realm.objects(type).filter(predicate)
            return result
    }
    
    func saveObject(_ object: Object) {
        
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func saveCollection<T: Sequence>(_ objects: T) where T.Element: Object {
        
        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
}
