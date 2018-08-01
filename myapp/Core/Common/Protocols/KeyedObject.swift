//
//  KeyedObject.swift
//
//  Created by Daniel Cardona on 11/11/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

protocol KeyedObject {
    typealias PrimaryKeyType = CustomStringConvertible
    var primaryKey : PrimaryKeyType {get}
}
