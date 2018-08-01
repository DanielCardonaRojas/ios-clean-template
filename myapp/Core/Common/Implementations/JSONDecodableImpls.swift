//
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import Gloss
import CoreGraphics

// Define how to parse object from Gloss.JSON

// MARK: - LightShow Implementation
extension MyModel : JSONDecodable {
    
    init?(json: JSON) {
        //Guard for required fields
        guard
            let name: String = ("name" <~~ json),
            let uuid: String = ("uuid" <~~ json),
            let accountName : String = ("organization" <~~ json),
            let dateString: String = ("trigger_date" <~~ json),
            let location: Location = ("location" <~~ json)
            else {
                return nil
        }
        
        // Parse ISO8601 string to date
        let dateParser = ISO8601DateFormatter()
        dateParser.formatOptions = .withInternetDateTime
        guard let date = dateParser.date(from: dateString) else {
            print("Wrong date format, cannot parse: \(dateString)")
            return nil
        }
        
        self.name = name
        self.uuid = uuid
    }
    
}


// MARK: - Location Implementation
extension Location: JSONDecodable {
    init?(json: JSON) {
        guard
            let longitude: Double = ("longitude" <~~ json),
            let latitude: Double = ("latitude" <~~ json)
        else {
            return nil
        }
        self.longitude = longitude
        self.latitude = latitude
    }
}
