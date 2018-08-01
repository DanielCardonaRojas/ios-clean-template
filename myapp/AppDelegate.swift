//
//  AppDelegate.swift
//  iluminapp
//
//  Created by Daniel Esteban Cardona Rojas on 11/7/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("""
            \n =============== Realm file location ============== \n
            \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))
            \n ================================================== \n
            """)
        
        #if DEBUG
            print("\n ===============> DEBUG FLAG ON <============== \n")
        #endif
        
        let myModelListViewController : UINavigationController = MyModelListWireframe.createModule(from: ())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = myModelListViewController
        window?.makeKeyAndVisible()
        
        // Setup location manager
        LocationManager.sharedInstance.updateTrackingMethod(.combined)

        //MARK: Setup local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert]) { (granted, error) in
            print("UNUserNotificationCenter authorization: \(granted) error: \(String(describing: error))")
            if !granted && error != nil {
                //Show  some alert
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.sharedInstance.updateTrackingMethod(.background)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationManager.sharedInstance.updateTrackingMethod(.foreground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LocationManager.sharedInstance.updateTrackingMethod(.foreground)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LocationManager.sharedInstance.updateTrackingMethod(.none)
    }


}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Navigate to lightshow play screen
        completionHandler(.alert)
        print("user notification center will present notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user notification center did receive response")
        _ = response.notification.request.content.userInfo
        _ = response.notification.request.identifier
    }
}
