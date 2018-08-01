//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.

import Foundation

// MARK: - ViewModel -
struct MyModelViewModel {
    //Is some what similar to LightShow but can have entra computed values
    //and formated properties for easy view binding. These might be observables too.
    let uuid : String
    let name : String

    init(from lightShow: MyModel) {
        self.name = lightShow.name
        self.uuid = lightShow.uuid
    }
    
}

// MARK: - View -
protocol MyModelListViewInterface: class { // Comunication: Presenter -> View
    
    // Display a lightshow and its distance in Kilometers this can be enhanced to a struct with extra lightshow information
    func display(lightShows: [MyModelViewModel]) -> Void
    func showAlert(title: String, message: String)
    func showLoading() -> Void
    func hideLoading() -> Void
    
}

// MARK: - Presenter -
protocol MyModelListPresenterInterface : PresenterInterface { // Comunication: View -> Presenter
    func onListRefresh() -> Void
    func presentDetail(lightShowUUID uuid: String) -> Void
    func presentLatest() -> Void
    func presentByAccount(name: String) -> Void
    func onNavigationBarTapped()
}

// MARK: - Wireframe / Router -
enum LightShowListNavigationOption {
    case detail(lightShow: MyModel), settings
}

protocol LightShowListWireframeInterface: BaseWireframeInterface {
    func navigate(to option: LightShowListNavigationOption)
}


