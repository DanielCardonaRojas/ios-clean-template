//
//  Created by Daniel Esteban Cardona Rojas on 11/10/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import Fakery

//Define how to generate random model objects.

extension MyModel : Fakeable {
    static let faker = Faker()
    static func generateRandom() -> MyModel {
        return MyModel(uuid: String(describing: UUID()), name: MyModel.faker.address.city())
    }
}

extension Location: Fakeable {
    static let faker = Faker()
    static func generateRandom() -> Location {
        return Location(longitude: faker.address.longitude(), latitude: faker.address.latitude())
    }
}
