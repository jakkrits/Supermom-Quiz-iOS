//
//  SettingsViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 6/22/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override var preferredContentSize: CGSize {
        get {
            return super.preferredContentSize
        }
        set { super.preferredContentSize = newValue }
    }

    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var showExplanationSwitch: UISwitch!
    @IBOutlet weak var removeAdsSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AISettings.sharedInstance.isSoundsOn == true {
            soundSwitch.on = true
        } else {
            soundSwitch.on = false
        }
        
        if AISettings.sharedInstance.showExplanation == true {
            showExplanationSwitch.on = true
        } else {
            showExplanationSwitch.on = false
        }

        let removeAdsID = AISettings.sharedInstance.removeAdsProductIdentifier!
        if NSUserDefaults.standardUserDefaults().boolForKey(removeAdsID) == true {
            AISettings.sharedInstance.isAdsTurnedOff = true
        }
        
        if AISettings.sharedInstance.isAdsTurnedOff == true {
            removeAdsSwitch.on = false
            removeAdsSwitch.userInteractionEnabled = false
        } else {
            removeAdsSwitch.on = true
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func soundOnOrOff(sender: UISwitch) {
        AISettings.sharedInstance.setSoundsEnabled(sender.on)
    }
    
    @IBAction func explanationOnOrOff(sender: UISwitch) {
        if sender.on == true {
            AISettings.sharedInstance.setShowExplanationOption(true)
        } else {
            AISettings.sharedInstance.setShowExplanationOption(false)
        }
    }
    
    @IBAction func removeAdSwitchPressed(sender: UISwitch) {
            let alertController = UIAlertController(title: "Remove Ads", message: "Please purchase 'Remove Ads' in the product table", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    InAppHelper.sharedInstance.loadProducts()
                })
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
}