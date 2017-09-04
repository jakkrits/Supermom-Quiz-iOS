//
//  AppDelegate.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/6/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RevMobAdsDelegate, ChartboostDelegate {
    
    var window: UIWindow?
    var activityView = UIView(frame: UIScreen.mainScreen().bounds)
    var activityIndicatorView = IndicatorView()
    var takeAnotherChallenge = false
    
    let reachability = Reachability.reachabilityForInternetConnection()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        application.registerForRemoteNotifications()
        
        //Appearance
        UINavigationBar.appearance().barStyle = .BlackTranslucent
        UINavigationBar.appearance().barTintColor = UIColor(red:1, green:0.31, blue:0.32, alpha:1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        //Reachability
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: nil)
        reachability!.startNotifier()
        
        if AISettings.sharedInstance.requiredAdDisplay() {
            //Chartboost
            Chartboost.startWithAppId(Constants.kChartboostAppID, appSignature: Constants.kChartboostAppSignature, delegate: self)
            Chartboost.showInterstitial(CBLocationDefault)
            
            //RevMob
            RevMobAds.startSessionWithAppID(Constants.kRevmobAppID, withSuccessHandler: { () -> Void in
                if AISettings.sharedInstance.requiredAdDisplay() && AISettings.sharedInstance.isGameScreenVisible {
                    let popUp = RevMobAds.session().popup()
                    popUp.loadWithSuccessHandler({ (popup) -> Void in
                        popup.showAd()
                        }, andLoadFailHandler: { (popup, error) -> Void in
                            print("Revmob Error: \(error)")
                        }, onClickHandler: { (popup) -> Void in
                            print("Ads Clicked")
                    })
                } else if AISettings.sharedInstance.requiredAdDisplay() {
                    RevMobAds.session().showFullscreen()
                }
                }, andFailHandler: { (error) -> Void in
                    print("Revmob error: \(error)")
            })
            
        }
        
        //Parse
        Parse.enableLocalDatastore()
        Parse.setApplicationId(Constants.kParseAppID,
            clientKey: Constants.kParseClientKey)
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        
        //Downloading ProductIdentifiers from Dropbox
        //Checking for new content
        if reachability!.isReachable() {
            AIProducts.sharedInstance
        }
        copyBundleResourcesToDeviceSandbox()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        if AISettings.sharedInstance.isGameCenterSupported == true {
            TurnBasedGameHelper.sharedInstance.authenticateLocalPlayer()
        }
        
        if AISettings.sharedInstance.isGameScreenVisible {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.SkipCurrentQuestion, object: nil)
        }
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Indicator View
    func showActivityIndicator() {
        activityView.alpha = 0.65
        activityView.userInteractionEnabled = false
        activityView.backgroundColor = UIColor.blackColor()
        activityIndicatorView = IndicatorView(frame: CGRectMake(activityView.frame.midX, activityView.frame.midY, 200, 100))
        activityIndicatorView.addFlashingAnimationAnimation()
        activityView.addSubview(activityIndicatorView)
        
        activityView.userInteractionEnabled = false
        UIView.animateWithDuration(0.5) { () -> Void in
            self.activityView.hidden = false
        }
        
        self.window?.addSubview(activityView)
        
        activityIndicatorView.center = activityView.center
        activityView.center = self.window!.center
    }
    
    func hideActivityIndicator() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.activityView.hidden = true
        }
        activityIndicatorView.removeFromSuperview()
    }
    
    //MARK: - Reachability
    func reachabilityChanged(notification: NSNotification) {
        print("internet connection changed")
        let reachability = notification.object as! Reachability
        if reachability.isReachable() {
            print("internet becomes available")
        } else {
            print("internet not available")
        }
    }
    //CHARTBOOST DELEGATE METHODS
    func didFailToLoadMoreApps(error: CBLoadError) {
        print(error)
    }
    
    func didDismissInterstitial(location: String!) {
        print(location)
        Chartboost.cacheInterstitial(location)
    }
    
    func didDismissMoreApps() {
        //Chartboost.cacheMoreApps(<#location: String!#>)
    }
    
    func shouldRequestInterstitial(location: String!) -> Bool {
        return true
    }
    
    //REVMOB DELEGATES
    func revmobSessionIsStarted() {
        print("RevMob Session has started.")
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "RevmobSessionStarted", object: nil))
    }
    
    func revmobSessionNotStartedWithError(error: NSError!) {
        print("error revmob delegate")
        print(error)
    }
    
    func revmobAdDidFailWithError(error: NSError!) {
        print("revmob did fail")
        print(error)
    }
    
    //MARK: - File Management
    func copyBundleResourcesToDeviceSandbox() {
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(DocumentPath.kQuizDataSandboxPath) {
            try! fileManager.removeItemAtPath(DocumentPath.kQuizDataSandboxPath)
        }
        
        do {
            try fileManager.copyItemAtPath(DocumentPath.kQuizDataFolderPath!, toPath: DocumentPath.kQuizDataSandboxPath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
}

