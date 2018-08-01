//
//  ApiRepository.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/9/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import Gloss
import Alamofire
import RxSwift

typealias Resource = Restful & JSONDecodable
enum ApiRepositoryError: Error, CustomStringConvertible {
   case notJSONResponse, operationNotSupported
    
    var description: String {
        let logger: (String) -> String = { log in "[API Repository Error] [\(log)]" }
        var desc: String
        switch self {
        case .notJSONResponse:
            desc = logger("Is not json response")
        case .operationNotSupported:
            desc = logger("The entity does not support operations") //Maybe tag this enum with the method itself.
        }
        return desc
    }
}

class ApiRepository<EntityType> : Repository where EntityType : Resource {

    typealias ItemType = EntityType
    var baseURL : URL // Host ip or domain
    private var resourceIndexURL : URL {
        return self.baseURL.appendingPathComponent(EntityType.resourcePathComponent)
    }

    init(baseURL : URL) {
        self.baseURL = baseURL
        NotificationCenter.default.addObserver(self, selector: #selector(reconfigure), name: Const.Notification.ReconfigureModules, object: nil)
    }
    
    // MARK: - Repository Implementation
    func fetchAll() -> Observable<[EntityType]> {
        guard EntityType.allowedOperation.contains(.list) else {
           return Observable.error(ApiRepositoryError.operationNotSupported)
        }
        
        return Alamofire.request(self.resourceIndexURL).rx.responseJSON().map({ (value: Any) -> [EntityType] in
            // Swap json parsing library here!
            guard let json = value as? [Gloss.JSON] else {
                throw ApiRepositoryError.notJSONResponse
            }
            
            let listValues = [EntityType].from(jsonArray: json) ?? []
            return listValues
        }).debug()
    }
    
    func fetchById(_ id: EntityType.PrimaryKeyType) -> Observable<EntityType?> {
        guard EntityType.allowedOperation.contains(.read) else {
            return Observable.error(ApiRepositoryError.operationNotSupported)
        }
        let resourceURL = self.resourceIndexURL.appendingPathComponent(String(describing: id))
        return Alamofire.request(resourceURL).rx.responseJSON().map({ (value: Any) -> EntityType? in
            let item: EntityType? = EntityType.init(json: value as! Gloss.JSON)
            //print("\nValue: \n\(String(describing: value))\n")
            return item
        }).debug()
    }
    
    func fetchWith(_ predicate: @escaping (EntityType) -> Bool) -> Observable<[EntityType]> {
        guard EntityType.allowedOperation.contains(.list) else {
            return Observable.error(ApiRepositoryError.operationNotSupported)
        }
        return Observable.from(optional: [])
    }
    
    func add(_ item: EntityType) -> Observable<EntityType?> {
       return Observable.error(ApiRepositoryError.operationNotSupported)
    }
    
    func delete(_ item: EntityType) -> Observable<EntityType?> {
       return Observable.error(ApiRepositoryError.operationNotSupported)
    }
    
    func update(_ item: EntityType) -> Observable<EntityType?> {
       return Observable.error(ApiRepositoryError.operationNotSupported)
    }
    
    // MARK: - Reconfigure
    @objc func reconfigure(_ notification: NSNotification) {
        if let url = notification.userInfo?[Const.Keys.APIUrl] as? URL {
            baseURL = url
        }
    }

    /*
     This method fetches subentities querying different endpoints. This requires
     Note: The only reasonable default we can get for this is to make a request for each subentity,
     also note that this requires to keep then unparsed json and inspect for the subentity keys, to do further requests.
     It also requires mirroring the struct or class too, not only the instance (which seems to require a library).
     */
    private func fetchSubEntites(_ entity: EntityType) -> Observable<EntityType?> {
        //First fetch the parent entity itself

        //Inspect properties to find which are entities themselves.
        //NOTE: Entity would be required to explictly mark the keys corresponding to subentities primary keys.
        let mirror = Mirror(reflecting: entity)
        //Define what subentities should look like

        //Check if is a list, sequence of subentities

        //Iterate through child elements and see which are JSONDecodable and Restful
        for child in mirror.children {
            if child is Resource {
            }
        }
        return Observable.from(optional: nil)
	}
    
    private func subEntityKey(with label: String) -> String? {
       return nil
    }
    
}


