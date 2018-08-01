//
//  Created by Daniel Esteban Cardona Rojas on 11/7/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift
/*
 A repository abstracts away a entity datasource with a comon api especified in the Repository protocol.
 Typically we will have a database and webservice implementation
 TODO: Add some sorting functions
 TODO: Think of a generic way of querying a repository. e.g an API can be queried through url parameters (?age>10 ... etc) but a database will use sql.
 */
protocol Repository {
    associatedtype ItemType : KeyedObject //Is the type for what the repository can fetch.
    func fetchAll() -> Observable<[ItemType]>
    func fetchById(_ id: ItemType.PrimaryKeyType) -> Observable<ItemType?>
    func fetchWith(_ predicate: @escaping (ItemType) -> Bool) -> Observable<[ItemType]>
    func add(_ item: ItemType) -> Observable<ItemType?>
    func delete(_ item: ItemType) -> Observable<ItemType?>
    func update(_ item: ItemType) -> Observable<ItemType?>
}

