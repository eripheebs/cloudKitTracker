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
import CloudKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var once = true
    let cloudRepo: CloudRepo = CloudRepo()

    var user = User(username: "blahhhh", long: 10.333, lat: 1232.3, updateTime: Date(), recordID: CKRecordID(recordName: "1234"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            
            
            testLabel.text = "Started updating location" 
        }
        else{
            print("Location service disabled");
        }
        
        cloudRepo.getUsers()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if once {
            cloudRepo.updateUserLocation(user: user)

            once = false
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("did pause")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("did resume")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("did start monitoring for")
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("FAILURE!!!!!!!!!")
    }

}

