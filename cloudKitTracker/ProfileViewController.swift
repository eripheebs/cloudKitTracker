//
//  ProfileViewController.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 17/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func setUsernameClicked(_ sender: Any) {
        user?.username = usernameField.text!
        delegate?.userUpdated(sender: self)
    }
    
    weak var delegate: ProfileViewControllerDelegate?
    
    var user: User? {
        didSet {
            usernameField?.text = user?.username
        }
    }
    
}

protocol ProfileViewControllerDelegate : class {
    func userUpdated(sender: ProfileViewController)
}
