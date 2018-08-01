//
//  RealmPersistableImpls.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RealmSwift

/*
   Define how models can be transformed into Realm Objects. This boilerplate is the price paid for
   keeping our models database agnostic. For every model we need to provide its equivalent realm object
   and define an instance of RealmPersistable such that we can transform to it.
 */

final class MyModelObject : Object {
    @objc dynamic var uuid  = ""
    @objc dynamic var name  = ""

    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    
}

extension MyModel : RealmPersistable {
    typealias ManagedObject = MyModelObject
    
    init(managedObject: MyModelObject) {
        uuid = managedObject.uuid
        name = managedObject.name
    }
    
    func managedObject() -> MyModelObject {
        let modelObject = MyModelObject()
        modelObject.uuid = self.uuid
        modelObject.name = self.name
        return modelObject
    }
}
