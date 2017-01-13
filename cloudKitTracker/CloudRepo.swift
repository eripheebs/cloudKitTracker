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
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil){ (results, error) -> Void in
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
