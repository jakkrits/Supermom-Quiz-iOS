//
//  MainNavigationController.swift
//  SupermomQuiz
//
//  Created by Jakkrit on 6/16/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import UIKit
import GameKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticationViewController", name: Notification.PresentAuthenticationVC, object: nil)
       
        TurnBasedGameHelper.sharedInstance.authenticateLocalPlayer()
        
        super.viewDidLoad()
        
        
        
    }

    func showAuthenticationViewController() {
        print(__FUNCTION__)
        let gameKitHelper = TurnBasedGameHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            topViewController!.presentViewController(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print(__FUNCTION__)
    }
}
