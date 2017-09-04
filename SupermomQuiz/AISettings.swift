//
//  AISettings.swift
//  SupermomQuiz
//
//  Created by JakkritS on 10/20/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation

class AISettings {
    
    var isAdSupported: Bool!
    var isGameCenterSupported: Bool!
    var isInAppPurchaseSupported: Bool!
    var isShuffleAnswersEnabled: Bool!
    var isShuffleQuestionsEnabled: Bool!
    var isHighlightCorrectAnswerEnabled: Bool!
    var isTimerbasedScoreEnabled: Bool!
    var isParentalGateEnabled: Bool!
    var removeAdsProductIdentifier: String?
    var dataInputFormat: String!
    var applicationiTunesLink: String!
    var fullPointsBeforeSeconds: UInt!
    var totalWinsLeaderboardID: String!
    var isMultiplayerSupportEnabled: Bool!
    var achievementsForWins: Achievements!
    
    var isSoundsOn = true
    var isAdsTurnedOff = false
    var showExplanation = true
    var isGameScreenVisible = false
    var isMultiplayerGame = true
    
    //Shared Instance
    static let sharedInstance = AISettings()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //DONE
    init() {
        //Setup Dictionary
        print("***INITIALIZING SETTINGS***")
        
        guard let configurationsFilePath = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist") else {
            print("configuration.plist error \(__FUNCTION__)")
            return
        }
        
        guard let configDict = NSDictionary(contentsOfFile: configurationsFilePath) else {
            print("error configDict \(__FUNCTION__)")
            return
        }
        
        let featureDict = configDict.objectForKey(Settings.FeaturesSettings) as! NSDictionary
        
        //MARK: Features settings
        isAdSupported = featureDict.objectForKey(Settings.EnableAdsSupport)!.boolValue
        isGameCenterSupported = featureDict.objectForKey(Settings.EnableGameCenter)!.boolValue
        isInAppPurchaseSupported = featureDict.objectForKey(Settings.EnableInAppPurchase)!.boolValue
        isShuffleAnswersEnabled = featureDict.objectForKey(Settings.EnableShuffleAnswers)!.boolValue
        isShuffleQuestionsEnabled = featureDict.objectForKey(Settings.EnableShuffleQuestions)!.boolValue
        isHighlightCorrectAnswerEnabled = featureDict.objectForKey(Settings.HighlighCorrectAnswerIfansweredWrong)!.boolValue
        isParentalGateEnabled = featureDict.objectForKey(Settings.EnableParentalGate)!.boolValue
        isTimerbasedScoreEnabled = featureDict.objectForKey(Settings.EnableTimerBasedScore)!.boolValue
        removeAdsProductIdentifier = featureDict.objectForKey(Settings.RemoveAdsProductIdentifier) as? String
        dataInputFormat = featureDict.objectForKey(Settings.DataInputFormat) as! String
        applicationiTunesLink = featureDict.objectForKey(Settings.ApplicationiTunesLink) as! String
        fullPointsBeforeSeconds = featureDict.objectForKey(Settings.FullPointsBeforeSeconds) as! UInt
        isMultiplayerSupportEnabled = featureDict.objectForKey(Settings.EnableMultiplayerSupport)!.boolValue
        totalWinsLeaderboardID = featureDict.objectForKey(Settings.TotalWinsLeaderboardID) as! String
        achievementsForWins = featureDict.objectForKey(Settings.AchievementsForWins) as! Achievements
        
        //MARK: Persistence - NSUserDefaults
        if defaults.valueForKey(Settings.kSoundsOnOff) == nil {
            defaults.setBool(true, forKey: Settings.kSoundsOnOff)
        }
        
        if defaults.valueForKey(Settings.kShowExplanation) == nil {
            defaults.setBool(true, forKey: Settings.kShowExplanation)
        }
        
        if defaults.valueForKey(Settings.kAdsTurnedOff) == nil {
            defaults.setBool(false, forKey: Settings.kAdsTurnedOff)
        }
        
        if defaults.valueForKey(Constants.ktotalCategoryCount) == nil {
            defaults.setInteger(0, forKey: Constants.ktotalCategoryCount)
        }
        defaults.synchronize()
    }
    
    func requiredAdDisplay() -> Bool {
        if NSUserDefaults.standardUserDefaults().boolForKey(Settings.kAdsTurnedOff) == false {
            return true
        } else if NSUserDefaults.standardUserDefaults().boolForKey(AISettings.sharedInstance.removeAdsProductIdentifier!) == false {
            return true
        }
        else {
            return false
        }
    }
    
    func setSoundsEnabled(isOn: Bool) {
        defaults.setBool(isOn, forKey: Settings.kSoundsOnOff)
        isSoundsOn = isOn
    }

    func setShowExplanationOption(isOn: Bool) {
        defaults.setBool(isOn, forKey: Settings.kShowExplanation)
        showExplanation = isOn
    }
    
    func validateSettings() {
        if (isAdSupported == true && removeAdsProductIdentifier == nil) {
            isAdSupported = false
            assert(isAdSupported == true, "You have enabled ads by setting value YES to property \"Enable Ads Support\" in \"Configuration.plist->Features Settings\" and not specified product identifier for removing ads through InApp purchase for property \"Remove Ads Product Identifier\". If you are not willing to support ads set NO to property \"Enable Ads Support\" in \"Configuration.plist->Features Settings\". Ads are turned off automatically.")
        }
        
        if isGameCenterSupported == true {
            let allCategories = AIQuizDataManager.sharedInstance.allQuizCategory
            for category in allCategories {
                if let leaderboardID = category[Constants.kLeaderboardID] as? String {
                    assert(!leaderboardID.isEmpty, "You have enabled ads by setting value YES to property \"Enable Game Center\" in \"Configuration.plist->Features Settings\" and not specified \"leaderboardID\" for category \(category[Constants.kquizCategoryName]). If you are not willing to support game center please turn off from the category node from \"Quiz_Categories.plist or json\" file)")
                }
            }
        }
        
        if (applicationiTunesLink.isEmpty) {
            assert(!applicationiTunesLink.isEmpty, "Add iTune's link of this app for property at \"Configuration.plist->Features Settings->ApplicationiTunesLink\". You can find this link iTunes connect once you have created the app. This link will be shared on social n/ws along with score while sharing score.")
        }
        
    }
}
