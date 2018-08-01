//
//  Fakeable.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import Fakery
import RxSwift

protocol Fakeable {
    static func generateRandom() -> Self
}

//TODO: Add another method that will generate a variable length array depending on some count limit.
extension Fakeable {
    static func generateRandomArray(count: Int) -> [Self] {
        return Array(repeating: (), count: count).map{_ in generateRandom()}
    }
    
    static func generateRandomArray(minLength: Int, maxLength:Int)  -> [Self]{
        let count = Int.randomWithin(start: minLength, to: maxLength)
        return generateRandomArray(count: count)
    }
    
    static func randomObservable(minLength: Int, maxLength: Int, every timeinterval: TimeInterval) -> Observable<(TimeInterval, Self)> {
       let count = Int.randomWithin(start: minLength, to: maxLength)
//       return Observable<Int>.interval(timeinterval, scheduler: MainScheduler.instance).take(count).map{ _ in generateRandom()}
        return Observable<Int>.interval(timeinterval, scheduler: MainScheduler.instance)
                              .take(count).map{ idx in (Double(idx) * timeinterval, generateRandom())}
    }
}
