//
//  UserModel.swift
//  cloudKitTracker
//
//  Created by Pheby, Erika (UK - London) on 13/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import CloudKit

struct User {
    var username: String
    var long: NSNumber
    var lat: NSNumber
    var updateTime: Date
    var recordID: CKRecordID
}
