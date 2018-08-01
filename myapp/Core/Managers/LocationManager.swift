//
//  Created by Daniel Esteban Cardona Rojas on 7/18/18.
//  Copyright © 2018 Daniel Esteban Cardona Rojas. All rights reserved.
//

/*

 Problem: We need to monitor when a user has entered a region asociated
 with the lightshow location and is close to the starting time of the lightshow.
 
 This way we can inform the backend that the subscriber to a particular lightshow
 seems to have arrived to the desired location, and count how many subscriber
 actually atended the lightshow.
 
 We also need to track the users location and show distances to active lightshows.
 
 So this manager helps out with 2 use cases:
 
 - GetUsersCurrentLocation (when displaying lightshows)
 - ObserverUserEnteringRegion (Geofence subscribed lightshows)
*/

import RxSwift
import RxCocoa
import CoreLocation


enum TrackingType {
    case foreground, background, combined, none
}

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
//    var delegate : LocationManagerDelegate? //Our custom wrapper delegate
    let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        requestPermission()
    }
    
    //MARK - Private Methods
    
    private func beginForegroundTracking() {
        manager.startUpdatingLocation()
    }
    
    private func stopForegroundTracking() {
        manager.stopUpdatingLocation()
    }
    
    private func beginBackgroundTracking() {
        manager.startMonitoringSignificantLocationChanges()
    }
    
    private func stopBackgroundTracking() {
        manager.stopMonitoringSignificantLocationChanges()
    }
    
    func updateTrackingMethod(_ type: TrackingType) {
        switch type {
        case .foreground:
            stopBackgroundTracking()
            beginForegroundTracking()
        case .background:
            stopForegroundTracking()
            beginBackgroundTracking()
        case .combined:
            beginBackgroundTracking()
            beginForegroundTracking()
        case .none:
            stopForegroundTracking()
            stopBackgroundTracking()
        }
    }
    
    private func requestPermission() -> Void {
        checkAuth(CLLocationManager.authorizationStatus())
    }
    
    private func checkAuth(_ status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            print("🛰 Tracking Authorized")
        case .authorizedWhenInUse:
            print("🛰 Tracking Authorized While Using")
        case .denied:
            print("🛰 Tracking Denied, Abort")
        case .notDetermined:
            print("🛰 Tracking Unknown, requesting permissions")
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("🛰 Tracking Restricted, Abort")
        }
        
    }
    
    // MARK: - Region Monitoring
    func monitorRegion(_ region: CLRegion) {
        manager.startMonitoring(for: region)
    }

    func stopMonitoring(region: CLRegion){
        manager.stopMonitoring(for: region)
    }
    
}


// MARK: - Reactive Extensions
fileprivate class RxLocationManagerDelegateProxy: DelegateProxy<LocationManager, CLLocationManagerDelegate>, CLLocationManagerDelegate, DelegateProxyType {
    static func currentDelegate(for object: LocationManager) -> CLLocationManagerDelegate? {
        return object.manager.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: LocationManager) {
        object.manager.delegate = delegate
    }
    
    init(locationManager: LocationManager) {
       super.init(parentObject: locationManager, delegateProxy: RxLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { (parent: LocationManager) -> RxLocationManagerDelegateProxy in
            RxLocationManagerDelegateProxy(locationManager: parent)
        }
    }
}


extension Reactive where Base: LocationManager { // Transform delegates into observables
    var delegate: DelegateProxy<LocationManager, CLLocationManagerDelegate> {
        return RxLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var enteredRegion: Observable<CLRegion> {
        let didEnterRegionSelector = #selector(CLLocationManagerDelegate.locationManager(_:didEnterRegion:))
        return delegate.methodInvoked(didEnterRegionSelector)
            .map { params in
                return params[1] as! CLRegion
        }
    }
    
    var exitedRegion : Observable<CLRegion> {
        let leftRegionSelector = #selector(CLLocationManagerDelegate.locationManager(_:didExitRegion:))
        return delegate.methodInvoked(leftRegionSelector)
            .map { params in
                return params[1] as! CLRegion
        }
        
    }
    
    var updatedLocations: Observable<[CLLocation]> {
        let selector = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return delegate.methodInvoked(selector)
            .map { params in
                return params[1] as! [CLLocation]
        }
    }
}
