//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import UIKit

class GetMyModelsUseCase : UseCase<MyModel>, Interactor {
    typealias ConsumableType = [MyModel]
    typealias PerformOptionsType = FetchOption

    static func defaultUseCase() -> GetMyModelsUseCase {
        return GetMyModelsUseCase(manager: DataManager<MyModel>.defaultDataManager())
    }

    // MARK: - Reactive Interactor
    func observable(options: FetchOption = .networkedWithSave) -> Observable<[MyModel]> {
        return dataManager.fetch(option: .networkedWithSave)
    }
}


