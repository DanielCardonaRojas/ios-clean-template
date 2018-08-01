//
//  RealmRepository.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


//Note: Find database file with: po Realm.Configuration.defaultConfiguration.fileURL
class RealmRepository<EntityType> : Repository where EntityType : RealmPersistable & KeyedObject {

    typealias ItemType = EntityType
    let realm = try! Realm()
    
    func fetchAll() -> Observable<[EntityType]> {
        let objs: Results<EntityType.ManagedObject> = realm.objects(EntityType.ManagedObject.self)
        let entities = objs.map{o in EntityType(managedObject: o)}
        return Observable.from(entities).toArray()
    }
    
    func fetchById(_ id: EntityType.PrimaryKeyType) -> Observable<EntityType?> {
        let obj = realm.object(ofType: EntityType.ManagedObject.self, forPrimaryKey: id)
        return Observable.from(optional: obj.map{ o in EntityType(managedObject: o)})
    }
    
    func fetchWith(_ predicate: @escaping (EntityType) -> Bool) -> Observable<[EntityType]> {
        // Block predicates isn't supported yet: https://github.com/realm/realm-cocoa/issues/2138
        // so just filter after getting al entities
        _ = NSPredicate { (entity, options) -> Bool in
            let e = entity as! EntityType
            return predicate(e)
        }
//        let objects = realm.objects(EntityType.ManagedObject.self).filter(pred)
//        let aobjects = Array(objects).map{o in EntityType(managedObject: o)}
        let objects = realm.objects(EntityType.ManagedObject.self)
        let aobjects = Array(objects).map({o in EntityType(managedObject: o)}).filter({ predicate($0) })
        return Observable.from(aobjects).toArray()
    }
    
    func add(_ item: EntityType) -> Observable<EntityType?> {
        do {
            try self.realm.write {
                self.realm.add(item.managedObject(), update: true)
            }
        } catch let error {
            return Observable.error(error)
        }
        return Observable.from(optional: item).single()
    }
    
    func delete(_ item: EntityType) -> Observable<EntityType?> {
        do {
            try self.realm.write {
                self.realm.delete(item.managedObject())
            }
        } catch let error {
            return Observable.error(error)
        }
        return Observable.from(optional: item).single()
    }
    
    func update(_ item: EntityType) -> Observable<EntityType?> {
        do {
            try self.realm.write {
                self.realm.add(item.managedObject(), update: true)
            }
        } catch let error {
            return Observable.error(error)
        }
        
        return Observable.from(optional: item).single()
    }
}
