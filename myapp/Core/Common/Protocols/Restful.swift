//
//  APILocatable.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/9/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import Alamofire

enum CRUD: String {
    case create, read, update, delete, list
}

protocol Restful: KeyedObject {
    static var allowedOperation: [(CRUD)] { get } // What can we do with a given type?
    static var resourcePathComponent: String { get } // Whats the url main component?
    static func method(operation: CRUD) -> HTTPMethod // How do custom operation map to http verbs.
    func pathComponent(operation: CRUD) -> String // How do custom operations map to urls
}


extension Restful {
    func pathComponent(operation: CRUD) -> String {
        var pathComponent: String
        switch operation {
        case .list:
            fallthrough
        case .create:
            pathComponent = Self.resourcePathComponent
        case .update:
            fallthrough
        case .delete:
            fallthrough
        case .read:
            pathComponent = Self.resourcePathComponent + "/" + String(describing: self.primaryKey)
        }
        
        return pathComponent
    }
    
    static func method(operation: CRUD) -> HTTPMethod {
        var verb: HTTPMethod
        switch operation {
        case .list:
            verb = .get
        case .create:
            verb = .post
        case .update:
            verb = .put
        case .delete:
            verb  = .delete
        case .read:
            verb = .get
        }
        return verb
    }
    
}
