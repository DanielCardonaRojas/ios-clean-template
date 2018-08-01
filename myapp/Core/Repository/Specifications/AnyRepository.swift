//
//  Created by Daniel Cardona on 3/7/18.
//  Copyright © 2018 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift

/*
 Type Erasure pattern workaround
 As suggested in: https://blog.jayway.com/2017/05/12/a-type-erasure-pattern-that-works-in-swift/
 */
final class AnyRepository<Content : KeyedObject>: Repository {
    // Store the box specialised by content.
    // This line is the reason why we need an abstract class _AnyRepositoryBase.
    // We cannot store here an instance of _AnyRepositoryBox directly because the concrete type for Repository is provided by the initialiser, at a later stage.
    private let box: _AnyRepositoryBase<Content>
    
    // Initialise the class with a concrete type where the content is restricted to be the same as the generic parameter
    init<Concrete: Repository>(_ concrete: Concrete) where Concrete.ItemType == Content {
        box = _AnyRepositoryBox(concrete)
    }
    
    // All methods for the protocol just call the equivalent box method
    func fetchAll() -> Observable<[Content]> {
        return self.box.fetchAll()
    }
    
    func fetchById(_ id: Content.PrimaryKeyType) -> Observable<Content?> {
        return self.box.fetchById(id)
    }
    
    func fetchWith(_ predicate: @escaping (Content) -> Bool) -> Observable<[Content]> {
        return self.box.fetchWith(predicate)
    }
    
    func add(_ item: Content) -> Observable<Content?> {
        return self.box.add(item)
    }
    
    func delete(_ item: Content) -> Observable<Content?> {
        return self.box.delete(item)
    }
    
    func update(_ item: Content) -> Observable<Content?> {
        return self.box.update(item)
    }
    
}

private class _AnyRepositoryBase<EntityType : KeyedObject>: Repository {
    init() {
        guard type(of: self) != _AnyRepositoryBase.self else {
            fatalError("_AnyRepositoryBase<Model> instances can not be created;create a subclass instance instead")
        }
    }
    
    //Override methods
    func fetchAll() -> Observable<[EntityType]> {
        fatalError("Must override")
    }
    
    func fetchById(_ id: EntityType.PrimaryKeyType) -> Observable<EntityType?> {
        fatalError("Must override")
    }
    
    func fetchWith(_ predicate: @escaping (EntityType) -> Bool) -> Observable<[EntityType]> {
        fatalError("Must override")
    }
    
    func add(_ item: EntityType) -> Observable<EntityType?> {
        fatalError("Must override")
    }
    
    func delete(_ item: EntityType) -> Observable<EntityType?> {
        fatalError("Must override")
    }
    
    func update(_ item: EntityType) -> Observable<EntityType?> {
        fatalError("Must override")
    }
    
    
    
}

private final class _AnyRepositoryBox<ConcreteRepo: Repository>: _AnyRepositoryBase<ConcreteRepo.ItemType> {
    // Store the concrete type
    let concreteRepository : ConcreteRepo
    init(_ concrete: ConcreteRepo) {
        self.concreteRepository = concrete
    }
    
    //Override methods
    override func fetchAll() -> Observable<[ConcreteRepo.ItemType]> {
        return concreteRepository.fetchAll()
    }
    
    override func fetchById(_ id: ConcreteRepo.ItemType.PrimaryKeyType) -> Observable<ConcreteRepo.ItemType?> {
        return concreteRepository.fetchById(id)
    }
    
    override func fetchWith(_ predicate: @escaping (ConcreteRepo.ItemType) -> Bool) -> Observable<[ConcreteRepo.ItemType]> {
        return concreteRepository.fetchWith(predicate)
    }
    
    override func add(_ item: ConcreteRepo.ItemType) -> Observable<ConcreteRepo.ItemType?> {
        return concreteRepository.add(item)
    }
    
    override func delete(_ item: ConcreteRepo.ItemType) -> Observable<ConcreteRepo.ItemType?> {
        return concreteRepository.delete(item)
    }
    
    override func update(_ item: ConcreteRepo.ItemType) -> Observable<ConcreteRepo.ItemType?> {
        return concreteRepository.update(item)
    }
}
