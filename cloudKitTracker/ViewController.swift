//
//  ViewController.swift
//  cloudKitTracker
//
//  Created by Pheby, Erika (UK - London) on 12/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization();
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue : CLLocationCoordinate2D = manager.location!.coordinate;
        let span2 = MKCoordinateSpanMake(1, 1)
        let long = locValue.longitude;
        let lat = locValue.latitude;
        print(long);
        print(lat);
        let loadlocation = CLLocationCoordinate2D(
            latitude: lat, longitude: long
            
        )
        
        locationManager.stopUpdatingLocation();
    }

}

