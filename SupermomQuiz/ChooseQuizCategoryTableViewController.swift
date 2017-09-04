//
//  ChooseQuizCategoryTableViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/19/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

class ChooseQuizCategoryTableViewController: UITableViewController {
    
    var fullScreenAds: RevMobFullscreen?
    var bannerAd: RevMobBanner?
    let quizManager = AIQuizDataManager.sharedInstance
    lazy var allQuizCategories: [CategoryArray] = {
        return [AIQuizDataManager().freeAndPurchasedQuizCategory, AIQuizDataManager().purchaseRequiredQuizCategory]
    }()
    
    var freeAndPurchasedQuiz: CategoryArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showRevmobAds:", name: "RevmobSessionStarted", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if AISettings.sharedInstance.requiredAdDisplay() {
            fullScreenAds?.delegate = nil
            bannerAd?.hideAd()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeAndPurchasedQuiz.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var currentName = ""
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.ChooseQuizCategory, forIndexPath: indexPath) as! ChooseQuizTableViewCell
        
        //Free & Purchased Categories
        let quizCategory = freeAndPurchasedQuiz[indexPath.row]
        
        //Highscores
        if let currentCategoryName = quizCategory[Constants.kquizCategoryName] as? String {
            currentName = currentCategoryName
            for cat in quizManager.highScores {
                //Test if same name, get the high score of that name
                if currentName == cat[Constants.kquizCategoryName] as! String {
                    let highScore = cat[Constants.kHighScore] as! Int
                    cell.scoreLabel.text = "\(highScore)"
                    //Set ProgressView:
                    if let catIDString = cat[Constants.kquizCategoryId] as? String {
                        if let catID = Int(catIDString) {
                            
                            let questionsCount = Float(self.quizManager.questionsForCategoryID(catID).count)
                            let attemptedCount = Float(self.quizManager.attemptedQuestionsCountForCategory(catID))
                            let attemptedPercentage = ceil((attemptedCount / questionsCount) * 100.0) > 100.0 ? 100.0 : (attemptedCount / questionsCount) * 100
                            
                            cell.percentLabel.text = "Completed"
                            cell.percentProgress.text = "\(Int(attemptedPercentage))%"
                            cell.progressView.setProgress(attemptedPercentage / 100.0, animated: true)
                        }
                    }
                }
            }
        }
        
        
        //Title & Description
        cell.titleLabel.text = currentName
        cell.descriptionLabel.text = quizCategory[Constants.kquizCategoryDescription] as? String
        
        //Image
        if let imageFile = quizCategory[Constants.kquizCategoryImagePath] as? String {
            cell.categoryImageView.image = AIUtilities.getImageFromCategory(imageFile)
        }
        
        //Clock View Hide/Unhide
        if let timerRequired = quizCategory[Constants.kTimerRequired]?.boolValue {
            if timerRequired {
                cell.clockView.hidden = false
            } else {
                cell.clockView.hidden = true
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.layer.transform = CATransform3DIdentity
        })
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        playQuizAtIndex(indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case SegueID.ChooseQuizToGameVCSegue:
                if AISettings.sharedInstance.isMultiplayerGame {
                    let gameVC = segue.destinationViewController as! GameViewController
                    gameVC.navigationItem.hidesBackButton = true
                }
            default:
                break
            }
        }
    }
    
    private func playQuizAtIndex(index: Int) {
        let playableQuizzes = quizManager.freeAndPurchasedQuizCategory
        
        let playingQuizCateogry = playableQuizzes[index]
        
        //Notify QuizManager & set playing quiz category
        quizManager.currentCategoryDict = playingQuizCateogry
        
        //Setup variables
        var currentNumberOfQuestionRequiredAfterShuffle = 0
        var currentCategoryName = ""
        var currentQuizID = 0
        var currentTimerRequired = true
        
        //Extract QuizID, QuizName, QuizLimit, TimeRequired Info
        //Current Quiz ID
        if let quizID = playingQuizCateogry[Constants.kquizCategoryId]?.integerValue {
            currentQuizID = quizID
        }
        
        //Current Quiz Name
        if let currentCatName = playingQuizCateogry[Constants.kquizCategoryName] as? String {
            currentCategoryName = currentCatName
        }
        
        //Current Quiz Limit
        if let currentLimit = playingQuizCateogry[Constants.kCategoryQuestionLimit]?.integerValue {
            currentNumberOfQuestionRequiredAfterShuffle = currentLimit
        }
        
        //Current Quiz isTimerRequired
        if let currentTimerRequiredStatus = playingQuizCateogry[Constants.kTimerRequired] as? Bool {
            currentTimerRequired = currentTimerRequiredStatus
        }
        
        //Current Quiz Numbers Req'd after shuffle
        if currentNumberOfQuestionRequiredAfterShuffle == 0 {
            let alert = UIAlertController(title: "Warning", message: "category_questions_max_limit is set to zero or key is missing for the category \(currentCategoryName) and also make sure this count should not be more than number of questions in the Quetions_Category_\(currentQuizID)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        //Send data to QuizManager
        AIQuizDataManager.sharedInstance.currentQuizCategory = (currentCategoryName, currentQuizID, currentNumberOfQuestionRequiredAfterShuffle, currentTimerRequired)
        
        performSegueWithIdentifier(SegueID.ChooseQuizToGameVCSegue, sender: self)
    }
    
    //Revmob Observer
    func showRevmobAds(notification: NSNotification) {
        print("start revmob ok")
        if AISettings.sharedInstance.requiredAdDisplay() {
            if let fullScreenAds = RevMobAds.session().fullscreen() {
                fullScreenAds.loadWithSuccessHandler({ (fullscreen) -> Void in
                    fullscreen.showAd()
                    }, andLoadFailHandler: { (fullscreen, error) -> Void in
                        print(error.localizedDescription)
                })
                
            }
            bannerAd = RevMobAds.session().banner()
            bannerAd?.loadWithSuccessHandler({ (banner) -> Void in
                banner.showAd()
                }, andLoadFailHandler: { (_, error) -> Void in
                    print(error)
                }, onClickHandler: { (banner) -> Void in
            })
        }
    }
}


















