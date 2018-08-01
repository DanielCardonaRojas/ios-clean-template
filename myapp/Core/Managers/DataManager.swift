//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Gloss

/*
 Knows how to multiplex between data sources.
 Can fetch from a remote or local repository instance, or fetch from whichever source
 is available first.
 
 TODO: Adjust DataMangerProtocol to define how to report errors.
 Maybe wrap repository protocol outputs into a Result/Either type for reporting error
 so that client code doesn't need to deal with exceptions instead switch over an enumeration
 like: .success, .nointernet, .nothingincache, etc...
*/

enum FetchOption {
   case networkedWithSave, networked, cached, shortestPath
}

enum PersistOption { // Persist to local db, post to backend, or both.
   case remote, local, both
}

class DataManager<RepositoryEntity> where RepositoryEntity : KeyedObject & RealmPersistable {
    typealias ItemType = RepositoryEntity
    
    var apiRepository : AnyRepository<RepositoryEntity> // ApiRepository might need a more specialized type later on.
    var cacheRepository : AnyRepository<RepositoryEntity>?

    init(apiRepository: AnyRepository<RepositoryEntity>, cacheRepository: AnyRepository<RepositoryEntity>?) {
        self.apiRepository = apiRepository
        self.cacheRepository = cacheRepository
    }

    // MARK: - Fetch List methods
    private func listFromMemory(_ predicate: ((RepositoryEntity) -> Bool)? = nil) -> Observable<[RepositoryEntity]> {
        guard let cacheRepo = cacheRepository else{
            print("No caching repository")
            return Observable.from([])
        }
        if let p = predicate {
           return cacheRepo.fetchWith(p)
        }
        return cacheRepo.fetchAll()
    }
    
    private static func save(_ entities: [RepositoryEntity], _ cacheRepository: AnyRepository<RepositoryEntity>?) {
        guard let repo = cacheRepository else {
            print("No caching repository configured")
            return
        }
        
        for e in entities {
            _ = repo.add(e)
        }
    }
    
    private func listFromNetworkWithSave(_ predicate: ((RepositoryEntity) -> Bool)? = nil) -> Observable<[RepositoryEntity]> {
        if let p = predicate {
            return apiRepository.fetchWith(p).do(onNext: { (entities: [RepositoryEntity]) in
                DataManager.save(entities, self.cacheRepository)
            })
        }
        
        return apiRepository.fetchAll().do(onNext: { (entities : [RepositoryEntity]) in
            DataManager.save(entities, self.cacheRepository)
        })
    }
    
    private func listFromNetwork(_ predicate: ((RepositoryEntity) -> Bool)? = nil) -> Observable<[RepositoryEntity]> {
        if let p = predicate {
            return apiRepository.fetchWith(p)
        }
        return apiRepository.fetchAll()
    }
    
    // MARK: - Single entity fetch
    private func itemFromMemory(_ id: RepositoryEntity.PrimaryKeyType) -> Observable<RepositoryEntity?> {
        guard let cacheRepo = cacheRepository else{
            print("No caching repository")
            return Observable.from(optional: nil)
        }
        return cacheRepo.fetchById(id)
    }
    
    private func itemFromNetworkWithSave(_ id: RepositoryEntity.PrimaryKeyType) -> Observable<RepositoryEntity?> {
        return apiRepository.fetchById(id).do(onNext: { (entity : RepositoryEntity?) in
            if let e = entity {
                DataManager.save([e], self.cacheRepository)
            }
        })
    }
    
    private func itemFromNetwork(_ id: RepositoryEntity.PrimaryKeyType) -> Observable<RepositoryEntity?> {
        return apiRepository.fetchById(id)
    }

    // MARK: - Repository multiplexing
    func fetch(option fetchOptions: FetchOption, _ pred: ((RepositoryEntity) -> Bool)? = nil) -> Observable<[RepositoryEntity]> {
        switch fetchOptions {
        case .networked: // Fetch from the api only
            return listFromNetwork(pred)
        case .cached: // Just try the local db
            return listFromMemory(pred)
        case .networkedWithSave: //Fetches from api and persists
            return listFromNetworkWithSave(pred)
        case .shortestPath: // Returns the first available.
            return Observable.concat(listFromMemory(pred), listFromNetworkWithSave(pred))
                .single({ (entities : [RepositoryEntity]) -> Bool in
                    entities.count != 0
            })
        }
    }
    
    func fetchFirst(option fetchOptions: FetchOption, _ pred: @escaping ((RepositoryEntity) -> Bool)) -> Observable<RepositoryEntity?> {
        switch fetchOptions {
        case .networked: // Fetch from the api only
            return listFromNetwork(pred).map({ $0.first }).single()
        case .cached: // Just try the local db
            return listFromMemory(pred).map({ $0.first }).single()
        case .networkedWithSave: //Fetches from api and persists
            return listFromNetworkWithSave(pred).map({ $0.first }).single()
        case .shortestPath: // Returns the first available.
            return Observable.concat(listFromMemory(pred), listFromNetworkWithSave(pred))
                .single({ (entities : [RepositoryEntity]) -> Bool in
                    entities.count != 0
                }).map({ $0.first }).single()
        }
    }
    
    func fetchById(_ id: RepositoryEntity.PrimaryKeyType, option: FetchOption) -> Observable<RepositoryEntity?> {
        switch option {
        case .networked:
            return itemFromNetwork(id)
        case .cached:
            return itemFromMemory(id)
        case .networkedWithSave:
            return itemFromNetworkWithSave(id)
        case .shortestPath: //TODO: Implement
            return itemFromNetwork(id)
        }
    }
    
    func add(_ item: RepositoryEntity, options: PersistOption = .local) {
       DataManager.save([item], self.cacheRepository)
    }
}

//MARK: - DataManager factories
extension DataManager {
    static func mockDataManager<T : Fakeable>(numberOfItems count: Int) -> DataManager<T> {
        return DataManager<T>(apiRepository: AnyRepository(MockRepository<T>(totalCount: count)), cacheRepository: nil)
    }
}
extension DataManager where RepositoryEntity: JSONDecodable & Restful {
    static func defaultDataManager(caching: Bool = false) -> DataManager<RepositoryEntity> { // A manager with no caching capabilities.
        let serverSettings = ConfigurationManager.shared.serverConnectionSetting
        let apiRepo = ApiRepository<RepositoryEntity>(baseURL: serverSettings.apiURL)
        let cachingRepo = RealmRepository<RepositoryEntity>()
        return DataManager(apiRepository: AnyRepository(apiRepo), cacheRepository: caching ? AnyRepository(cachingRepo) : nil)
    }
}
