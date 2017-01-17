//
//  NavigationHelper.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 17/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import SlideMenuControllerSwift
import UIKit


class NavigationHelper : BaseNavigationHelper, MenuViewControllerDelegate {
    
    enum State {
        case Main
        case NearbyUsers
        case Profile
    }
    
    weak var menuButton: UIButton!
    
    var parentSlideMenuController: SlideMenuController?
    
    var mapViewController: MapViewController
    var profileViewController: ProfileViewController
    
    init(parent: UIViewController, container: UIView, mapViewController: MapViewController, profileViewController: ProfileViewController) {
        
        self.mapViewController = mapViewController
        self.profileViewController = profileViewController
        
        super.init(parent: parent, container: container, initialViewController: mapViewController)
    }
    
    
    // Delegate methods for navigation
    
    func homeClicked(sender: MenuViewController){
        self.switchToView(controller: self.mapViewController)
        
        hideMenuBar()
        setMenuButtonColour(.lightText)
    }
    
    func nearbyUsersClicked(sender: MenuViewController){
        // TODO
        setMenuButtonColour(.darkText)
    }
    
    func profileClicked(sender: MenuViewController){
        
        self.switchToView(controller: self.profileViewController)
        
        hideMenuBar()
        setMenuButtonColour(.darkText)
    }
    
    func hideMenuBar(){
        parentSlideMenuController?.closeLeft()
    }
    
    func showMenuBar(){
        parentSlideMenuController?.openLeft()
    }
    
    func setMenuButtonColour(_ color: UIColor) {
        let origImage = UIImage(named: "hamburger");
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton?.setImage(tintedImage, for: .normal)
        menuButton?.tintColor = color
        menuButton?.titleLabel?.textColor = color
    }
    
}
