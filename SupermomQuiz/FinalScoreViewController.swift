//
//  FinalScoreViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/1/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import GameKit

class FinalScoreViewController: UIViewController, UITableViewDataSource, GKGameCenterControllerDelegate {
    
    var currentScore = 0
    
    private var freeAndPurchased: CategoryArray {
        return AIQuizDataManager().freeAndPurchasedQuizCategory
    }
    
    private var currentHighScores: CategoryArray = { return AIQuizDataManager().highScores }()

    private var currentQuizCategory: (name: String, catID: Int, numberOfShuffledQuestions: Int, isTimerRequired: Bool) {
        return AIQuizDataManager.sharedInstance.currentQuizCategory
    }
    
    @IBOutlet weak var facebookIcon: FacebookLogo!
    @IBOutlet weak var twitterIcon: TwitterLogo!
    @IBOutlet weak var gameCenterIcon: GameCenterIcon!
    @IBOutlet weak var houseIcon: HouseIcon!
    
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToViews()
        currentScoreLabel.text = "\(currentScore)"
        if currentScore > 0 {
            
            //If currentScore > 0, call quizManager.highScores to check if newScore is greater than previousScore
            let newScore: CategoryDict = ["highScore":currentScore, "category_id": currentQuizCategory.catID, "category_name": currentQuizCategory.name]
            
            //Find index of subject category, remove, and replace with new one
            
            if let idx = currentHighScores.indexOf( { $0[Constants.kquizCategoryName] as! String == currentQuizCategory.name } ) {
                currentHighScores.removeAtIndex(idx)
                currentHighScores.insert(newScore, atIndex: idx)
            }
            let newScoreForCurrentCateogry = currentHighScores.filter( {$0["category_name"] as? String == currentQuizCategory.name})
            //Check if new score is higher than previous
            
            AIQuizDataManager().highScores = newScoreForCurrentCateogry
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func addTapGestureToViews() {
        let views = [facebookIcon, twitterIcon, gameCenterIcon, houseIcon]
        for icon in views {
            
            let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
            tap.numberOfTapsRequired = 1
            icon.addGestureRecognizer(tap)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeAndPurchased.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.FinalScore, forIndexPath: indexPath) as! FinalScoreTableViewCell
        
        //Cell Image
        if let imageFile = freeAndPurchased[indexPath.row][Constants.kquizCategoryImagePath] as? String {
            cell.cellImage.image = AIUtilities.getImageFromCategory(imageFile)
        }
        
        cell.quizName.text = freeAndPurchased[indexPath.row][Constants.kquizCategoryName] as? String
        cell.quizDescription.text = freeAndPurchased[indexPath.row][Constants.kquizCategoryDescription] as? String
        
        //Highscores
        cell.bestScoreLabel.text = "\(currentHighScores[indexPath.row][Constants.kHighScore]!)"
        
        return cell
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        switch sender.view {
        case is FacebookLogo:
            print("Facebook")
            SocialHelper.sharedInstance.beginFacbooking()
        case is TwitterLogo:
            print("Twitter")
            SocialHelper.sharedInstance.beginTwitting()
        case is GameCenterIcon:
            print("GameCenter")
            let gameViewController = GKGameCenterViewController()
            gameViewController.gameCenterDelegate = self
            gameViewController.viewState = GKGameCenterViewControllerState.Leaderboards
            presentViewController(gameViewController, animated: true, completion: nil)
        case is HouseIcon:
            print("Home")
            let presentingVC = self.presentingViewController!
            let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
            self.dismissViewControllerAnimated(true) { () -> Void in
                navigationController?.popToRootViewControllerAnimated(true)
            }
        default:
            break
        }
    }

    //GameCenterDelegate 
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
















