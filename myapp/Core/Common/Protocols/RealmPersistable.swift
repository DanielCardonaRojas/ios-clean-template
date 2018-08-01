//
//  RealmPersistable.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RealmSwift

/*
 This is protocol is used to decouple model structs from Realm
 This still requires defining the realm equivalent classes for the model structs.
 
 Implementation inspired by: https://medium.com/@gonzalezreal/using-realm-with-value-types-b69947741e8b
 */
public protocol RealmPersistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
