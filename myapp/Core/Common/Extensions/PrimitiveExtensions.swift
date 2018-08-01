//
//  extensions.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static func randomWithin(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension Optional {
    static func flatten<T>(_ arg: Optional<Optional<T>>) -> Optional<T> {
        if let some = arg {
            return some
        }
        return Optional.none as! Optional<T>
    }
    
    func flattened<T>() -> Optional<T> where Wrapped == Optional<T> {
       return Optional.flatten(self)
    }
}
// MARK: - Array extensions
extension Array {
    
    init(_ iterator: AnyIterator<Element>) {
        var arr: [Element] = []
        for e in iterator {
            arr.append(e)
        }
        self = arr
    }
}

// MARK: Codable extensions

extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        return dict ?? [:]
    }
}
