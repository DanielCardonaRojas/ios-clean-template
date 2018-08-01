//
//  RxSwiftExtensions.swift
//
//  Created by Daniel Cardona on 2/10/18.
//  Copyright © 2018 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

extension ObservableType where E: Sequence {
    typealias T = E.Iterator.Element
    func flatMapIterable() -> Observable<T> {
        let result: Observable<T> = self.flatMap({ e in Observable.from(e) })
        return result
    }
}

extension ObservableType where E: ObservableConvertibleType {
    typealias OT = E.E
    func traverse() -> Observable<[OT]> {
        return self.asObservable().merge().toArray()
    }
    
    static func traverse(_ obs: [Observable<OT>]) -> Observable<[OT]> { //[Observable<A>] -> Observable<[A]>
        return Observable.from(obs).asObservable().merge().toArray()
    }
}
extension ObservableType {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */
    
    public func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

// MARK: - Alamofire + RxSwift

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    func responseJSON() -> Observable<Any> {
        return Observable.create { observer in
            let request = self.base.responseJSON { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create(with: request.cancel)
        }
    }
}
