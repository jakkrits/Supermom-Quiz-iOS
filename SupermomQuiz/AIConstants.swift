//
//  AIConstants.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/18/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

//Constants

typealias Achievements = [[String: AnyObject]]
typealias Achievement = [String: AnyObject]
typealias CategoryDict = [String: AnyObject]
typealias CategoryArray = [[String: AnyObject]]
typealias ProductIdentifiers = Set<String>

struct StoryboardID {
    static let MainViewController       = "MainVCStoryboardID"
    static let SettingsViewController   = "SettingsVCStoryboardID"
    static let GameViewController       = "GameViewControllerStoryboardID"
    static let ChooseQuizTableVC        = "ChooseQuizStoryboardID"
}

struct SegueID {
    static let MainVCToSettingsSegue    = "MainVCToSettingsPopOverSegue"
    static let MainVCToChooseQuizSegue  = "MainVCToChooseQuizSegue" 
    static let MainVCToAboutSeque       = "MainVCToAboutSeque"
    static let MainToInAppVCSegue       = "MainToInAppVCSegue"
    static let ChooseQuizToGameVCSegue  = "ChooseQuizToGameVCSegue"
    static let ShowFinalScoreVCSegue    = "ShowFinalScoreVCSegue"
    static let ShowImageDetailSegue     = "ShowImageDetailSegue"
    static let ShowMultiPlayerFinalScoreVC = "ShowMultiPlayerFinalScoreVCSegue"
    static let InAppToChooseGameVCSegue       = "InAppToChooseGameVCSegue"
    static let ShowHomePageSegue        = "ShowHomePageSegue"
}

struct Cell {
    static let ChooseQuizCategory       = "ChooseQuizCategoryCell"
    static let FinalScore               = "FinalScoreCell"
    static let PurchaseCell             = "PurchaseCell"
}


struct ThemeColor {
    static let IconColor             = UIColor.whiteColor()
    //static let MainLogoColor       = UIColor(red:0.992, green: 0.353, blue:0.369, alpha:1)
    static let MainLogoColor         = UIColor(red:1, green:0.993, blue:0.954, alpha:1)
    static let SettingsIconColor     = UIColor(red:0.992, green: 0.353, blue:0.369, alpha:1)
    static let NavBarTintColor       = UIColor.whiteColor()
    static let TimerIconGrayColor    = UIColor(red:0.831, green: 0.831, blue:0.831, alpha:1)
    static let TimerProgressColor    = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1)
    static let TimerFinishColor      = UIColor(red:0.843, green: 0, blue:0.0158, alpha:1)
    static let LimeGreen             = UIColor(red:0.49, green:0.95, blue:0.41, alpha:1)
    static let BrightRed             = UIColor(red:1, green:0.18, blue:0.33, alpha:1)
    static let LightViolet           = UIColor(red:0.86, green:0.56, blue:1, alpha:1)
    static let LightBlue             = UIColor(red:0, green:0.55, blue:1, alpha:1)
    static let FacebookBlue          = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1)
    static let TwitterBlue           = UIColor(red:0.251, green: 0.6, blue:1, alpha:1)
    static let GameCenterPurple      = UIColor(red:0.745, green: 0, blue:1, alpha:1)
    static let GameCenterBlue        = UIColor(red:0.102, green: 0.698, blue:0.961, alpha:1)
    static let GameCenterPink        = UIColor(red:0.988, green: 0.145, blue:0.686, alpha:1)
    static let GameCenterGreen       = UIColor(red:0.467, green: 0.867, blue:0.224, alpha:1)
    static let HeaderText            = UIColor(rgba: "#F5FFFC")
    static let DescriptionText       = UIColor(rgba: "#DAFFF7")
    static let TimerIcon             = UIColor(rgba: "#91FF97")
}

struct Constants {
    //Chartboost appID
    static let kChartboostAppID = "555f27c4c909a635d2c017e7"
    static let kChartboostAppSignature = "2ae2ae797ef3c766183e5834482bb99353396339"
    
    //RevMob appID
    static let kRevmobAppID = "555e9e108902ed66617da514"
        
    //PARSE Key & ID
    static let kParseAppID  = "i5dpig2s8gIO0wo3uwWwM8oNcaVH4HXh5WXprkXO"
    static let kParseClientKey = "ZCnh4sYl2ijSrxIqGRQWTBCiqfb7b37FWrkZ3Zoo"
    
    //Constants - Category
    static let kHighScore = "highScore"
    static let kScore = "score"
    static let kCurrentQuestionNumber = "currentQuestionNumber"
    static let kquizCategoryDescription = "category_description"
    static let kquizCategoryImagePath = "category_image_path"
    static let kProductIdentifier = "productIdentifier"
    static let kTimerRequired = "timer_required"
    static let kLeaderboardID = "leaderboard_id"
    static let kquizCategoryId = "category_id"
    static let kquizCategoryName = "category_name"
    
    //Constants - Question
    static let kquizQuestion = "question"
    static let kquizOptions = "options"
    static let kquizAnswer = "Answer"
    static let kquizPoints = "points"
    static let kquizNegativePoints = "negative_points"
    static let kquizQuestionDutation = "duration_in_seconds"
    static let kquizQuestionPictureOrVideoName = "picture_or_video_name"
    static let kquizQuestionType = "question_type"
    static let kquizQuestionVideoName = "video_name"
    static let kCategoryQuestionLimit = "category_questions_max_limit"
    static let kCorrectAnsExplanation = "correct_ans_explanation"
    static let kWrongAnsExplanation = "wrong_ans_explanation"
    
    static let kappVersion = "appVersion"
    static let ktotalCategoryCount = "total_categories_count"
}

struct Settings {
    //MARK: - Feature related Keys
    static let FeaturesSettings = "Features Settings"
    static let EnableAdsSupport = "Enable Ads Support"
    static let RemoveAdsProductIdentifier = "Remove Ads Product Identifier"
    static let EnableGameCenter = "Enable Game Center"
    static let EnableInAppPurchase = "Enable In App Purchase"
    static let DataInputFormat = "Data Input Format"
    static let EnableShuffleQuestions = "Enable Shuffle Questions"
    static let EnableShuffleAnswers = "Enable Shuffle Answers"
    static let HighlighCorrectAnswerIfansweredWrong  = "Highlight Correct Answer If answered Wrong"
    static let EnableTimerBasedScore = "Enable Timer Based Score"
    static let EnableParentalGate = "Enable Parental Gate"
    static let ApplicationiTunesLink = "Application iTunes Link"
    static let FullPointsBeforeSeconds = "Full Points Before Seconds"
    static let EnableMultiplayerSupport = "Enable Multiplayer Support"
    static let TotalWinsLeaderboardID = "Total Wins Leaderboard ID"
    static let AchievementsForWins = "Achievements For Wins"
    
    //MARK: - Other keys
    static let kSoundsOnOff = "SoundsOnOff"
    static let kAdsTurnedOff = "AdsTurnedOff"
    static let kShowExplanation = "ShowExplanation"
    static let kAchievementID = "Achievement ID"
    static let kWins = "Wins"
}

struct DocumentPath {

    //BUNDLE PATH
    static let kQuizDataFolderPath = NSBundle.mainBundle().pathForResource("Quiz Data", ofType: "")
    static let kPathForJASONQuizFolder = NSBundle.mainBundle().pathForResource("Quiz Data", ofType: "")?.stringByAppendingString("/JSON_Format")
    
    static let kPathForPicturesFolder = NSBundle.mainBundle().pathForResource("Quiz Data", ofType: "")?.stringByAppendingString("/Pictures_Or_Videos")
    static let kQuizCategoriesJSONFilePath = kPathForJASONQuizFolder! + "/Quiz_Categories.json"
    
    //SANDBOX PATH
    static let kDocumentsFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    static let kPathForProductIDsJSON = kDocumentsFolderPath + "/productIDs.json"
    static let kHiScorePlistFilePath = kDocumentsFolderPath + "/Quiz_HighScore.plist"
    static let kPurchasesPlistFilePath = kDocumentsFolderPath + "/purchase.plist"
    
    static let kQuizDataSandboxPath = kDocumentsFolderPath + "/Quiz Data"
    static let kJSONQuizFolderSandboxPath = kQuizDataSandboxPath + "/JSON_Format"
    static let kPicturesFolderSandboxPath = kQuizDataSandboxPath + "/Pictures_Or_Videos/"
    static let kQuizCatJSONSandboxFilePath = kJSONQuizFolderSandboxPath + "/Quiz_Categories.json"

}

enum QuizDataFormatType: Int {
    //JSON = 1, PLIST = 2
    case JSONFormat = 1
    //case PLISTFormat = 2
}

enum QuestionType: Int {
    //Text = 1, Picture = 2, Video = 3, True/False = 4
    case Text = 1, Picture, Video, TrueOrFalse
}

struct Notification {
    //Game Engine
    static let SkipCurrentQuestion = "skipCurrentQuestion"
    static let TimesUp  = "TimesUp"
    
    //AV
    static let AVPlayerItemDidPlayToEndTime = "AVPlayerItemDidPlayToEndTimeNotification"
    
    //Present View Controller
    static let PresentAuthenticationVC = "PresentAuthenticationViewController"
}

//Turnbased - GameCenter
struct TurnBasedConstants {
    static let kMyWins = "MyWins"
    static let kMyWinsPending = "MyWinsPending"
    static let kPreviousLocalPlayerID = "previousLocalPlayerID"
    static let kMatchID = "matchID"
    static let kMatchIDsPlist = DocumentPath.kDocumentsFolderPath + "/matchIDs.plist"
    static let kLoseMatchIDsPlist = DocumentPath.kDocumentsFolderPath + "/loose_matchIDs.plist"
    static let kFailedSubmissionMatchesPlist = DocumentPath.kDocumentsFolderPath + "/failed_submission_matches.plist"
    static
    let kSaveMatchIDsPLISTForContinuation = DocumentPath.kDocumentsFolderPath + "/savedMatchIDsForContinuation.plist"
}

//In-App Purchase
struct IAP {
    static let ProductPurchasedNotification = "ProductPurchasedNotification"
    
    static let ProductsLoadedNotification = "ProductsLoadedNotification"
    
    static let ProductsFailedToLoadNotification = "ProductsFailedToLoadNotification"

}














