//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

enum UseCaseLocatorProtocolError: Error {
   case useCaseNotFound
}

protocol UseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T? where T: Interactor
}

extension UseCaseLocatorProtocol {
    func createUseCase<T>(ofType type: T.Type) throws -> T where T: Interactor {
        guard let useCase = getUseCase(ofType: type) else {
           throw UseCaseLocatorProtocolError.useCaseNotFound
        }
        return useCase
    }
}

class UseCaseFactory: UseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T? {
        switch String(describing: type) {
        case String(describing: GetMyModelsUseCase.self):
            let useCase = GetMyModelsUseCase(manager: DataManager<MyModel>.defaultDataManager())
            return useCase as? T
        default:
            break
        }
        return nil
    }
    
}





