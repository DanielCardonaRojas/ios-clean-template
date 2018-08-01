//
//  SettingsViewController.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 12/14/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usesFakeDataSwitch: UISwitch!
    @IBOutlet weak var environmentSelector: UISegmentedControl!
    
    var presenter: SettingsPresenter?
    var apiSetting: ServerConnectionSetting?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        usesFakeDataSwitch.isOn = ConfigurationManager.shared.usesFakeLightshows
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear(animated: animated)
        environmentSelector.selectedSegmentIndex = Int(apiSetting!.environment.rawValue)!
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear(animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    @IBAction func environmentChanged(_ sender: UISegmentedControl) {
        let index = String(describing: sender.selectedSegmentIndex)
        let env = ServerConnectionSetting.Environment(rawValue: index)!
        ConfigurationManager.shared.serverConnectionSetting = ServerConnectionSetting(environment: env)
        let notification = Notification(name: Const.Notification.ReconfigureModules,
                                        object: nil,
                                        userInfo: [Const.Keys.APIUrl: ConfigurationManager.shared.serverConnectionSetting.apiURL])
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func lightshowSourceSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            let alertController = UIAlertController(title: "Note", message: "This setting requires restarting the app", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
        ConfigurationManager.shared.usesFakeLightshows = sender.isOn
    }
}
