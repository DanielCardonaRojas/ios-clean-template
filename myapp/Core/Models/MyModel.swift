//
//  LightShow.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/7/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

struct Location: CustomStringConvertible {
    let longitude: Double
    let latitude: Double
    
    var description: String {
        return String(format: "%.3f, %.3f", self.longitude, self.latitude)
    }
}

typealias EventUUID = UUID

struct MyModel {
    let uuid : String
    let name : String

}
