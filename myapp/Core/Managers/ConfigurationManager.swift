//
//  Created by Daniel Cardona on 1/23/18.
//  Copyright © 2018 Daniel Esteban Cardona Rojas. All rights reserved.
//

import Foundation

struct ServerConnectionSetting: Codable {
    
    enum Environment: String, Codable {

        /* These environments are only used in development mode.
           and can be changed but dynamically.
        */
        case dev = "0"
        case staging = "1"
        case production = "2"

        var baseUrl: URL {
            var host: String
            switch self {
            case .production:
                host = "http://159.203.163.96"
            case .dev:
                host = "localhost:5000"
            case .staging:
                host = "http://159.203.163.96"
            }
            return URL(string: host)!
        }
    }
    
    var url: URL {
        #if DEBUG
           return environment.baseUrl
        #else
            let value = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
            return URL(string: value)!
        #endif
    }
    
    var environment: Environment
    
    var apiURL: URL {
        return url.appendingPathComponent("api")
    }
    
    var staticContentPath: URL {
        return url.appendingPathComponent("static")
    }
    
    var staticImagesPath: URL {
        return staticContentPath.appendingPathComponent("images")
    }
}


class ConfigurationManager {
    static let shared = ConfigurationManager()
    

    // MARK: - Configuration properties
    var serverConnectionSetting: ServerConnectionSetting {
        set (new) {
            let data = try? PropertyListEncoder().encode(new)
            UserDefaults.standard.set(data, forKey: Const.ConfigurationKey.APIConnectionSettingKey)
        }
        
        get {
            if let data = UserDefaults.standard.value(forKey: Const.ConfigurationKey.APIConnectionSettingKey) as? Data {
                if let value = try? PropertyListDecoder().decode(ServerConnectionSetting.self, from: data)  {
                   return value
                }
                return ServerConnectionSetting(environment: .dev)
            }
            return ServerConnectionSetting(environment: .dev)
        }
    }
    
    var usesFakeLightshows: Bool {
        get {
            if let val =  UserDefaults.standard.value(forKey: Const.ConfigurationKey.UsesFakeLightshows) as? Bool {
               return val
            }
            return false
        }
        set(new) {
            UserDefaults.standard.set(new, forKey: Const.ConfigurationKey.UsesFakeLightshows)
        }
    }
}

