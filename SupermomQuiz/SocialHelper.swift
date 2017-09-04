//
//  SocialHelper.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 12/7/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation
import Social

struct Service {
    static let Twitter = "twitter"
    static let Facebook = "facebook"
}

class SocialHelper {
    static let sharedInstance = SocialHelper()
    
    init() {
        print("Social class initialized")
    }
    
    func beginTwitting() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterComposeVC.setInitialText("Yo! I AM SUPERMOM! Beat me if you can!")
            showComposeViewController(twitterComposeVC)
        } else {
            showAlert(Service.Twitter)
        }
    }
    
    func beginFacbooking() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookComposerVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookComposerVC.setInitialText("Yo! I AM SUPERMOM! Beat me if you can!")
            showComposeViewController(facebookComposerVC)
        } else {
            showAlert(Service.Facebook)
        }
    }
    
    
    func showAlert(service: String) {
        
        if service == Service.Twitter {
            let alertVC = UIAlertController(title: "Twitter Error", message: "Please log on to your Twitter account", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            if let vc = AIUtilities.getVCPresentedByTopVC() {
                vc.presentViewController(alertVC, animated: true, completion: nil)
            }
        } else if service == Service.Facebook {
            let alertVC = UIAlertController(title: "Facebook Error", message: "Please log on to your Facebook account", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            if let vc = AIUtilities.getVCPresentedByTopVC() {
                vc.presentViewController(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func showComposeViewController(composerVC: SLComposeViewController) {
   
        if let vc = AIUtilities.getVCPresentedByTopVC() {
            vc.presentViewController(composerVC, animated: true, completion: nil)
        }
    }
    
    

}














