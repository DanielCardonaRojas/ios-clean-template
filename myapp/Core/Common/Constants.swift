//
//  Created by Daniel Esteban Cardona Rojas on 12/15/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

enum Const {
    // MARK: - General Purpose Keys
    enum Keys {
        // MARK: User Defaults keys
        static let APIUrl = "api.server"
    }
    
    // MARK: - Configuration Keys
    enum ConfigurationKey {
        static let APIConnectionSettingKey = "APIHostIPKey"
        static let UsesFakeLightshows = "AppUsingFakeLightshows"
    }
    
    // MARK: - Notification names
    enum Notification  {
        static let ReconfigureModules = NSNotification.Name(rawValue: "ReconfigureModuleNotification")
    }
    
    // MARK: - Segues
    enum Segues {
        
    }
    // MARK: - Localized strings
    enum LocalizedStrings {
        
    }
    
    // MARK: - Storyboard identifiers
    enum StoryboardIDs {
        
    }
}
