//
//  Created by Daniel Cardona on 11/11/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

extension MyModel : KeyedObject {
    var primaryKey: KeyedObject.PrimaryKeyType {
        return self.uuid
    }
}
