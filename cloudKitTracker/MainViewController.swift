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
import SlideMenuControllerSwift

class MainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ProfileViewControllerDelegate {
    
    static let uuid = UIDevice.current.identifierForVendor!.uuidString

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    var locationManager = CLLocationManager()
    var parentSlideMenuController: SlideMenuController?
    var mapViewController: MapViewController?
    var profileViewController: ProfileViewController?
    var menuViewController: MenuViewController?

    
    let cloudRepo: CloudRepo = CloudRepo()
    var navigationHelper: NavigationHelper?
    
    var user: User! {
        didSet {
            //username = user.username
            self.profileViewController?.user = self.user
        }
    }
    
    let LONDON_LONG = 51.5074
    let LONDON_LAT = 0.1278
    let DEFAULT_USERNAME = "Anonymous"
    
    var loaded = false
    
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        navigationHelper?.showMenuBar()
    }
    
    // Delegate method from ProfileViewController
    func userUpdated(sender: ProfileViewController) {
        
    }
    
    override func viewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.mapViewController = storyboard.instantiateViewController(withIdentifier: "mapView") as? MapViewController
        self.profileViewController = storyboard.instantiateViewController(withIdentifier: "profileView") as? ProfileViewController
        
        self.profileViewController!.delegate = self
        
        self.mapViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.profileViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.navigationHelper = NavigationHelper(parent: self, container: self.containerView, mapViewController: self.mapViewController!, profileViewController: self.profileViewController!)
        
        self.navigationHelper!.menuButton = menuButton!
        self.navigationHelper!.parentSlideMenuController = parentSlideMenuController
        self.menuViewController!.delegate = self.navigationHelper!
        
        super.viewDidLoad()
        
        cloudRepo.loadUsers(callback: self.userDataUpdated)
        startUpdateTimers()
    }
    
    func startUpdateTimers(){
        // Send user updates
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.sendUserUpdate), userInfo: nil, repeats: true)
        
        // Get date of users
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loadUserData), userInfo: nil, repeats: true)
    }
    
    func initUser(){
    
        if let user = cloudRepo.getUserFrom(uuid: MainViewController.uuid){
            self.user = user
        } else {
            self.user = User(username: DEFAULT_USERNAME, long: NSNumber(value: LONDON_LONG), lat: NSNumber(value: LONDON_LAT), updateTime: Date(), recordID: CKRecordID(recordName: MainViewController.uuid))
        }
    }
    
    
    // Callback called when user update received
    func userDataUpdated(error: CKError?){
        
        if error != nil {
            print(error ?? "There was an unexpected error which couldn't be implicitly coerced to a string")
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
        } else {
            print("Location service disabled");
        }
        
    
        loaded = true
    }
    
   
    
    func loadUserData(){
        if loaded {
            cloudRepo.loadUsers(callback: self.userDataUpdated)
        }
    }
    
    func sendUserUpdate(){
        if loaded {
            cloudRepo.updateUserLocation(user: user)
        }
    }

    // GPS Update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        user.lat = NSNumber(value: location.coordinate.latitude)
        user.long = NSNumber(value: location.coordinate.longitude)
        user.updateTime = Date()
    }
    
    func centerMapOn(_ user: User){
        mapViewController?.centerMapOn(user)
    }
    
    func addUsersToMap(_ users: [User]) {
        mapViewController?.addPinsToMap(users: users)
    }
    
    // //////////////////// //
    
    func dispatchOnMainThread(closure: @escaping () -> ()) {
        DispatchQueue.global().async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async(execute: closure)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

