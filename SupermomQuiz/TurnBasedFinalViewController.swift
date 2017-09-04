//
//  TurnBasedFinalViewController.swift
//  SupermomQuiz
//
//  Created by JakkritS on 11/8/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import GameKit
import Social

class TurnBasedFinalViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var facebookIcon: FacebookLogo!
    @IBOutlet weak var twitterIcon: TwitterLogo!
    @IBOutlet weak var gameCenterIcon: GameCenterIcon!
    @IBOutlet weak var houseIcon: HouseIcon!
    
    @IBOutlet var newGameButton: UIButton!
    @IBOutlet var gameTitle: UILabel!
    
    @IBOutlet var matchStatusLabel: UILabel!
    @IBOutlet var localPlayerImageView: UIImageView!
    @IBOutlet var currentScoreLabel: UILabel!

    @IBOutlet var opponentImageView: UIImageView!
    @IBOutlet var opponentNameLabel: UILabel!
    @IBOutlet var opponentScoreLabel: UILabel!
    
    var match: GKTurnBasedMatch?
    var presentedModally: Bool!
    var currentScore = 0
    var returnedJSON: JSON!
    var thisParticipant = GKTurnBasedParticipant()
    var otherParticipant = GKTurnBasedParticipant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToViews()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        guard let currentMatch = self.match else {
            print("currentMatch error")
            return
        }

        var currentCategoryDict = [String: AnyObject]()

        for participant in currentMatch.participants! {
    
            if let playerID = participant.player?.playerID {
                if playerID == GKLocalPlayer.localPlayer().playerID {
                    thisParticipant = participant
                } else {
                    otherParticipant = participant
                }
            }
        }
     
        if thisParticipant.matchOutcome == GKTurnBasedMatchOutcome.Quit {
            print("You Quit the Match")
        } else if otherParticipant.matchOutcome == GKTurnBasedMatchOutcome.Quit {
            print("Your Opponent Quit the Match")
        } else {
            
            if currentMatch.matchData!.length > 0 {
                if currentMatch.status == GKTurnBasedMatchStatus.Open {
                    let result = JSON(data: currentMatch.matchData!, options: .AllowFragments, error: nil)
                    returnedJSON = result
                    opponentScoreLabel.text = ""
                } else if currentMatch.status == GKTurnBasedMatchStatus.Ended {
                    let result = NSKeyedUnarchiver.unarchiveObjectWithData(currentMatch.matchData!)
                    if let json = result {
                        returnedJSON = JSON(json)
                    }
                } else {
                    opponentScoreLabel.text = ""
                }
   
                currentCategoryDict = AIQuizDataManager.sharedInstance.currentCategoryDict
                
            } else {
                currentCategoryDict = AIQuizDataManager.sharedInstance.currentCategoryDict
                opponentScoreLabel.text = ""
            }
            
            //Updating UI
            gameTitle.text = currentCategoryDict[Constants.kquizCategoryName] as? String
            
            let localScore = currentScore
            
            currentScoreLabel.text = "\(localScore)"
            
            thisParticipant.player?.loadPhotoForSize(GKPhotoSizeNormal, withCompletionHandler: { (image, error) -> Void in
                    self.localPlayerImageView.image = image
                    self.localPlayerImageView.layer.cornerRadius = CGRectGetWidth(self.localPlayerImageView.frame) / 2.0
                    self.localPlayerImageView.layer.masksToBounds = true
                    self.localPlayerImageView.layer.borderWidth = 3
                    self.localPlayerImageView.layer.borderColor = ThemeColor.MainLogoColor.CGColor
                if image == nil {
                    self.localPlayerImageView.image = UIImage(named: "placeholder")
                }
                
            })
            
            otherParticipant.player?.loadPhotoForSize(GKPhotoSizeNormal, withCompletionHandler: { (image, error) -> Void in
                
                self.opponentImageView.image = image
                self.opponentImageView.layer.cornerRadius = CGRectGetWidth(self.localPlayerImageView.frame) / 4.0
                self.opponentImageView.layer.masksToBounds = true
                self.opponentImageView.layer.borderWidth = 1.8
                self.opponentImageView.layer.borderColor = ThemeColor.MainLogoColor.CGColor
                if image == nil {
                    self.opponentImageView.image = UIImage(named: "placeholder")
                }
            })
            
            //CHECK TURN AND CONFIGURE UI
            if currentMatch.status != GKTurnBasedMatchStatus.Ended {
                matchStatusLabel.text = "Your Opponent's Turn"
                
            } else {
                let otherPlayerIDKey = "\(otherParticipant.player!.playerID!)" + "_points"
                let otherScore = returnedJSON[otherPlayerIDKey].int
                if otherScore != nil {
                    opponentScoreLabel.text = "\(otherScore!)"
                } else {
                    opponentScoreLabel.text = ""
                }
                
                currentScoreLabel.text = "\(localScore)"

                if let name = otherParticipant.player?.alias {
                   opponentNameLabel.text = name
                } else {
                    opponentNameLabel.text = ""
                }
                
                if localScore < otherScore {
                    matchStatusLabel.text = "You Lost!"
                    
                } else if localScore > otherScore {
                    matchStatusLabel.text = "You Won!"
                } else if localScore == otherScore {
                    matchStatusLabel.text = "It's a draw!"
                }
            }
            
        }
        
        opponentNameLabel.text = otherParticipant.player?.alias
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        switch sender.view {
        case is FacebookLogo:
            print("Facebook")
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposerVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposerVC.setInitialText("Yo! I AM SUPERMOM! Beat me if you can!")
                self.presentViewController(facebookComposerVC, animated: true, completion: nil)
            } else {
                showAlert(Service.Facebook)
            }
        case is TwitterLogo:
            print("Twitter")
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposeVC.setInitialText("Yo! I AM SUPERMOM! Beat me if you can!")
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            } else {
                showAlert(Service.Twitter)
            }
        case is GameCenterIcon:
            print("GameCenter")
            let gameViewController = GKGameCenterViewController()
            gameViewController.gameCenterDelegate = self
            gameViewController.viewState = GKGameCenterViewControllerState.Leaderboards
            presentViewController(gameViewController, animated: true, completion: nil)
        case is HouseIcon:
            print("Home")
            let presentingVC = self.presentingViewController!
            if presentingVC is UINavigationController {
                self.dismissViewControllerAnimated(true, completion: nil)
                (presentingVC as! UINavigationController).popToRootViewControllerAnimated(true)
            } else {
                self.dismissViewControllerAnimated(true) { () -> Void in
                    presentingVC.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    func addTapGestureToViews() {
        let views = [facebookIcon, twitterIcon, gameCenterIcon, houseIcon]
        for icon in views {
            
            let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
            tap.numberOfTapsRequired = 1
            icon.addGestureRecognizer(tap)
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
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if service == Service.Facebook {
            let alertVC = UIAlertController(title: "Facebook Error", message: "Please log on to your Facebook account", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.takeAnotherChallenge = true
        if presentedModally == true {
            let presentingVC = self.presentingViewController!
            if presentingVC is UINavigationController {
                self.dismissViewControllerAnimated(true, completion: nil)
                (presentingVC as! UINavigationController).popToRootViewControllerAnimated(true)
            } else {
                self.dismissViewControllerAnimated(true) { () -> Void in
                    presentingVC.dismissViewControllerAnimated(false, completion: nil)
                }
            }
            
        } else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    
    
    
    //MARK: - GameCenterDelegate
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
