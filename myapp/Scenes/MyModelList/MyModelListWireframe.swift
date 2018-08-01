//
//  Created by Daniel Esteban Cardona Rojas on 11/15/17.
//  Copyright (c) 2017 Daniel Esteban Cardona Rojas. All rights reserved.

import UIKit

public final class MyModelListWireframe: BaseWireframe, Wireframe {

    // MARK: - Private properties -
    
    static let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - Module setup -
    static func createModule(from: Void) -> UINavigationController {
        let moduleViewController = mainStoryboard.instantiateViewController(withIdentifier: "LightShowListViewController") as! MyModelListViewController
        let navController = UINavigationController(rootViewController: moduleViewController)
        let wireframe = MyModelListWireframe(navigationController: navController)
        let presenter = MyModelListPresenter(wireframe: wireframe, view: moduleViewController, useCaseLocator: UseCaseFactory())
        moduleViewController.presenter = presenter
        return navController
    }
}

// MARK: - Extensions -

extension MyModelListWireframe: LightShowListWireframeInterface {
    func navigate(to option: LightShowListNavigationOption) {
        switch option {
        case .detail(let ls):
            //TODO: Implement a detail view.
            break
        case .settings:
            let settingsView: SettingsViewController = SettingsWireframe.createModule()
            show(settingsView, with: Transition.push, animated: true)
        }
    }
}
