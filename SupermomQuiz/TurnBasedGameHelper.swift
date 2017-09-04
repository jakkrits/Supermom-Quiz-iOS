//
//  TurnBasedGameHelper.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 9/4/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//


import GameKit
import UIKit

protocol TurnBasedGameHelperDelegate {
    func enterNewGame(match: GKTurnBasedMatch)
    func layoutMatch(match: GKTurnBasedMatch)
    func takeTurn(match: GKTurnBasedMatch)
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: String)
}

class TurnBasedGameHelper: NSObject, GKTurnBasedMatchmakerViewControllerDelegate, GKMatchmakerViewControllerDelegate , GKChallengeListener, GKLocalPlayerListener, GKInviteEventListener, GKTurnBasedEventListener, UINavigationControllerDelegate {
    
    static let sharedInstance = TurnBasedGameHelper()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var delegate: TurnBasedGameHelperDelegate?
    
    var presentingViewController: UIViewController?
    var authenticationViewController: UIViewController?
    
    var saveToLoseList = false
    var gameCenterEnabled = false
    var userAuthenticated = false
    var currentMatch: GKTurnBasedMatch?
    var multiPlayerMatch: GKMatch?
    var lastError: NSError?
    var multiPlayerMatchStarted: Bool
    var pendingWins: Int64 = 0
    var myWins: Int64 = 0
    var currentMatchScore: Int64 = 0
    
    override init() {
        if NSUserDefaults.standardUserDefaults().objectForKey(TurnBasedConstants.kMyWinsPending) == nil {
            NSUserDefaults.standardUserDefaults().setObject(0, forKey: TurnBasedConstants.kMyWinsPending)
        } else {
            pendingWins = NSUserDefaults.standardUserDefaults().objectForKey(TurnBasedConstants.kMyWinsPending)!.longLongValue!
        }
        
        multiPlayerMatchStarted = false
        
        super.init()
        gameCenterEnabled = AISettings.sharedInstance.isGameCenterSupported
        
        //GAMECENTER AVAILABLE!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authenticationChanged", name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
        
    }
    
    func authenticateLocalPlayer() {
        print(__FUNCTION__)
        let localPlayer = GKLocalPlayer.localPlayer()
        if localPlayer.authenticated == false {
            localPlayer.authenticateHandler = { (viewController, error) in
                self.lastError = error
                if  viewController != nil {
                    self.authenticationViewController = viewController
                    NSNotificationCenter.defaultCenter().postNotificationName(Notification.PresentAuthenticationVC, object: self)
                } else if localPlayer.authenticated {
                    print("Local Player Authenticated & Game Center is ENABLED")
                    self.gameCenterEnabled = true
                    localPlayer.registerListener(self)
                    GKMatchmaker.sharedMatchmaker().startBrowsingForNearbyPlayersWithHandler({ (player, reachable) -> Void in
                        if reachable {
                            print("player \(player) is available to play")
                        }
                    })
                } else {
                    print("game center is DISABLED")
                    self.gameCenterEnabled = false
                }
            }
            
            /*
            //Remove all matches
            GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches, error) -> Void in
            for match in matches! {
            match.removeWithCompletionHandler({ (error) -> Void in
            if error != nil {
            print(error!.description)
            }
            })
            }
            }
            resetAchievements()
            */
            
        } else {
            print("Local player already authenticated")
            localPlayer.unregisterListener(self)
            localPlayer.registerListener(self)
            performUpdates()
        }
    }
    
    func checkForPendingMatchesForWins() {
        if let matchIDs = NSArray(contentsOfFile: TurnBasedConstants.kMatchIDsPlist){
            for matchID in matchIDs {
                GKTurnBasedMatch.loadMatchWithID(matchID as! String, withCompletionHandler: { (match, error) -> Void in
                    if error != nil {
                        print("Unable to fetch matchID: \(matchID)")
                    } else if match == nil {
                        self.removeMatchID(matchID as! String)
                    } else {
                        let participants = match!.participants
                        var localPlayer: GKTurnBasedParticipant? = nil
                        for participant in participants! {
                            if participant.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                                localPlayer = participant
                                break
                            }
                        }
                        
                        if localPlayer?.matchOutcome == GKTurnBasedMatchOutcome.Won {
                            self.pendingWins++
                            NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.pendingWins), forKey: TurnBasedConstants.kMyWinsPending)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.removeMatchID(match!.matchID!)
                            self.reportPendingWins()
                            print("=== won === matchID removed: \(match!.matchID)")
                        } else if localPlayer?.matchOutcome == GKTurnBasedMatchOutcome.Lost || localPlayer?.matchOutcome == GKTurnBasedMatchOutcome.Tied || localPlayer?.matchOutcome == GKTurnBasedMatchOutcome.Quit || localPlayer?.matchOutcome == GKTurnBasedMatchOutcome.TimeExpired {
                            self.removeMatchID(match!.matchID!)
                            print("=== tied === matchID removed: \(match!.matchID)")
                        }
                    }
                })
            }
        }
    }
    
    func removeMatchID(matchID: String) {
        var matchIDs = NSArray(contentsOfFile: TurnBasedConstants.kMatchIDsPlist) as? [String]
        if let matches = matchIDs {
            matchIDs = matches.filter(){ $0 != matchID }
            (matchIDs! as NSArray).writeToFile(TurnBasedConstants.kMatchIDsPlist, atomically: true)
        }
    }
    
    
    func reportPendingWins() {
        if self.pendingWins > 0 {
            let score = GKScore(leaderboardIdentifier: AISettings.sharedInstance.totalWinsLeaderboardID)
            score.value = self.myWins + self.pendingWins
            GKScore.reportScores([score], withCompletionHandler: { (error) -> Void in
                if error != nil {
                    print("Error posting scores")
                    self.pendingWins += 1
                } else {
                    self.pendingWins = 0
                    self.myWins += 1
                    NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.myWins), forKey: TurnBasedConstants.kMyWins)
                    NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.pendingWins), forKey: TurnBasedConstants.kMyWinsPending)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.updateAchievements()
                }
            })
        }
    }
    
    
    func updateAchievements() {
        let achievements = AISettings.sharedInstance.achievementsForWins
        var firstAchievementDict = [String: AnyObject]()
        var postAchievements = [GKAchievement]()
        
        if !achievements.isEmpty {
            firstAchievementDict = achievements.first!
            var firstAchievementPoints = 0
            if let firstAchPoints = firstAchievementDict[Settings.kWins]?.integerValue {
                firstAchievementPoints = firstAchPoints
            }
            
            for achievement in achievements {
                if let requiredPoints = achievement[Settings.kWins]?.integerValue {
                    if (myWins >= Int64(requiredPoints)) && (myWins >= Int64(firstAchievementPoints)) {
                        let achievementID = achievement[Settings.kAchievementID]?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        let myAchievement = GKAchievement(identifier: achievementID!, player: GKLocalPlayer.localPlayer())
                        myAchievement.percentComplete = 100.0
                        postAchievements.append(myAchievement)
                    }
                }
            }
            
            if postAchievements.count > 0 {
                print(postAchievements.description)
                GKAchievement.reportAchievements(postAchievements, withCompletionHandler: { (error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        print("achievement posted")
                    }
                })
            }
        }
    }
    
    //@PUBLIC
    func authenticationChanged() {
        if GKLocalPlayer.localPlayer().authenticated && !userAuthenticated {
            print("TURNBASED PLAYER AUTHENTICATED")
            userAuthenticated = true
            gameCenterEnabled = true
            performUpdates()
        } else if (!GKLocalPlayer.localPlayer().authenticated && userAuthenticated) {
            print("TURNBASED PLAYER NOT AUTHENTICATED")
            userAuthenticated = false
        }
    }
    
    func performUpdates() {
        print(__FUNCTION__)
        let reset = resetLocalPlayerData()
        if reset == false {
            checkForFraudMatchesAndSubmitAsLost()
            checkForResubmissionOfMatches()
            checkForPendingMatchesForWins()
            TurnBasedGameHelper.sharedInstance.updateMyWinsCountFromLeader()
        }
    }
    
    func resetAchievements() {
        GKAchievement.resetAchievementsWithCompletionHandler { (error) -> Void in
            if error != nil {
                print(error!.debugDescription)
            } else {
                print("achievement reset")
            }
        }
    }
    
    func resetLocalPlayerData() -> Bool {
        
        if NSUserDefaults.standardUserDefaults().objectForKey(TurnBasedConstants.kPreviousLocalPlayerID) == nil {
            NSUserDefaults.standardUserDefaults().setObject(GKLocalPlayer.localPlayer().playerID, forKey: TurnBasedConstants.kPreviousLocalPlayerID)
        }
        
        //Handle New Logged-In User
        if let localPlayerID = GKLocalPlayer.localPlayer().playerID {
            if (localPlayerID == NSUserDefaults.standardUserDefaults().objectForKey(TurnBasedConstants.kPreviousLocalPlayerID) as! String) && AISettings.sharedInstance.isMultiplayerSupportEnabled == true {
                NSUserDefaults.standardUserDefaults().setObject(GKLocalPlayer.localPlayer().playerID, forKey: TurnBasedConstants.kPreviousLocalPlayerID)
                
                pendingWins = 0
                myWins = 0
                
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: myWins), forKey: TurnBasedConstants.kMyWins)
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: pendingWins), forKey: TurnBasedConstants.kMyWinsPending)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                if NSFileManager.defaultManager().fileExistsAtPath(TurnBasedConstants.kMatchIDsPlist) {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(TurnBasedConstants.kMatchIDsPlist)
                    } catch {
                        print("Can't remove file")
                    }
                }
                if NSFileManager.defaultManager().fileExistsAtPath(TurnBasedConstants.kFailedSubmissionMatchesPlist) {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(TurnBasedConstants.kFailedSubmissionMatchesPlist)
                    } catch {
                        print("Can't remove file")
                    }
                }
                
                if NSFileManager.defaultManager().fileExistsAtPath(TurnBasedConstants.kLoseMatchIDsPlist) {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(TurnBasedConstants.kLoseMatchIDsPlist)
                    } catch {
                        print("Can't remove file")
                    }
                }
                return true
            }
        }
        return false
    }
    
    //MARK: Cheat Handling Methods
    func checkForFraudMatchesAndSubmitAsLost() {
        print(__FUNCTION__)
        if NSFileManager.defaultManager().fileExistsAtPath(TurnBasedConstants.kLoseMatchIDsPlist) {
            if let matchIDs = NSArray(contentsOfFile: TurnBasedConstants.kLoseMatchIDsPlist) {
                for matchID in matchIDs {
                    GKTurnBasedMatch.loadMatchWithID((matchID as! String), withCompletionHandler: { (match, error) -> Void in
                        if error != nil {
                            print(error)
                        } else if match == nil {
                            self.removeMatchIDMarkedAsLost(match!.matchID!)
                        } else {
                            var localPlayer: GKTurnBasedParticipant!
                            var otherPlayer: GKTurnBasedParticipant!
                            for participant in match!.participants! {
                                
                                if participant.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                                    localPlayer = participant
                                } else {
                                    otherPlayer = participant
                                }
                            }
                            
                            localPlayer.matchOutcome = GKTurnBasedMatchOutcome.Lost
                            otherPlayer.matchOutcome = GKTurnBasedMatchOutcome.Won
                            
                            match!.endMatchInTurnWithMatchData(match!.matchData!, completionHandler: { (error) -> Void in
                                if error != nil {
                                    //Invalid Match State
                                    if error!.code == 24 {
                                        self.removeMatchIDMarkedAsLost(match!.matchID!)
                                    }
                                } else {
                                    self.removeMatchIDMarkedAsLost(match!.matchID!)
                                }
                                print("match lost \(__FUNCTION__)")
                            })
                        }
                    })
                }
            }
        }
    }
    
    func removeMatchIDMarkedAsLost(currentMatchID: String) {
        if let matchIDs = NSArray(contentsOfFile: TurnBasedConstants.kLoseMatchIDsPlist) {
            if matchIDs.containsObject(currentMatchID) {
                let filteredArray = (matchIDs as! [String]).filter(){ $0 != currentMatchID }
                (filteredArray as NSArray).writeToFile(TurnBasedConstants.kLoseMatchIDsPlist, atomically: true)
            }
        }
    }
    
    func saveCurrentMatchInLoseList() {
        var matchIDs = NSArray(contentsOfFile: TurnBasedConstants.kLoseMatchIDsPlist) as? [String]
        if matchIDs == nil || matchIDs?.count == 0 {
            matchIDs?.append(self.currentMatch!.matchID!)
        }
        
        if let matchIDArray = matchIDs {
            
            (matchIDArray as NSArray).writeToFile(TurnBasedConstants.kLoseMatchIDsPlist, atomically: true)
        }
    }
    
    func updateMyWinsCountFromLeader() {
        let leaderboardRequest = GKLeaderboard(players: [GKLocalPlayer.localPlayer()])
        leaderboardRequest.timeScope = GKLeaderboardTimeScope.AllTime
        leaderboardRequest.playerScope = GKLeaderboardPlayerScope.Global
        leaderboardRequest.identifier = AISettings.sharedInstance.totalWinsLeaderboardID
        print(leaderboardRequest.identifier)
        leaderboardRequest.loadScoresWithCompletionHandler { (scores, error) -> Void in
            if scores != nil {
                if scores!.count == 0 || error != nil {
                    print("no score or error = \(error)")
                } else {
                    let score = scores!.first
                    if score!.value > self.myWins {
                        self.myWins = score!.value
                        //Update Wins
                        NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.myWins), forKey: TurnBasedConstants.kMyWins)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        print("updated wins: \(self.myWins)")
                    }
                }
            }
        }
    }
    
    func checkForResubmissionOfMatches() {
        let matches = NSArray(contentsOfFile: TurnBasedConstants.kFailedSubmissionMatchesPlist) as? [[String: String]]
        var myMatchScore: Int64 = 0
        if let currentMatches = matches {
            for dict in currentMatches {
                if let matchID = dict[TurnBasedConstants.kMatchID] {
                    GKTurnBasedMatch.loadMatchWithID(matchID, withCompletionHandler: { (match, error) -> Void in
                        if error!.code == 24 {
                            print("Invalid match state \(matchID)")
                            self.removeFromResubmittedList(matchID)
                        } else if match == nil {
                            print("match does not exist")
                        } else {
                            if let matchScore = Int(dict[Constants.kScore]!) {
                                print("failed submission score = \(matchScore)")
                                myMatchScore = Int64(matchScore)
                            }
                            var player1 = GKTurnBasedParticipant()
                            var player2 = GKTurnBasedParticipant()
                            for participant in match!.participants! {
                                if participant.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                                    player1 = participant
                                } else {
                                    player2 = participant
                                }
                            }
                            
                            let data = (AIQuizDataManager.sharedInstance).newDataForMatchData(match!.matchData!, withPoint: myMatchScore, forPlayerID: match!.currentParticipant!.player!.playerID!)
                            let quizDict = AIQuizDataManager.sharedInstance.dataDictionaryFromPreviousParticipantMatchData(match!.matchData!)
                            let key = player2.player!.playerID! + "_points"
                            if let othersScore = quizDict[key]?.int64Value {
                                if myMatchScore < othersScore {
                                    player1.matchOutcome = GKTurnBasedMatchOutcome.Lost
                                    player2.matchOutcome = GKTurnBasedMatchOutcome.Won
                                } else if myMatchScore == othersScore {
                                    player1.matchOutcome = GKTurnBasedMatchOutcome.Tied
                                    player2.matchOutcome = GKTurnBasedMatchOutcome.Tied
                                } else {
                                    self.iWon()
                                    player1.matchOutcome = GKTurnBasedMatchOutcome.Won
                                    player2.matchOutcome = GKTurnBasedMatchOutcome.Lost
                                }
                                
                                match!.endMatchInTurnWithMatchData(data, scores: [], achievements: [], completionHandler: { (error) -> Void in
                                    if error != nil {
                                        if error!.code == 24 {
                                            print("checking for resubmission of matches \(match!.matchID)")
                                            self.removeFromResubmittedList(match!.matchID!)
                                        }
                                    } else {
                                        self.removeFromResubmittedList(match!.matchID!)
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    func removeFromResubmittedList(currentMatchID: String) {
        let matches = NSArray(contentsOfFile: TurnBasedConstants.kFailedSubmissionMatchesPlist) as? [[String: String]]
        if let currentMatches = matches {
            for dict in currentMatches {
                let myMatch = currentMatches.filter() { $0 != dict }
                (myMatch as NSArray).writeToFile(TurnBasedConstants.kFailedSubmissionMatchesPlist, atomically: true)
            }
        }
    }
    
    func findMatch(minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController, showExistingMatches show: Bool) {
        if !gameCenterEnabled {
            return
        }
        
        self.presentingViewController = viewController
        
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        
        let turnBasedVC = GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
        turnBasedVC.turnBasedMatchmakerDelegate = self
        turnBasedVC.showExistingMatches = show
        
        self.presentingViewController?.presentViewController(turnBasedVC, animated: true, completion: nil)
        
    }
    
    
    func iWon() {
        if GKLocalPlayer.localPlayer().authenticated == false {
            pendingWins++
            NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.pendingWins), forKey: TurnBasedConstants.kMyWinsPending)
            NSUserDefaults.standardUserDefaults().synchronize()
            return
        }
        
        let score = GKScore(leaderboardIdentifier: AISettings.sharedInstance.totalWinsLeaderboardID)
        if pendingWins > 0 {
            score.value = myWins + 1 + pendingWins
        } else {
            score.value = myWins + 1
        }
        
        GKScore.reportScores([score], withCompletionHandler: { (error) -> Void in
            if error != nil {
                print("Error reporting scores to GameCenter")
                self.pendingWins += 1
            } else {
                self.pendingWins = 0
                self.myWins += 1
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.myWins), forKey: TurnBasedConstants.kMyWins)
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: self.pendingWins), forKey: TurnBasedConstants.kMyWinsPending)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.updateAchievements()
            }
        })
    }
    
    //MARK: - Failed Submission Handling Methods
    func saveCurrentMatchInResubmissionList() {
        var matches = NSArray()
        
        if let failedMatches = NSArray(contentsOfFile: TurnBasedConstants.kFailedSubmissionMatchesPlist) {
            matches = failedMatches
        }
        
        var savedMatchDict = [String: AnyObject]()
        savedMatchDict[TurnBasedConstants.kMatchID] = self.currentMatch!.matchID
        savedMatchDict[Constants.kScore] = NSNumber(longLong: self.currentMatchScore)
        matches.arrayByAddingObject(savedMatchDict)
        matches.writeToFile(TurnBasedConstants.kFailedSubmissionMatchesPlist, atomically: true)
    }
    
    //MARK: Misc
    func addMatchID(matchID: String) {
        var matchIDs = [String]()
        
        if let ids = NSArray(contentsOfFile: TurnBasedConstants.kMatchIDsPlist) as? [String] {
            matchIDs = ids
        }
        
        matchIDs.append(matchID)
        
        (matchIDs as NSArray).writeToFile(TurnBasedConstants.kMatchIDsPlist, atomically: true)
    }
    
    
    
    //MARK: Achievements
    func achievementForWins(wins: Int64, forPlayer player: GKPlayer) -> GKAchievement {
        var achievementID = ""
        let achievementIDs = AISettings.sharedInstance.achievementsForWins
        for achievement in achievementIDs {
            if let currentWinInDict = achievement["Wins"]?.unsignedLongLongValue {
                if wins > Int64(currentWinInDict) {
                    if let achID = achievement["AchievementID"] as? String {
                        achievementID = achID
                    }
                }
            }
        }
        let achievement = GKAchievement(identifier: achievementID, player: player)
        achievement.percentComplete = 100.0
        return achievement
    }
    
    //**************************************************************//
    //MARK: - TurnbBased MatchMaker Delegates
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController) {

        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.presentingViewController?.navigationController?.popViewControllerAnimated(true)
        })
        print("User cancelled match")
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: NSError) {
        print("Match failed: \(error.localizedDescription)")
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, playerQuitForMatch match: GKTurnBasedMatch) {
        ColorLog.blue(__FUNCTION__)
    }
    
    
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch) {

        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { ColorLog.blue("***** GameKitVC Dismissed *****")
            self.currentMatch = match
            
            if match.participants == nil {
                return
            } else {
                
                let firstParticipant = match.participants![0]
                
                if (firstParticipant.lastTurnDate == nil) {
                    print("Existing Match")
                    self.delegate?.enterNewGame(match)
                } else {
                    
                    var statusString: String?
                    var thisParticipant: GKTurnBasedParticipant? = nil
                    var otherParticipant: GKTurnBasedParticipant? = nil
                    
                    let otherPlayer = match.participants!.filter(){ ($0 ) != thisParticipant }
                    otherParticipant = otherPlayer.first
                    
                    for participant in match.participants! {
                        if participant.player != nil {
                            if participant.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                                thisParticipant = participant
                            }
                        } else {
                            otherParticipant = participant
                        }
                    }
                    
                    if thisParticipant?.matchOutcome == GKTurnBasedMatchOutcome.Quit {
                        statusString = "You Quit the Match"
                    } else if otherParticipant?.matchOutcome == GKTurnBasedMatchOutcome.Quit {
                        statusString = "Your Opponent Quit the Match"
                    } else if otherParticipant?.status == GKTurnBasedParticipantStatus.Declined {
                        statusString = "Your Opponent Declined Your Challenge"
                    }
                    
                    if statusString == nil && match.currentParticipant!.player != nil {
                        if match.currentParticipant!.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                            self.delegate?.takeTurn(match)
                        } else {
                            self.delegate?.layoutMatch(match)
                        }
                    } else {
                        if statusString == nil {
                            statusString = "Wait for other player to play"
                        }
                        let alertController = UIAlertController(title: "Match Status", message: statusString, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentingViewController?.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            
            
        })
    }
    
    //**************************************************************//
    //MARK: GKMatchmakerViewControllerDelegate
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        
        print(__FUNCTION__)
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        
        print(__FUNCTION__)
    }
    
    //MARK: GKEventListener
    func player(player: GKPlayer, didAcceptInvite invite: GKInvite) {
        
        print("Invitation Accepted")
    }
    
    func player(player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("Dismissing Presenting ViewController")
        })
        let matchRequest = GKMatchRequest()
        matchRequest.recipients = playersToInvite
        matchRequest.maxPlayers = 2
        matchRequest.minPlayers = 2
        let matchMakerVC = GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
        matchMakerVC.showExistingMatches = false
        matchMakerVC.turnBasedMatchmakerDelegate = self
        self.presentingViewController?.presentViewController(matchMakerVC, animated: true, completion: nil)
    }
    
    func player(player: GKPlayer, didRequestMatchWithPlayers playerIDsToInvite: [String]) {
        
        //insert cleanup code for managing view controllers
        print(playerIDsToInvite)
    }
    
    func player(player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
        
        //insert cleanup code for managing view controllers
        let matchRequest = GKMatchRequest()
        matchRequest.recipients = recipientPlayers
        guard let matchMakerVC = GKMatchmakerViewController(matchRequest: matchRequest) else {
            print("No MatchRequest for MatchMakerVC")
            return
        }
        matchMakerVC.delegate = self
        appDelegate.window?.rootViewController?.presentViewController(matchMakerVC, animated: true, completion: nil)
    }
    
    func player(player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        print("Match Ended \(__FUNCTION__)")
        
        checkForPendingMatchesForWins()
    }
    
    func player(player: GKPlayer, receivedTurnEventForMatch match: GKTurnBasedMatch, didBecomeActive: Bool) {
        if match.currentParticipant == nil || match.participants == nil {
            match.removeWithCompletionHandler({ (error) -> Void in
                let alertController = UIAlertController(title: "Match Error", message: "This match is invalid, Press OK to delete match.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentingViewController?.presentViewController(alertController, animated: true, completion: { () -> Void in
                    return
                })
            })
        } else {
            self.currentMatch = match
            
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: { ColorLog.blue("***** GameKitVC Dismissed *****")
                
                let firstParticipant = match.currentParticipant!
                
                //  let firstParticipant = match.participants![0]
                
                if (firstParticipant.lastTurnDate == nil) {
                    print("receivedTurnEventForMatch ----- Existing Match")
                    self.delegate?.enterNewGame(match)
                } else {

                    var statusString: String?
                    var thisParticipant: GKTurnBasedParticipant? = nil
                    var otherParticipant: GKTurnBasedParticipant? = nil
                    
                    let otherPlayer = match.participants!.filter(){ ($0 ) != thisParticipant }
                    otherParticipant = otherPlayer.first
                    
                    for participant in match.participants! {
                        if participant.player != nil {
                            if participant.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                                thisParticipant = participant
                            }
                        } else {
                            otherParticipant = participant
                        }
                    }
                    
                    if thisParticipant?.matchOutcome == GKTurnBasedMatchOutcome.Quit {
                        statusString = "You Quit the Match"
                    } else if otherParticipant?.matchOutcome == GKTurnBasedMatchOutcome.Quit {
                        statusString = "Your Opponent Quit the Match"
                    } else if otherParticipant?.status == GKTurnBasedParticipantStatus.Declined {
                        statusString = "Your Opponent Declined Your Challenge"
                    }
                    
                    if statusString == nil && match.currentParticipant?.player != nil {
                        if match.currentParticipant!.player!.playerID == GKLocalPlayer.localPlayer().playerID {
                            self.delegate?.takeTurn(match)
                        } else {
                            self.delegate?.layoutMatch(match)
                        }
                    } else {
                        if statusString == nil {
                            statusString = "Wait for other player to play"
                        }
                        let alertController = UIAlertController(title: "Match Status", message: statusString, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentingViewController?.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
            
        }
        
    }
    
    
    func handleTurnEventForMatch(match: GKTurnBasedMatch, didBecomeActive becomeActive: Bool) {
        
        print("Match Recieved")
    }
    
    func player(player: GKPlayer, wantToQuitMatch match: GKTurnBasedMatch) {
        
        var currentIndex = 0
        let index = 0
        for particip in match.participants! {
            if particip == match.currentParticipant {
                currentIndex = index
                if particip.matchOutcome != GKTurnBasedMatchOutcome.Quit {
                    break
                }
            }
        }
        print("Player quit match \(match) : \(match.currentParticipant)")
        
        let nextIndex = (currentIndex + 1) % match.participants!.count
        let nextParticipant = match.participants![nextIndex]
        match.participantQuitInTurnWithOutcome(.Quit, nextParticipants: [nextParticipant], turnTimeout: GKTurnTimeoutNone, matchData: match.matchData!, completionHandler: { (error) -> Void in
            if error != nil {
                print(error)
            }
        })
    }
}
