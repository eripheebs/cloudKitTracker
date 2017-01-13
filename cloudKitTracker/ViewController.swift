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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let cloudRepo: CloudRepo = CloudRepo()

    var user: User!
    var once = true
    
    let LONDON_LONG = 51.5074
    let LONDON_LAT = 0.1278
    let DEFAULT_USERNAME = "Anonymous"
    
    var username: String = "" {
        didSet {
            print("Updated username from \(oldValue) to \(username)")
            user.username = username
            updateUserData()
        }
    }
    
    @IBAction func setUsernameButtonClicked(_ sender: Any) {
        username = usernameField.text!
    }
    
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
        }
        else{
            print("Location service disabled");
        }
        
        
        initUser()
        username = DEFAULT_USERNAME
        
        cloudRepo.getUsers()
        
    }
    
    func initUser(){
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        user = User(username: DEFAULT_USERNAME, long: NSNumber(value: LONDON_LONG), lat: NSNumber(value: LONDON_LAT), updateTime: Date(), recordID: CKRecordID(recordName: uuid))

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        user.lat = NSNumber(value: location.coordinate.latitude)
        user.long = NSNumber(value: location.coordinate.longitude)
        user.updateTime = Date()
        
        centerMapOn(user)

        updateUserData()
    }
    
    func updateUserData(){
        cloudRepo.updateUserLocation(user: user)
    }
    
    func centerMapOn(_ user: User){
        let center = CLLocationCoordinate2D(latitude: user.lat.doubleValue, longitude: user.long.doubleValue)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)

    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Did pause")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("Did resume")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failure! Error: \(error)")
    }

}

