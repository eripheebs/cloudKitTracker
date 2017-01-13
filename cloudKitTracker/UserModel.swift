//
//  UserModel.swift
//  cloudKitTracker
//
//  Created by Pheby, Erika (UK - London) on 13/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

class User {
    
    var username: String
    var long: NSNumber
    var lat: NSNumber
    var updateTime: Date
    var recordID: CKRecordID
   
    
    init(username: String, long: NSNumber, lat: NSNumber, updateTime: Date, recordID: CKRecordID) {
         self.username = username
         self.long = long
         self.lat = lat
         self.updateTime = updateTime
         self.recordID = recordID
        
    }
    
     var coordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(CLLocationDegrees(self.lat), CLLocationDegrees(self.long))
        }
    }
}
