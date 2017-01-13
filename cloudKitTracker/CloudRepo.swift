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
    
    var data = [Any]()
    
    let publicDatabase: CKDatabase
    let container = CKContainer(identifier: "iCloud.CloudKitErikaMatt")
    let predicate = NSPredicate(value: true)
    
    init() {
        publicDatabase = container.publicCloudDatabase
    }
    
    func getUsers(){
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil){ (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                self.data = results!
                for result in results! {
                    
                }
            }
            
        }
    }
    
    func updateUserLocation(user: User) {
        publicDatabase.fetch(withRecordID: user.recordID, completionHandler: { (record, error) in
            if error != nil {
                if (error as! CKError).code == CKError.unknownItem {
                    print("Item not found - creating user...")
                    self.createUser(user: user)
                } else {
                    print("Error occured: \(error)")
                }
                
            } else {
                record!.setObject(user.username as CKRecordValue?, forKey: "username")
                record!.setObject(user.updateTime as CKRecordValue?, forKey: "updateTime")
                record!.setObject(user.lat as CKRecordValue?, forKey: "lat")
                record!.setObject(user.long as CKRecordValue?, forKey: "long")
                
                self.publicDatabase.save(record!, completionHandler:{(saveRecord, saveError) in
                    if saveError != nil {
                        print("Error occured: \(saveError)")
                    } else {
                        print("Record updated")
                    }
                })
            }
        })
    }
    
    func createUser(user: User){
        let record = CKRecord(recordType: "user", recordID: user.recordID)
        
        record.setObject(user.username as CKRecordValue?, forKey: "username")
        record.setObject(user.updateTime as CKRecordValue?, forKey: "updateTime")
        record.setObject(user.lat as CKRecordValue?, forKey: "lat")
        record.setObject(user.long as CKRecordValue?, forKey: "long")
        
        self.publicDatabase.save(record, completionHandler:{(saveRecord, saveError) in
            if saveError != nil {
                print("Error occured: \(saveError)")
            } else {
                print("Record created")
            }
        })
    }
    
}
