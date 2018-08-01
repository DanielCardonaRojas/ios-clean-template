//
//  UseCase.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/7/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift

/*
 We want a generic UseCase base class that can be anitialized, with any repository
 
 UseCase is parametrized over the repository type, it answers the question. Will we be dealing with a repository
 of what. Offcourse not all use cases will need to interact with a repository, so not all will have to inferit from this one.
 
 Inheriting can be especified like this:
     class ChildClass : UseCase<RepositoryEntityType>
*/

class UseCaseWithRepo<T : KeyedObject>{
    let repository : AnyRepository<T>
    required init(repository: AnyRepository<T>){
        self.repository = repository
    }
}

class UseCase<T : KeyedObject & RealmPersistable> {
    let dataManager : DataManager<T>
    required init(manager: DataManager<T>){
        self.dataManager = manager
    }
}

protocol Interactor {
    associatedtype ConsumableType
    associatedtype PerformOptionsType = Void
    // If no options are required just make the PerformOptionsType = Void and set the default para meter as ()
    // like this: options : Void = ()
    func observable(options: PerformOptionsType) -> Observable<ConsumableType>
}

extension Interactor {
    // A callback style alternative
    func execute(options: PerformOptionsType, completion: ((ConsumableType) -> Void)?) {
        guard let completionHandler = completion else {
            print("No completion handler")
            return
        }
        self.perform(options: options, subscriber: AnyObserver { event in
            guard let eventElement = event.element else {
               print("No element in event")
               return
            }
            completionHandler(eventElement)
        })
    }
    
    
    func perform(options: PerformOptionsType, subscriber: AnyObserver<ConsumableType>){
       _ = self.observable(options: options).debug().subscribe(subscriber)
    }
}

