//
//  SettingsPresenter.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 12/14/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

final class SettingsPresenter: PresenterInterface {
    
    // MARK: - Private properties -
    private weak var view: SettingsViewController?
    private var wireframe: SettingsWireframeInterface
    
    init(wireframe: SettingsWireframeInterface, view: SettingsViewController) {
        self.wireframe = wireframe
        self.view = view
    }
    // MARK: - Lifecycle -
    func viewDidLoad() {
        view?.apiSetting = ConfigurationManager.shared.serverConnectionSetting
    }

}

