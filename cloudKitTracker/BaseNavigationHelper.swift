//
//  NavigationHelper.swift
//  cloudKitTracker
//
//  Created by Davis, Matt B (UK - London) on 17/01/2017.
//  Copyright © 2017 Pheby, Erika (UK - London). All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationHelper {
    
    let parent: UIViewController
    let containerView: UIView
    
    var currentViewController: UIViewController
    
    init(parent: UIViewController, container: UIView, initialViewController: UIViewController){
        self.parent = parent
        self.containerView = container
        self.currentViewController = initialViewController
        
        self.parent.addChildViewController(initialViewController)
        addSubview(subView: initialViewController.view, toView: self.containerView)
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        guard oldViewController != newViewController else { return }
        oldViewController.willMove(toParentViewController: nil)
        parent.addChildViewController(newViewController)
        addSubview(subView: newViewController.view, toView: self.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self.parent)
        })
        
        self.currentViewController = newViewController
    }
    
    func switchToView(controller newViewController: UIViewController){
        cycleFromViewController(oldViewController: currentViewController, toViewController: newViewController)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
}
