//
//  SettingsWireframe.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 12/14/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import UIKit

public final class SettingsWireframe: Wireframe {
    
    // MARK: - Private properties -
    static let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var view : UIViewController!
    
    init(view: UIViewController) {
        self.view = view
    }
    
    // MARK: - Module setup -
    static func createModule(from: Void = ()) -> SettingsViewController {
        let moduleViewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let wireframe = SettingsWireframe(view: moduleViewController)
        let presenter = SettingsPresenter(wireframe: wireframe, view: moduleViewController)
        moduleViewController.presenter = presenter
        return moduleViewController
    }
}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeInterface {
    func navigate(to option: SettingsNavigationOption) {
       return
    }
}
