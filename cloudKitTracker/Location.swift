//
//  Location.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 12/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class Location : NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let parent : CLLocationManagerDelegate
    
    init (parent: CLLocationManagerDelegate){
        self.parent = parent
        super.init()
        
        /*88
        // Ask for Authorisation from the User.
        parent.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.parent.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
 
        }
 */
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
}
