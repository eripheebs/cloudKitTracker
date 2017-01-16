//
//  MePin.swift
//  cloudKitTracker
//
//  Created by Pheby, Erika (UK - London) on 16/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import MapKit

class MePin: User, MKAnnotation {
    
    var title: String? {
        get {
            return username
        }
    }
    
    
    init(user: User) {
        super.init(username: user.username, long: user.long, lat: user.lat, updateTime: user.updateTime, recordID: user.recordID)
        
    }
    
    func getPinView(pinView: MKPinAnnotationView) -> MKPinAnnotationView {
        
        pinView.canShowCallout = true
        pinView.animatesDrop = true
        pinView.pinTintColor = .purple
        
        return pinView
    }
}
