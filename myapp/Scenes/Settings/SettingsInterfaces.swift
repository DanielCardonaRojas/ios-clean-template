//
//  SettingsInterfaces.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 12/14/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//
import Foundation

enum SettingsNavigationOption {
}

protocol SettingsWireframeInterface {
    func navigate(to option: SettingsNavigationOption)
}

