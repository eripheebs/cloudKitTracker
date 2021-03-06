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
import Dispatch

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    let cloudRepo: CloudRepo = CloudRepo()
    
    let uuid = UIDevice.current.identifierForVendor!.uuidString

    var user: User! {
        didSet {
            username = user.username
        }
    }
    
    var once = true
    
    let LONDON_LONG = 51.5074
    let LONDON_LAT = 0.1278
    let DEFAULT_USERNAME = "Anonymous"
    
    var loaded = false
    
    var username: String = "" {
        didSet {
            print("Updated username from \(oldValue) to \(username)")
            user.username = username
            
            dispatchOnMainThread {
                self.usernameField.text = self.username
            }
        }
    }
    
    @IBAction func setUsernameButtonClicked(_ sender: Any) {
        username = usernameField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        cloudRepo.loadUsers(callback: self.usersLoaded)
        let sendUserUpdateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.sendUserUpdate), userInfo: nil, repeats: true)
        let loadUserDataTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loadUserData), userInfo: nil, repeats: true)
    }
    
    func initUser(){
    
        if let user = cloudRepo.getUserFrom(uuid: uuid){
            self.user = user
        } else {
            self.user = User(username: DEFAULT_USERNAME, long: NSNumber(value: LONDON_LONG), lat: NSNumber(value: LONDON_LAT), updateTime: Date(), recordID: CKRecordID(recordName: uuid))
        }
    }
    
    
    
    func usersLoaded(error: CKError?){
        
        if error != nil {
            print(error)
        }
        
        if !loaded {
            initUser()
        }
        
        dispatchOnMainThread {
            let users = self.cloudRepo.users
            self.addUsersToMap(users)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            mapView.delegate = self
        } else {
            print("Location service disabled");
        }
    
        loaded = true
    }
    
    func addUsersToMap(_ users: [User]){
        
        let pinsExceptUs = users.filter(userIsNotSelf)
        
        let pins = pinsExceptUs.map(){ (pinUser: User) -> MKPointAnnotation in
            let pin = MKPointAnnotation()
            pin.title = pinUser.username
            pin.subtitle = pinUser.timeString
            pin.coordinate = pinUser.coordinate
            return pin
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.addMePin(users)
        self.mapView.addAnnotations(pins)
    }

    
    func addMePin(_ users: [User]){
        let me = users.filter(userIsSelf)[0]
        let mePin = MePin(user: me)
        self.mapView.addAnnotation(mePin as MKAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if annotation is MePin {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView = (annotation as! MePin).getPinView(pinView: pinView!)
        } else {
            
            return nil
        }
    
        return pinView
    }
    
    func userIsNotSelf(user: User) -> Bool {
        return !userIsSelf(user: user)
    }
    
    func userIsSelf(user: User) -> Bool{
        return user.recordID.recordName == uuid
    }
    
    func loadUserData(){
        if loaded {
            cloudRepo.loadUsers(callback: self.usersLoaded)
        }
    }
    
    func sendUserUpdate(){
        if loaded {
            cloudRepo.updateUserLocation(user: user)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        user.lat = NSNumber(value: location.coordinate.latitude)
        user.long = NSNumber(value: location.coordinate.longitude)
        user.updateTime = Date()
        
        centerMapOn(user)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dispatchOnMainThread(closure: @escaping () -> ()) {
        DispatchQueue.global().async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async(execute: closure)
        }
    }

}

