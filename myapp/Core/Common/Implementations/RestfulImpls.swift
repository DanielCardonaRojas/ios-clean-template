//
//  RestLocatableImpls.swift
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//  Define where objects resource can be found in a webservice

import Foundation
import Alamofire

extension MyModel: Restful {
    typealias OperationType = CRUD
    static var allowedOperation: [(CRUD)] {
        return [.read, .list]
    }
    
    static var resourcePathComponent: String {
        return "mymodels"
    }
}
