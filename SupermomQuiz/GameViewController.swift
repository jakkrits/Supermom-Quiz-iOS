//
//  GameViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/18/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CryptoSwift
import GameKit

class GameViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var timerView: KDCircularProgress!
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var pictureForQuestionImageView: UIImageView!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    private var questionIndex = 0
    private var playingQuestion = CategoryDict()
    private var playingQuestions = CategoryArray()
    
    let audioPlayer = SoundManager()
    
    var isTimerRequired: Bool {
        return AIQuizDataManager.sharedInstance.currentQuizCategory.isTimerRequired
    }
    
    var currentQuestions: CategoryArray {
        return AIQuizDataManager.sharedInstance.currentQuestions
    }
    
    var matchInfo = GKTurnBasedMatch()
    
    private var timer = NSTimer()
    private var timeInterval: NSTimeInterval = 0.05
    private var elapsedTime: NSTimeInterval = 0
    private var timeBegins = NSDate()
    private var timeRemaining = 0
    
    private var playButtonView: ArrowIcon!
    private let settingsManager = AISettings.sharedInstance
    private var blurView: UIVisualEffectView?
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.showActivityIndicator()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "timeIsUp:", name: Notification.TimesUp, object: nil)
        configureUI()
        initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AISettings.sharedInstance.isGameScreenVisible = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioPlayer.stopBackgroundMusic()
        AISettings.sharedInstance.isGameScreenVisible = false
        if isTimerRequired {
            endUpdatingProgress()
        }
        
        //Catching cheater
        if AISettings.sharedInstance.isMultiplayerSupportEnabled == true && AISettings.sharedInstance.isMultiplayerGame && TurnBasedGameHelper.sharedInstance.saveToLoseList {
            if questionIndex <= currentQuestions.count - 1 {
                currentScore = 0
                TurnBasedGameHelper.sharedInstance.saveCurrentMatchInLoseList()
                TurnBasedGameHelper.sharedInstance.saveToLoseList = false
            }
        }
    }
    
    private func configureUI() {
        //rounded picture corner
        pictureForQuestionImageView.layer.cornerRadius = CGRectGetWidth(pictureForQuestionImageView.frame) / 2.0
        pictureForQuestionImageView.layer.masksToBounds = true
        pictureForQuestionImageView.layer.borderWidth = 3
        pictureForQuestionImageView.layer.borderColor = ThemeColor.MainLogoColor.CGColor
        pictureForQuestionImageView.userInteractionEnabled = true
        
        //Show/hide timer
        if isTimerRequired {
            timerView.animateFromAngle(0, toAngle: 360, duration: 1.5, completion: { (_) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.timeLabel.text = "Go!"
                })
            })
        } else {
            timerView.animateFromAngle(0, toAngle: 360, duration: 1.5, completion: { (_) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.timeLabel.text = "∞"
                })
            })
        }
        
        //setup title
        self.navigationItem.title = AIQuizDataManager.sharedInstance.currentQuizCategory.name
        
        //misc
        pointsLabel.text = ""
        questionLabel.text = ""
        questionCountLabel.text = ""
        
        //hides backbutton if multiplayer game
        if settingsManager.isMultiplayerGame == true {
            self.navigationItem.hidesBackButton = true
        }
        
        //setup initial button state
        enableButtons(true, andSetTiltle: "", setHide: nil)
    }
    
    private func initialize() {
        settingsManager.isGameScreenVisible = true
        questionIndex = currentQuestions.count
        
        //delay 1.65 secs then show question
        let delta = (Int64(NSEC_PER_MSEC) * 1650)
        //TODO: - add shahow view (indicator view)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue()) { () -> Void in
            self.audioPlayer.playBackgroundMusic()
            self.appDelegate.hideActivityIndicator()
            self.showQuestionAtIndex(self.questionIndex)
        }
    }
    
    private func showQuestionAtIndex(index: Int) {
        //Initialize state
        showTrueOrFalseButtons(false)
        resetContentInPictureFrame()
        enableButtons(true, andSetTiltle: nil, setHide: false)
        //If no more question, presentn FinalScore VC
        if questionIndex - 1 < 0 {
            enableButtons(false, andSetTiltle: nil, setHide: true)
            if AISettings.sharedInstance.isMultiplayerGame {
                sendTurn()
            } else {
                self.performSegueWithIdentifier(SegueID.ShowFinalScoreVCSegue, sender: self)
            }
            return
        }
        playingQuestions = currentQuestions
        playingQuestion = playingQuestions[questionIndex - 1]
        
        //choices
        setupButtonsForChoices(playingQuestion)
        
        questionLabel.text = playingQuestion[Constants.kquizQuestion] as? String
        
        questionCountLabel.text = "\(currentQuestions.count - questionIndex + 1)/\(currentQuestions.count)"
        
        playingQuestions.removeAtIndex(questionIndex - 1)
        
        if isTimerRequired {
            if let timeLimit = playingQuestion[Constants.kquizQuestionDutation] {
                let duration = timeLimit.integerValue
                startGameTiming(duration)
            }
        }
    }
    
    private func enableButtons(set: Bool, andSetTiltle title: String?, setHide hideButtons: Bool?) {
        let buttons = [self.buttonA, self.buttonB, self.buttonC, self.buttonD]
        if set == true && title == nil {
            for button in buttons {
                button.enabled = set
            }
        } else if set == true && title != nil {
            for button in buttons {
                button.setTitle(title, forState: .Normal)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.enabled = set
            }
        } else if set == false && title == nil {
            for button in buttons {
                button.enabled = !set
            }
        } else if set == false && title != nil {
            for button in buttons {
                button.setTitle(title, forState: .Normal)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.enabled = !set
            }
        }
        
        if hideButtons != nil {
            if hideButtons == true {
                for button in buttons {
                    button.hidden = true
                }
            } else {
                for button in buttons {
                    button.hidden = false
                }
            }
        }
    }
    
    private func setupButtonsForChoices(playingQuestion: CategoryDict) {
        //shuffle or not shuffle the choices
        
        var choices = [String]()
        var unShuffledChoices = [String]()
        if let unShuffled = playingQuestion[Constants.kquizOptions] as? [String] {
            unShuffledChoices = unShuffled
        }
        
        let currentQuestion = playingQuestion[Constants.kquizQuestion] as! String
        
        if let questionType = playingQuestion[Constants.kquizQuestionType] as? String {
            if let questionTypeRaw = Int(questionType) {
                
                switch questionTypeRaw {
                    //TRUE OR FALSE TYPE
                case QuestionType.TrueOrFalse.rawValue:
                    //create unique id for current question
                    let currentQuestionUniqueID = uniqueIDForQuestion(currentQuestion, options: unShuffledChoices, currentQuestionType: questionTypeRaw)
                    
                    AIQuizDataManager.sharedInstance.markQuestionAsRead(currentQuestionUniqueID, forCategoryID: AIQuizDataManager.sharedInstance.currentQuizCategory.catID)
                    
                    showTrueOrFalseButtons(true)
                    
                    pictureForQuestionImageView.userInteractionEnabled = false
                    
                    //TEXT TYPE
                case QuestionType.Text.rawValue:
                    
                    if settingsManager.isShuffleAnswersEnabled == true {
                        choices = unShuffledChoices.shuffle()
                    }
                    
                    //create unique id for current question
                    let currentQuestionUniqueID = uniqueIDForQuestion(currentQuestion, options: choices, currentQuestionType: questionTypeRaw)
                    
                    AIQuizDataManager.sharedInstance.markQuestionAsRead(currentQuestionUniqueID, forCategoryID: AIQuizDataManager.sharedInstance.currentQuizCategory.catID)
                    
                    pictureForQuestionImageView.userInteractionEnabled = false
                    
                    //PICTURE TYPE
                case QuestionType.Picture.rawValue:
                    if settingsManager.isShuffleAnswersEnabled == true {
                        choices = unShuffledChoices.shuffle()
                    }
                    
                    //create unique id for current question
                    let currentQuestionUniqueID = uniqueIDForQuestion(currentQuestion, options: choices, currentQuestionType: questionTypeRaw)
                    AIQuizDataManager.sharedInstance.markQuestionAsRead(currentQuestionUniqueID, forCategoryID: AIQuizDataManager.sharedInstance.currentQuizCategory.catID)
                    var pictureFile = ""
                    if let pictureFileName = playingQuestion[Constants.kquizQuestionPictureOrVideoName] as? String {
                        pictureFile = pictureFileName
                    }
                    
                    let pictureFullPath = AIQuizDataManager.sharedInstance.pathForPictureOrVideoName(pictureFile)
                    
                    pictureForQuestionImageView.userInteractionEnabled = true
                    pictureForQuestionImageView.image = UIImage(contentsOfFile: (pictureFullPath))
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.pictureForQuestionImageView.alpha = 1.0
                    })
                    
                    //VIDEO TYPE
                case QuestionType.Video.rawValue:
                    if settingsManager.isShuffleAnswersEnabled == true {
                        choices = unShuffledChoices.shuffle()
                    }
                    
                    //create unique id for current question
                    let currentQuestionUniqueID = uniqueIDForQuestion(currentQuestion, options: choices, currentQuestionType: questionTypeRaw)
                    
                    AIQuizDataManager.sharedInstance.markQuestionAsRead(currentQuestionUniqueID, forCategoryID: AIQuizDataManager.sharedInstance.currentQuizCategory.catID)
                    
                    var videoFileName = ""
                    if let videoFile = playingQuestion[Constants.kquizQuestionPictureOrVideoName] as? String {
                        videoFileName = videoFile
                    }
                    
                    let videoFullPath = AIQuizDataManager.sharedInstance.pathForPictureOrVideoName(videoFileName)
                    
                    let videoURL = NSURL(fileURLWithPath: videoFullPath)
                    let videoAsset = AVURLAsset(URL: videoURL, options: nil)
                    let thumbnail = AVAssetImageGenerator(asset: videoAsset)
                    let time = CMTimeMake(1, 39)
                    
                    
                    do {
                        let referenceImage: CGImageRef = try thumbnail.copyCGImageAtTime(time, actualTime: nil)
                        let underlayImage = UIImage(CGImage: referenceImage)
                        pictureForQuestionImageView.userInteractionEnabled = true
                        pictureForQuestionImageView.image = underlayImage
                    } catch {
                        print("Image generator failed")
                    }
                    
                    playButtonView = ArrowIcon(frame: pictureForQuestionImageView.bounds)
                    pictureForQuestionImageView.addSubview(playButtonView)
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.pictureForQuestionImageView.alpha = 1.0
                    })
                    
                default:
                    break
                }
                
                //Set title on buttons
                //button titles ->
                
                if questionTypeRaw != QuestionType.TrueOrFalse.rawValue {
                    buttonA.setTitle(choices[0], forState: .Normal)
                    buttonB.setTitle(choices[1], forState: .Normal)
                    buttonC.setTitle(choices[2], forState: .Normal)
                    buttonD.setTitle(choices[3], forState: .Normal)
                }
            }
        }
    }
    
    private func showTrueOrFalseButtons(show: Bool) {
        buttonA.hidden = false
        buttonB.hidden = false
        buttonC.hidden = true
        buttonD.hidden = true
        buttonA.setTitle("True", forState: .Normal)
        buttonB.setTitle("False", forState: .Normal)
    }
    
    private func resetContentInPictureFrame() {
        if playButtonView != nil {
            playButtonView?.removeFromSuperview()
        }
        pictureForQuestionImageView.image = UIImage(named: "defaultQuestionImage")
        pictureForQuestionImageView.userInteractionEnabled = true
    }
    
    private func uniqueIDForQuestion(question: String, options: [String], currentQuestionType: Int) -> String {
        var uniqueIDForQuestion = ""
        if currentQuestionType != QuestionType.TrueOrFalse.rawValue {
            let stringID = "\(question)" + "\(options[0])" + "\(options[1])" + "\(options[2])" + "\(options[3])"
            uniqueIDForQuestion = stringID.md5()
        } else {
            uniqueIDForQuestion = question.md5()
        }
        return uniqueIDForQuestion
    }
    
    func skipQuestion() {
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 1500)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.appDelegate.hideActivityIndicator()
            SoundManager.sharedInstance.playTapSound()
            self.timer.invalidate()
            self.showQuestionAtIndex(--self.questionIndex)
        })
    }
    
    
    private func showExplanation(forAnswerType: String) {
        if AISettings.sharedInstance.showExplanation == true {
            switch forAnswerType {
            case Constants.kCorrectAnsExplanation:
                //Explanations
                //For Right Answer
                if let explanationForRightAnswer = playingQuestion[forAnswerType] as? String {
                    let explanationAlert = UIAlertController(title: "Wait... Why?", message: explanationForRightAnswer, preferredStyle: UIAlertControllerStyle.Alert)
                    explanationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                        self.showQuestionAtIndex(self.questionIndex)
                    }))
                    self.presentViewController(explanationAlert, animated: true, completion: nil)
                } else {
                    self.showQuestionAtIndex(self.questionIndex)
                }
                
            case Constants.kWrongAnsExplanation:
                //For Wrong Answer
                if let explanationForWrongAnswer = playingQuestion[forAnswerType] as? String {
                    let explanationAlert = UIAlertController(title: "Wait... Why?", message: explanationForWrongAnswer, preferredStyle: UIAlertControllerStyle.Alert)
                    explanationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                        self.showQuestionAtIndex(self.questionIndex)
                    }))
                    self.presentViewController(explanationAlert, animated: true, completion: nil)
                } else {
                    self.showQuestionAtIndex(self.questionIndex)
                }
                
            default:
                print("No Xplanation Set")
            }
        } else {
            self.showQuestionAtIndex(self.questionIndex)
        }
    }
    
    //MARK: - IBActions
    @IBAction func skipButtonTapped(sender: UIBarButtonItem) {
        skipQuestion()
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        appDelegate.showActivityIndicator()
        if let questionType = playingQuestion[Constants.kquizQuestionType] as? String {
            if let questionTypeRaw = Int(questionType) {
                switch questionTypeRaw {
                case QuestionType.Video.rawValue:
                    if let videoFileName = playingQuestion[Constants.kquizQuestionPictureOrVideoName] as? String {
                        let videoFullPath = AIQuizDataManager.sharedInstance.pathForPictureOrVideoName(videoFileName)
                        
                        let URL = NSURL(fileURLWithPath: videoFullPath)
                        
                        let videoPlayer = AVPlayer(URL: URL)
                        let playerVC = AVPlayerViewController()
                        playerVC.player = videoPlayer
                        playerVC.view.frame = self.view.bounds
                        
                        presentViewController(playerVC, animated: true, completion: { () -> Void in
                            self.appDelegate.hideActivityIndicator()
                            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidReachEndNotificationHandler:", name: Notification.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
                            
                            playerVC.player!.play()
                        })
                    }
                default:
                    appDelegate.showActivityIndicator()
                    performSegueWithIdentifier(SegueID.ShowImageDetailSegue, sender: sender)
                }
            }
        }
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        var correctAnswer = ""
        
        if isTimerRequired {
            endUpdatingProgress()
        }
        --questionIndex
        enableButtons(false, andSetTiltle: nil, setHide: nil)
        
        //Correct answer
        if let answers = playingQuestion[Constants.kquizOptions] as? [String] {
            correctAnswer = answers[0]
        } else {
            //Correct Answer for True/False Type
            if let answer = playingQuestion["Answer"] as? String {
                if answer == "0" {
                    correctAnswer = "False"
                } else {
                    correctAnswer = "True"
                }
            }
        }

        //Answer Time Spent
        let answerTimeSpent = Int(elapsedTime)
        
        //Critical Seconds To Get Full Points
        let fullPointTimeLimit = Int(AISettings.sharedInstance.fullPointsBeforeSeconds)
        
        //Point For Current Question
        var questionPoint = 0
        if let pointForCurrentQuestion = playingQuestion[Constants.kquizPoints]?.integerValue {
            questionPoint = pointForCurrentQuestion
        }
        
        //Answered correctly
        if sender.titleLabel?.text == correctAnswer {
            SoundManager.sharedInstance.playSoundForAnswer(forAnswerType: true)
            
            if isTimerRequired {
                //Points Earned within critical time
                
                if answerTimeSpent <= fullPointTimeLimit {
                    currentScore += questionPoint
                } else {
                    //Points for time based score
                    if AISettings.sharedInstance.isTimerbasedScoreEnabled == true {
                        //currentScore += (questionPoint - Int(timer.elapsedTime))
                        currentScore += (questionPoint - Int(elapsedTime))
                    } else {
                        currentScore += questionPoint
                    }
                }
            } else {
                currentScore += questionPoint
            }
            
            //Show Explanation for Right Answer
            showExplanation(Constants.kCorrectAnsExplanation)
            
        } else {
            //Wrong answered
            SoundManager.sharedInstance.playSoundForAnswer(forAnswerType: false)
            
            //Report Score
            if AISettings.sharedInstance.isMultiplayerGame {
                //No deduction point for multiplayer game
            } else {
                if let negativeScore = playingQuestion[Constants.kquizNegativePoints]?.integerValue {
                    currentScore -= negativeScore
                }
            }
            
            pointsLabel.text = "\(currentScore)"
            
            //Explanation for Wrong Answer
            showExplanation(Constants.kWrongAnsExplanation)
        }
        pointsLabel.text = "\(currentScore)"
    }
    
    func startGameTiming(timeLimit: Int) {
        let totalTimeLimit = NSTimeInterval(timeLimit)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.timerView.animateFromAngle(0, toAngle: 360, duration: totalTimeLimit, completion: nil)
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "updateProgress:", userInfo: timeLimit, repeats: true)
    }
    
    //MARK: - Timing
    func updateProgress(sender: NSTimer) {
        let timeLimit = sender.userInfo as! Int
        timeLabel.text = "\(timeLimit)"
        elapsedTime = NSDate().timeIntervalSinceDate(timeBegins)
        timeRemaining = timeLimit - Int(elapsedTime)
        timeLabel.text = "\(timeRemaining)"
        
        if timeRemaining == 0 {
            appDelegate.showActivityIndicator()
            endUpdatingProgress()
            let triggerTime = (Int64(NSEC_PER_MSEC) * 100)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.TimesUp, object: nil)
            })
        }
    }
    
    func timeIsUp(notification: NSNotification) {
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 100)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.skipQuestion()
        })
    }
    
    func endUpdatingProgress() {
        elapsedTime = 0.0
        timerView.stopAnimation()
        timeLabel.text = "Time!"
        timer.invalidate()
        timeBegins = NSDate()
    }
    
    
    //MARK: - Navigation
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView!.frame = self.view.bounds
        blurView!.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = self.view.bounds
        
        self.view.addSubview(blurView!)
        blurView!.contentView.addSubview(vibrancyView)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.blurView?.removeFromSuperview()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueID.ShowImageDetailSegue {
            
            var pictureFullPath: String? = nil
            if let questionType = playingQuestion[Constants.kquizQuestionType] as? String {
                if let questionTypeRaw = Int(questionType) {
                    switch questionTypeRaw {
                        //TRUE OR FALSE TYPE
                    case QuestionType.Picture.rawValue:
                        if let pictureFileName = playingQuestion[Constants.kquizQuestionPictureOrVideoName] as? String {
                            pictureFullPath = AIQuizDataManager.sharedInstance.pathForPictureOrVideoName(pictureFileName)
                        }
                    default:
                        return
                    }
                }
            }
            
            let popOverVC = segue.destinationViewController as! MediaViewController
            popOverVC.modalPresentationStyle = .Popover
            popOverVC.popoverPresentationController?.delegate = self
            if pictureFullPath != nil {
                popOverVC.localImagePath = pictureFullPath
                if let image = UIImage(contentsOfFile: pictureFullPath!) {
                    popOverVC.preferredContentSize = image.size
                    popOverVC.popoverPresentationController?.permittedArrowDirections = .Any
                }
            }
        } else if segue.identifier == SegueID.ShowFinalScoreVCSegue {
            let finalVC = segue.destinationViewController as! FinalScoreViewController
            finalVC.currentScore = currentScore
        } else if segue.identifier == SegueID.ShowMultiPlayerFinalScoreVC
        {
            print("PREPARED TO SEGUE TO MULTI FINAL VC")
            let finalTurnbasedVC = segue.destinationViewController as! TurnBasedFinalViewController
            finalTurnbasedVC.match = self.matchInfo
            finalTurnbasedVC.currentScore = currentScore
            finalTurnbasedVC.presentedModally = true
            
        } else if segue.identifier == SegueID.ShowHomePageSegue {
            print("back to root segue")
        }
    }
    
    //MARK: - Notification
    func playerDidReachEndNotificationHandler(notification: NSNotification) {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seekToTime(kCMTimeZero)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.audioPlayer.playBackgroundMusic()
    }
    
    //MARK: - TurnbasedGameDelegate
    func sendTurn() {
        let currentMatch: GKTurnBasedMatch = TurnBasedGameHelper.sharedInstance.currentMatch!
        //Second & Final Turn
        if currentMatch.matchData!.length > 0 {
            //This is Second & Final Turn
            TurnBasedGameHelper.sharedInstance.saveToLoseList = false
            
            let data = AIQuizDataManager.sharedInstance.newDataForMatchData(currentMatch.matchData!, withPoint: Int64(currentScore), forPlayerID: currentMatch.currentParticipant!.player!.playerID!)
            let quizDict = AIQuizDataManager.sharedInstance.dataDictionaryFromPreviousParticipantMatchData(currentMatch.matchData!)

            
            let player1 = currentMatch.currentParticipant
            let otherPlayer = currentMatch.participants!.filter(){ ($0 ) != player1 }
            let player2 = otherPlayer.first
            
            var othersScore: Int64 = 0
            
            if let otherPlayer = player2 {
                let player2ID = otherPlayer.player!.playerID
                let player2Index = player2ID! + "_points"
                othersScore = Int64(quizDict[player2Index]!.intValue)
            }
            
            if Int64(currentScore) < othersScore {
                player1?.matchOutcome = GKTurnBasedMatchOutcome.Lost
                player2?.matchOutcome = GKTurnBasedMatchOutcome.Won
            } else if Int64(currentScore) == othersScore {
                player1?.matchOutcome = GKTurnBasedMatchOutcome.Tied
                player2?.matchOutcome = GKTurnBasedMatchOutcome.Tied
            } else {
                TurnBasedGameHelper.sharedInstance.iWon()
                player1?.matchOutcome = GKTurnBasedMatchOutcome.Won
                player2?.matchOutcome = GKTurnBasedMatchOutcome.Lost
            }
            
            appDelegate.showActivityIndicator()
            currentMatch.endMatchInTurnWithMatchData(data, completionHandler: { (error) -> Void in

                
                TurnBasedGameHelper.sharedInstance.saveToLoseList = false
                if error != nil {
                    TurnBasedGameHelper.sharedInstance.currentMatchScore = Int64(self.currentScore)
                    TurnBasedGameHelper.sharedInstance.saveCurrentMatchInResubmissionList()
                    
                    let alertController = UIAlertController(title: "Oops", message: "Error submitting match. Will try again Later", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                        //self.navigationController?.popToRootViewControllerAnimated(true)
                        let presentingVC = self.presentingViewController!
                        if presentingVC is UINavigationController {
                            self.dismissViewControllerAnimated(true, completion: nil)
                            (presentingVC as! UINavigationController).popToRootViewControllerAnimated(true)
                            
                        } else {
                            self.dismissViewControllerAnimated(true) { () -> Void in
                                presentingVC.dismissViewControllerAnimated(false, completion: nil)
                                
                            }
                        }
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    print("no error endMatchInTurnWithMatchData")
                    self.matchInfo = currentMatch
                    self.performSegueWithIdentifier(SegueID.ShowMultiPlayerFinalScoreVC, sender: self)
                }
                self.appDelegate.hideActivityIndicator()
            })
            
        } else {
            var currentIndex = 0
            let index = 0
    
            for particip in currentMatch.participants! {
                print(currentMatch.currentParticipant)
                if particip as NSObject == currentMatch.currentParticipant {
                    currentIndex = index
                }
            }
            let nextIndex = (currentIndex + 1) % currentMatch.participants!.count
            let nextParticipant = currentMatch.participants![nextIndex]

            let data = AIQuizDataManager.sharedInstance.dataForMultiplayer(AIQuizDataManager.sharedInstance.currentCategoryDict, andQuestions: currentQuestions, pointsObtained: Int64(currentScore), forPlayerID: currentMatch.currentParticipant!.player!.playerID!)
    
            if data.length <= currentMatch.matchDataMaximumSize {
                appDelegate.showActivityIndicator()
                currentMatch.endTurnWithNextParticipants([nextParticipant], turnTimeout: GKTurnTimeoutNone, matchData: data, completionHandler: { (error) -> Void in
                    if error != nil {
                        let alertController = UIAlertController(title: "Error", message: "Error submitting turn to GameCenter. Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        //self.navigationController?.popToRootViewControllerAnimated(true)
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
                    
                        TurnBasedGameHelper.sharedInstance.addMatchID(currentMatch.matchID!)
                        self.matchInfo = currentMatch
                        self.performSegueWithIdentifier(SegueID.ShowMultiPlayerFinalScoreVC, sender: self)
                        //PUSH SCREEN TO FINAL SCREEN
                    }
                    self.appDelegate.hideActivityIndicator()
                })

            } else {
                let alertController = UIAlertController(title: "Data Size Error", message: "Data size is bigger than matchDataMaxSize. Please reset category_questions_max_limit for /", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                    self.performSegueWithIdentifier(SegueID.ShowHomePageSegue, sender: self)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
}





























