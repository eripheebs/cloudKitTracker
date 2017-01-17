//
//  MenuViewController.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 17/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import UIKit


class MenuViewController: UIViewController {
    
    @IBAction func homeClicked(_ sender: Any) {
        delegate?.homeClicked(sender: self)
    }
    
    @IBAction func nearbyUsersClicked(_ sender: Any) {
        delegate?.nearbyUsersClicked(sender: self)
    }
    
    @IBAction func profileClicked(_ sender: Any) {
        delegate?.profileClicked(sender: self)
    }

    weak var delegate: MenuViewControllerDelegate?
    
}

protocol MenuViewControllerDelegate : class {
    func homeClicked(sender: MenuViewController)
    func nearbyUsersClicked(sender: MenuViewController)
    func profileClicked(sender: MenuViewController)
}
