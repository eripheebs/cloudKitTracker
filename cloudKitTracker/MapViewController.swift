//
//  MapViewController.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 17/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CloudKit

class MapViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    func addPinsToMap(users: [User]){
        
        let pinsExceptUs = users.filter(userIsNotSelf)
        
        let pins = pinsExceptUs.map(){ (pinUser: User) -> MKPointAnnotation in
            let pin = MKPointAnnotation()
            pin.title = pinUser.username
            pin.subtitle = pinUser.timeString
            pin.coordinate = pinUser.coordinate
            return pin
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(pins)
        self.mapView.addAnnotation(getMePin(users: users))
    }
    
    
    func getMePin(users: [User]) -> MKAnnotation{
        let me = users.filter(userIsSelf)[0]
        return MePin(user: me)
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
        return user.recordID.recordName == MainViewController.uuid
    }
    
    
    func centerMapOn(_ user: User){
        let center = CLLocationCoordinate2D(latitude: user.lat.doubleValue, longitude: user.long.doubleValue)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }

}
