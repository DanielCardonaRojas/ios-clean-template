//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class MyModelListPresenter {

    var getLightShowsUseCase: GetMyModelsUseCase

    weak var view : MyModelListViewInterface?
    var wireframe : LightShowListWireframeInterface
    var lightshows : [MyModel]

    init(wireframe: LightShowListWireframeInterface, view: MyModelListViewInterface, useCaseLocator: UseCaseLocatorProtocol) {
        self.view = view
        self.wireframe = wireframe
        self.lightshows = []
        getLightShowsUseCase = try! useCaseLocator.createUseCase(ofType: GetMyModelsUseCase.self)
    }
    
    func attachView(view: MyModelListViewInterface){
        self.view = view
    }

}

//Mark: LightShowListPresenterProtocol
extension MyModelListPresenter: MyModelListPresenterInterface {
    
    func presentDetail(lightShowUUID uuid: String) {
        guard let lightshowModel = self.lightshows.filter({ls in ls.uuid == uuid}).first else {
            print("Light show not in local presenter list")
            return
        }
        self.wireframe.navigate(to: .detail(lightShow: lightshowModel))
    }
    
    func onListRefresh() {
        self.presentLatest()
    }
    
    func presentLatest() {
        guard let v = self.view else {
            return
        }
        

        _ = getLightShowsUseCase.observable(options: .networkedWithSave)
            .subscribe(AnyObserver { event in
            
                let tevent = event.map({ (ls: [MyModel]) -> [MyModelViewModel] in
                    return ls.map{ l in
                        return MyModelViewModel(from: l)
                    }
                })
                
                if let error = tevent.error {
                    v.hideLoading()
                    v.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                if let error = event.error {
                    v.hideLoading()
                    v.showAlert(title: "Network Error", message: error.localizedDescription)
                    return
                }
                
                guard let viewModels = tevent.element, let models = event.element else {
                    return
                }
                
                
                self.lightshows = models
                v.display(lightShows: viewModels)
        })
    }
    
    func onNavigationBarTapped() {
       wireframe.navigate(to: .settings)
    }
    
    func presentByAccount(name: String) {
    }
}


fileprivate extension Location {
    
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
