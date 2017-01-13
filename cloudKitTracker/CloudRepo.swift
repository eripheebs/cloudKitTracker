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
    
    var users = [Any]()
    
    let database: CKDatabase
    let container = CKContainer(identifier: "iCloud.CloudKitErikaMatt")
    
    init() {
        database = container.publicCloudDatabase
    }
 
    func getUsers(){
        let query = CKQuery(recordType: "user", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil){ (results, error) -> Void in
            if error != nil {
                print(error as! String)
            } else {
                self.users = results!
            }
            
        }
    }
    
    func updateUserLocation(user: User) {
        database.fetch(withRecordID: user.recordID, completionHandler: { (record, error) in
            if error != nil {
                if (error as! CKError).code == CKError.unknownItem {
                    print("Item not found - creating user...")
                    let mappedRecord = self.mapToRecord(user: user)
                    let modifiedRecord = self.addUserDetailsToRecord(user: <#T##User#>, record: mappedRecord)
                    self.saveUserToDatabase(user: user, record: modifiedRecord, successMessage: "Record created")
                    
                } else {
                    print("Error occured: \(error)")
                }
                
            } else {
                let modifiedRecord = self.addUserDetailsToRecord(user: <#T##User#>, record: record!)
                self.saveUserToDatabase(user: user, record: modifiedRecord, successMessage: "Record updated")
            }
        })
    }
    
    func mapToRecord(user: User) -> CKRecord{
        return CKRecord(recordType: "user", recordID: user.recordID)
    }
    
    func addUserDetailsToRecord(user: User, record: CKRecord) -> CKRecord {
        record.setObject(user.username as CKRecordValue?, forKey: "username")
        record.setObject(user.updateTime as CKRecordValue?, forKey: "updateTime")
        record.setObject(user.lat as CKRecordValue?, forKey: "lat")
        record.setObject(user.long as CKRecordValue?, forKey: "long")
        
        return record
    }
    
    func saveUserToDatabase(user: User, record: CKRecord, successMessage: String){
        self.database.save(record, completionHandler:{(saveRecord, saveError) in
            if saveError != nil {
                print("Error occured: \(saveError)")
            } else {
                print(successMessage)
            }
        })
    }
    
}
