//
//  MainViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/10/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import GameKit
//DELETE
import Parse

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate, GKGameCenterControllerDelegate, TurnBasedGameHelperDelegate {
    
    @IBOutlet weak var mommyLogo: MommyLogo!
    
    var authenticationViewController: UIViewController?
    var fullScreenAds: RevMobFullscreen?
    var bannerAd: RevMobBanner?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //BarButtonItem
    private let gearIcon = GearIcon(frame: CGRectMake(0, 0, 44, 44))
    private let infoIcon = InfoIcon(frame: CGRectMake(0, 0, 44, 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        //Add Observer for successfully loaded products
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "productsLoaded:", name: IAP.ProductsLoadedNotification, object: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if AISettings.sharedInstance.requiredAdDisplay() {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64(NSEC_PER_SEC) * 3)), dispatch_get_main_queue(), { () -> Void in
                Chartboost.showInterstitial(CBLocationDefault)
                if let fullScreenAds = RevMobAds.session().fullscreen() {
                    fullScreenAds.loadAd()
                    fullScreenAds.showAd()
                }
            })
        }
        
        if AISettings.sharedInstance.isMultiplayerSupportEnabled == true {
            TurnBasedGameHelper.sharedInstance.delegate = self
        }
        
        if appDelegate.takeAnotherChallenge == true {
            self.playMultiplayerGame(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if AISettings.sharedInstance.requiredAdDisplay() {
            fullScreenAds?.delegate = nil
            bannerAd?.hideAd()
        }
    }
    
    private func configureUI () {
        //Configure Nav Bar Items
        //Left
        let leftButton = UIButton(type: .Custom)
        leftButton.addTarget(self, action: "showSettingsViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        leftButton.frame = gearIcon.frame
        gearIcon.addSubview(leftButton)
        let leftBarButtonItem = UIBarButtonItem(customView: gearIcon)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //Right
        let rightButton = UIButton(type: .Custom)
        rightButton.addTarget(self, action: "showAboutViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.frame = infoIcon.frame
        infoIcon.addSubview(rightButton)
        let rightBarButtonItem = UIBarButtonItem(customView: infoIcon)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        mommyLogo.addMommyAnimationsAnimationCompletionBlock { (finished) -> Void in
            if finished {
                print("animated")
            }
        }
    }
    
    func showSettingsViewController(sender: UIButton) {
        SoundManager.sharedInstance.playTapSound()
        performSegueWithIdentifier(SegueID.MainVCToSettingsSegue, sender: self)
    }
    
    func showAboutViewController(sender: UIButton) {
        SoundManager.sharedInstance.playTapSound()
        performSegueWithIdentifier(SegueID.MainVCToAboutSeque, sender: self)
    }
    
    @IBAction func logoDidTap(sender: UITapGestureRecognizer) {
        mommyLogo.addMommyAnimationsAnimationCompletionBlock { (finished) -> Void in
            if finished {
                print("animated")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if let settingsVC = segue.destinationViewController as? SettingsViewController {
            if let popOverVC = settingsVC.popoverPresentationController {
                popOverVC.delegate = self
            }
        }
        
        if segue.identifier == SegueID.MainVCToChooseQuizSegue {
            SoundManager.sharedInstance.playTapSound()
            AISettings.sharedInstance.isMultiplayerGame = false
            
            let chooseQuizVC = segue.destinationViewController as! ChooseQuizCategoryTableViewController
            chooseQuizVC.freeAndPurchasedQuiz = AIQuizDataManager().freeAndPurchasedQuizCategory
            
            
        } else if segue.identifier == SegueID.MainVCToAboutSeque {
            SoundManager.sharedInstance.playTapSound()
        }
        
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //MARK: - Actions
    @IBAction func getMoreCategories(sender: UIButton) {
        SoundManager.sharedInstance.playTapSound()
        _ = AIQuizDataManager.sharedInstance.purchaseRequiredQuizCategory
        InAppHelper.sharedInstance.loadProducts()
    }
    
    @IBAction func showScores(sender: UIButton) {
        SoundManager.sharedInstance.playTapSound()
        let gameViewController = GKGameCenterViewController()
        gameViewController.gameCenterDelegate = self
        gameViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        presentViewController(gameViewController, animated: true, completion: nil)
    }
    
    @IBAction func playMultiplayerGame(sender: AnyObject) {
        
        if Reachability.reachabilityForInternetConnection() != nil {
            SoundManager.sharedInstance.playTapSound()
            TurnBasedGameHelper.sharedInstance.findMatch(2, maxPlayers: 2, presentingViewController: self, showExistingMatches: !appDelegate.takeAnotherChallenge)
            appDelegate.takeAnotherChallenge = false
            
            if !GKLocalPlayer.localPlayer().authenticated {
                let alert = UIAlertController(title: "Game Center?", message: "Please enable and sign-in Game Center in Settings", preferredStyle: UIAlertControllerStyle.ActionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (_) -> Void in
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alertVC = UIAlertController(title: "No Internet", message: "Internet connection error, please try again later.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    //GameKit Delegate
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Turnbased Delegate
    func enterNewGame(match: GKTurnBasedMatch) {
        print(__FUNCTION__)
        
        let json = JSON(data: match.matchData!, options: .AllowFragments, error: nil)
        
        AISettings.sharedInstance.isMultiplayerGame = true
        SoundManager.sharedInstance.playTapSound()
        let chooseQuizTableVC = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardID.ChooseQuizTableVC) as! ChooseQuizCategoryTableViewController
        chooseQuizTableVC.freeAndPurchasedQuiz = AIQuizDataManager().freeAndPurchasedQuizCategory
        self.navigationController?.pushViewController(chooseQuizTableVC, animated: true)
    }
    
    func layoutMatch(match: GKTurnBasedMatch) {
        print("Viewing match where it's not our turn")
        let statusString = ""
        if match.status == GKTurnBasedMatchStatus.Ended {
            let turnBasedFinalVC = TurnBasedFinalViewController()
            turnBasedFinalVC.match = match
            turnBasedFinalVC.presentedModally = false
            let navController = UINavigationController(rootViewController: turnBasedFinalVC)
            self.presentViewController(navController, animated: true, completion: nil)
        } else {
            var playerNumber = 0
            if let playerNum = match.participants?.indexOf(match.currentParticipant!) {
                playerNumber = playerNum + 1
                let alert = UIAlertController(title: "Match Status", message: "Waiting for Player #\(playerNumber)'s turn", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        if !statusString.isEmpty {
            let alert = UIAlertController(title: "Status", message: statusString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func takeTurn(match: GKTurnBasedMatch) {
        AISettings.sharedInstance.isMultiplayerGame = true
        var error = false
        print(match.matchData!.length)
        if match.matchData!.length == 0 {
            return
        }
        if match.matchData!.length > 0 {
            TurnBasedGameHelper.sharedInstance.saveToLoseList = true
        }
        
        let currentVersion = NSBundle.mainBundle().infoDictionary?[String(kCFBundleVersionKey)] as! String
        
        let quizDict = AIQuizDataManager.sharedInstance.dataDictionaryFromPreviousParticipantMatchData(match.matchData!)
        
        if let appVersion = quizDict["v"]?.intValue where (Int(currentVersion)! != nil) {
            if Int(currentVersion)! > appVersion {
                let alert = UIAlertController(title: "Update!", message: "To accept this match, update your app to the latest version", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Update", style: .Default, handler: { (action) -> Void in
                    let appURL = AISettings.sharedInstance.applicationiTunesLink
                    UIApplication.sharedApplication().openURL(NSURL(string: appURL)!)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        
        let matchCategoryDict = quizDict["category"]
        print(matchCategoryDict)
        let categoryID = matchCategoryDict?.dictionaryObject?[Constants.kquizCategoryId] as! String
        let localCategoryDict = AIQuizDataManager.sharedInstance.categoryDictForCategoryId(Int(categoryID)!)
        
        var alreadyPurchased = false
        
        if AISettings.sharedInstance.isInAppPurchaseSupported == true {
            if let productID = localCategoryDict?[Constants.kProductIdentifier] as? String {
                let defaults = NSUserDefaults.standardUserDefaults()
                //ProductID = "" -> Free (set alreadyPurchased to true)
                if productID.isEmpty {
                    alreadyPurchased = true
                } else {
                    if defaults.valueForKey(productID) as? Bool == true {
                        alreadyPurchased = true
                    } else {
                        let alert = UIAlertController(title: "Oops", message: "This match contains premium questions. To accept this match you need to buy \(localCategoryDict![Constants.kquizCategoryName]!)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                }
            } else {
                alreadyPurchased = true
            }
        } else {
            alreadyPurchased = true
        }
        
        if alreadyPurchased == false {
        }
        
        if quizDict["category"] == nil || quizDict["Questions"] == nil {
            error = true
        }
        
        if error {
            let alert = UIAlertController(title: "Oops", message: "There is error with this match. Plase try other game", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let currentCategoryDict = quizDict["category"]!.dictionaryObject {
            AIQuizDataManager.sharedInstance.currentCategoryDict = currentCategoryDict
            let quizID = currentCategoryDict[Constants.kquizCategoryId]?.integerValue
            
            let categoryName = currentCategoryDict[Constants.kquizCategoryName] as! String
            
            let categoryTimeRequired = currentCategoryDict[Constants.kTimerRequired] as! Bool
            
            let categoryNumberOfShuffledQuestions = currentCategoryDict[Constants.kCategoryQuestionLimit]?.integerValue
            
            AIQuizDataManager.sharedInstance.currentQuizCategory = (categoryName, quizID!, categoryNumberOfShuffledQuestions! , categoryTimeRequired)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameVC = storyboard.instantiateViewControllerWithIdentifier(StoryboardID.GameViewController) as! GameViewController
            self.presentViewController(gameVC, animated: true, completion: nil)
        }
        
    }
    func matchStarted() {
        ColorLog.cyan(__FUNCTION__)
    }
    func matchEnded() {
        ColorLog.cyan(__FUNCTION__)
    }
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: String) {
        ColorLog.cyan(__FUNCTION__)
    }
    
    func sendNotice(notice: String, forMatch: GKTurnBasedMatch) {
        print("Notice \(notice)")
    }
    
    /*
    - (void)showChallengeBannerForMatch:(GKTurnBasedMatch *)match
    {
    AppDelegate* appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUInteger currentIndex = [match.participants
    indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [match.participants objectAtIndex:
    ((currentIndex + 1) % [match.participants count ])];
    
    self._gcBannerMessageLabel.text = [NSString stringWithFormat:@"New challenge from \"%@\"",nextParticipant.player.alias];
    [appdelegate.window addSubview:self._gcTopBannerView];
    CGRect rect = self._gcTopBannerView.frame;
    rect.origin.y = -self._gcTopBannerView.frame.size.height;
    self._gcTopBannerView.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
    CGRect rect = self._gcTopBannerView.frame;
    rect.origin.y = 0;
    self._gcTopBannerView.frame = rect;
    } completion:^(BOOL finished) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    CGRect rect = self._gcTopBannerView.frame;
    rect.origin.y = -self._gcTopBannerView.frame.size.height;
    self._gcTopBannerView.frame = rect;
    }];
    }
    */
    
    //Notification Recieved
    func productsLoaded(notification: NSNotification) {
        print("******************* NOTIFICATION RECEIVED *************")
        print(__FUNCTION__)
        appDelegate.hideActivityIndicator()
        self.performSegueWithIdentifier(SegueID.MainToInAppVCSegue, sender: self)
    }
    
    
}



















