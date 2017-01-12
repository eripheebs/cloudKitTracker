//
//  CloudCalls.swift
//  cloudKitTracker
//
//  Created by Pheby, Erika (UK - London) on 12/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

class CloudRepo {
    
    func getUsers(){
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        privateDatabase.perform(query, inZoneWith: nil){ (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                for result in results! {
                    print(result)
                }
            }
            
        }
    }
    
}
