//
//  Created by Daniel Esteban Cardona Rojas on 11/7/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift

/*
 To add extensions for a particular subtype of repository, just
 extend the repository with the correct itemtype
 */

extension Repository {
    func fetchFirst(_ pred: @escaping (ItemType) -> Bool) -> Observable<ItemType?> {
        return self.fetchWith(pred).map({ res in res.first }).single()
    }
}
