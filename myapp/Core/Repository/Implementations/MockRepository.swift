//
//  LightShowMockRepository.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift

class MockRepository<EntityType> : Repository where EntityType : Fakeable & KeyedObject {

    typealias ItemType = EntityType
    private let totalCount : Int
    init(totalCount:Int) {
        self.totalCount = totalCount
    }
    func fetchAll() -> Observable<[EntityType]> {
        let randomLightShows = EntityType.generateRandomArray(count: totalCount)
        return Observable.from(optional: randomLightShows)
    }
    
    func fetchById(_ id: EntityType.PrimaryKeyType) -> Observable<EntityType?> {
        let randomLightShows  = EntityType.generateRandom()
        return Observable.from(optional: Optional.some(randomLightShows))
    }
    
    func fetchWith(_ predicate: @escaping (EntityType) -> Bool) -> Observable<[EntityType]> {
        let min = Int(Float(self.totalCount) * 0.5)
        let randomLightShows = EntityType.generateRandomArray(minLength: min, maxLength: totalCount)
        return Observable.from(optional: randomLightShows)
    }
    
    func add(_ item: EntityType) -> Observable<EntityType?> {
        return Observable.from(optional: item)
    }
    
    func delete(_ item: EntityType) -> Observable<EntityType?> {
        return Observable.from(optional: item)
    }
    
    func update(_ item: EntityType) -> Observable<EntityType?> {
        return Observable.from(optional: item)
    }
    
}
