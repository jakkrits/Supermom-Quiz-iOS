//
//  AIQuizManager.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/19/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation

class AIQuizDataManager: NSObject {
    static let sharedInstance = AIQuizDataManager()
    var useSourceDataFormat: QuizDataFormatType!
    private var _highScores: CategoryArray?
    private var _freeAndPurchasedQuizCategory: CategoryArray?
    private var _purchaseRequiredQuizCategory: CategoryArray?
    private var _allQuizCategory: CategoryArray?
    private var _progress: Float = 0
        
    private var currentQuizCategoryName: String!
    private var allPurchaseIdentifiers: ProductIdentifiers?
    private var _currentCategoryDict: CategoryDict!
    private var _currentQuestions: CategoryArray!
    
    var highScores: CategoryArray {
        get {
            if _highScores == nil && !NSFileManager.defaultManager().fileExistsAtPath(DocumentPath.kHiScorePlistFilePath) {
                _highScores = CategoryArray()
                setInitialHighScores()
            }
            _highScores = NSArray(contentsOfFile: DocumentPath.kHiScorePlistFilePath) as? CategoryArray
            return _highScores!
        }
        set {
            print(newValue)
            if let score = newValue[0][Constants.kHighScore] as? Int, id = newValue[0][Constants.kquizCategoryId] as? Int {
                setHighScore(score, forQuizCategoryID: id)
            }
        }
    }
    
    var freeAndPurchasedQuizCategory: CategoryArray {
        get {
            if _freeAndPurchasedQuizCategory == nil {
                _freeAndPurchasedQuizCategory = quizCategoriesFreeAndPurchased()
            }
            return _freeAndPurchasedQuizCategory!
        }
    }
    
    var purchaseRequiredQuizCategory: CategoryArray {
        get {
            if _purchaseRequiredQuizCategory == nil {
                _purchaseRequiredQuizCategory = quizCategoriesRequirePurchase()
            }
            return _purchaseRequiredQuizCategory!
        }
    }
    
    var allQuizCategory: CategoryArray {
        get {
            if _allQuizCategory == nil {
                _allQuizCategory = allQuizCategories()
            }
            return _allQuizCategory!
        }
    }
    
    //Current Variables
    //Set by playQuizAtIndex(index: Int) in ChooseQuizCategoryTableViewController
    var currentCategoryDict: CategoryDict {
        get {
            return _currentCategoryDict
        }
        set (newValue) {
            _currentCategoryDict = newValue
        }
    }
    
    var name: String!
    var catID: Int!
    var numberOfShuffledQuestions: Int!
    var isTimerRequired: Bool!
    
    var currentQuizCategory: (name: String, catID: Int, numberOfShuffledQuestions: Int, isTimerRequired: Bool) {
        get {
            return (self.name, self.catID, self.numberOfShuffledQuestions, self.isTimerRequired)
        }
        set {
            self.name = newValue.name
            self.catID = newValue.catID
            self.numberOfShuffledQuestions = newValue.numberOfShuffledQuestions
            self.isTimerRequired = newValue.isTimerRequired
        }
    }
    
    var currentQuestions: CategoryArray {
        _currentQuestions = self.questionsForCategoryID(currentQuizCategory.catID)
        return _currentQuestions
    }
    
    override init() {
        super.init()
        //Check Settings
        //Input Data Format
        if AISettings.sharedInstance.dataInputFormat == "json" {
            useSourceDataFormat = QuizDataFormatType.JSONFormat
        }
        
        updateQuestionsCountForAllCategories()
        validateAppStoreDataOnAppUpdate()
    }
    
    //MARK: Highscores Functions
    private func setInitialHighScores() {
        if _highScores == nil || !NSFileManager.defaultManager().fileExistsAtPath(DocumentPath.kHiScorePlistFilePath) {
            _highScores = CategoryArray()
        }
        
        var categories = CategoryArray()
        
        if quizCategoriesFreeAndPurchased().count > allQuizCategories().count {
            categories = quizCategoriesFreeAndPurchased()
        } else {
            categories = allQuizCategories()
        }
        
        var highScoreDict: CategoryDict = Dictionary(minimumCapacity: categories.count)
        for element in categories {
            if let cat_name = element[Constants.kquizCategoryName] as? String, cat_id = element[Constants.kquizCategoryId] as? String {
                highScoreDict.updateValue(cat_id, forKey: Constants.kquizCategoryId)
                highScoreDict.updateValue(cat_name, forKey: Constants.kquizCategoryName)
                highScoreDict.updateValue(NSNumber(unsignedLongLong: 0), forKey: Constants.kHighScore)
                _highScores!.append(highScoreDict)
            }}
        (_highScores! as NSArray).writeToFile(DocumentPath.kHiScorePlistFilePath, atomically: true)
    }
    
    private func allQuizCategories() -> CategoryArray {
        if _allQuizCategory == nil {
            _allQuizCategory = CategoryArray()
        }
        if useSourceDataFormat == QuizDataFormatType.JSONFormat {
            let jsonData = JSON(data: NSData(contentsOfFile: DocumentPath.kQuizCatJSONSandboxFilePath)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            _allQuizCategory = parseJSONToCategory(jsonData, forKey: "Categories")
        }

        //ColorLog.red("JSON Category Array \(_allQuizCategory)")
        return _allQuizCategory!
    }
    
    //check both free and purchased
    private func quizCategoriesFreeAndPurchased() -> CategoryArray {
        var categoriesArray = CategoryArray()
        if _freeAndPurchasedQuizCategory == nil {
            _freeAndPurchasedQuizCategory = CategoryArray()
        }
        if useSourceDataFormat == QuizDataFormatType.JSONFormat {
            
            if let data = NSData(contentsOfFile: DocumentPath.kQuizCatJSONSandboxFilePath) {
                categoriesArray = parseJSONToCategory(JSON(data: data, options: NSJSONReadingOptions(), error: nil), forKey: "Categories")
            }
            
            if !AISettings.sharedInstance.isInAppPurchaseSupported {
                return categoriesArray
            }
            
            for categoryDict in categoriesArray {
                let id = categoryDict[Constants.kProductIdentifier] as? String
                
                if id != nil {
                    if !id!.isEmpty {
                        if InAppHelper.sharedInstance.isProductPurchased(id!) {
                            _freeAndPurchasedQuizCategory!.append(categoryDict)
                        }
                    } else {
                        _freeAndPurchasedQuizCategory!.append(categoryDict)
                    }
                }
            }  
        }

        return _freeAndPurchasedQuizCategory!
    }
    
    private func quizCategoriesRequirePurchase() -> CategoryArray {
        var categoriesArray = CategoryArray()
        if _purchaseRequiredQuizCategory == nil {
            _purchaseRequiredQuizCategory = CategoryArray()
        }
        if useSourceDataFormat == QuizDataFormatType.JSONFormat {
            if let data = NSData(contentsOfFile: DocumentPath.kQuizCatJSONSandboxFilePath) {
                categoriesArray = parseJSONToCategory(JSON(data: data, options: NSJSONReadingOptions(), error: nil), forKey: "Categories")
            }
        }

        for categoryDict in categoriesArray {
            let id = categoryDict[Constants.kProductIdentifier] as? String
            if id != nil {
                if !id!.isEmpty {
                    if InAppHelper.sharedInstance.isProductPurchased(id!) == false {
                        _purchaseRequiredQuizCategory!.append(categoryDict)
                    }
                }
            }
        }
        return _purchaseRequiredQuizCategory!
    }
    
    func parseJSONToCategory(json: JSON, forKey: String) -> CategoryArray {
        var tempArray = CategoryArray()
        for result in json[forKey].arrayValue {
            let category_id = result[Constants.kquizCategoryId].stringValue
            let timer_required = result[Constants.kTimerRequired].boolValue
            let category_name = result[Constants.kquizCategoryName].stringValue
            let leaderboard_id = result[Constants.kLeaderboardID].stringValue
            let category_description = result[Constants.kquizCategoryDescription].stringValue
            let category_image_path = result[Constants.kquizCategoryImagePath].stringValue
            let category_questions_max_limit = result[Constants.kCategoryQuestionLimit].stringValue
            let productIdentifier = result[Constants.kProductIdentifier].stringValue
            
            let obj = [Constants.kTimerRequired: timer_required, Constants.kquizCategoryName: category_name, Constants.kquizCategoryId: category_id, Constants.kLeaderboardID: leaderboard_id, Constants.kquizCategoryDescription: category_description, Constants.kquizCategoryImagePath: category_image_path, Constants.kCategoryQuestionLimit: category_questions_max_limit, Constants.kProductIdentifier: productIdentifier]
            tempArray.append(obj as! [String: AnyObject])
        }
        return tempArray
    }
    
    private func setHighScore(highScore: Int, forQuizCategoryID catID: Int) {
        assert(catID != 0, "CategoryID = 0")
        var found = false
        
        _highScores = NSArray(contentsOfFile: DocumentPath.kHiScorePlistFilePath) as? CategoryArray
        
        
        if _highScores == nil && !NSFileManager.defaultManager().fileExistsAtPath(DocumentPath.kHiScorePlistFilePath) {
            setInitialHighScores()
            _highScores = NSArray(contentsOfFile: DocumentPath.kHiScorePlistFilePath) as? CategoryArray
        }
        
        var tempID = 0
        var tempDict = CategoryDict()
        for scoreDict in _highScores! {
            if let categoryID = (scoreDict[Constants.kquizCategoryId])?.integerValue {
                if catID == categoryID {
                    found = true
                    tempID = catID
                    tempDict = scoreDict
                    break
                }
            }
        }
        if found {
            if let previousHighScore = tempDict[Constants.kHighScore] as? Int {
                if highScore > previousHighScore {
                    if let categoryDict = self.categoryDictForCategoryId(tempID) {
                        var updatedArray = CategoryArray()
                        for dict in _highScores! {
                            if let tempID = dict[Constants.kquizCategoryId]?.integerValue {
                                if tempID == catID {
                                    var newDict = dict
                                    newDict.updateValue(highScore, forKey: Constants.kHighScore)
                                    updatedArray.append(newDict)
                                } else {
                                    updatedArray.append(dict)
                                }
                            }
                        }
                        print(categoryDict)
                        (updatedArray as NSArray).writeToFile(DocumentPath.kHiScorePlistFilePath, atomically: true)
                    }
                    
                } else {
                    print("HIGHSCORE <= PREVIOUS SCORE")
                }
            }
        }
        else {
            var updatedArray = CategoryArray()
            var updatedDict = CategoryDict()
            if let categoryDict = self.categoryDictForCategoryId(tempID) {
                updatedDict.updateValue(catID, forKey: Constants.kquizCategoryId)
                updatedDict.updateValue(categoryDict[Constants.kHighScore] as! Int, forKey: Constants.kHighScore)
                updatedDict.updateValue(categoryDict[Constants.kquizCategoryName] as! String, forKey: Constants.kquizCategoryName)
                for dict in _highScores! {
                    updatedArray.append(dict)
                }
                updatedArray.append(updatedDict)
                (updatedArray as NSArray).writeToFile(DocumentPath.kHiScorePlistFilePath, atomically: true)
            }
        }
    }
    
    func categoryDictForCategoryId(catID: Int) -> CategoryDict? {
        assert(catID != 0, "CategoryID = 0")
        let categories = allQuizCategories()
        for categoryDict in categories {
            let ID = categoryDict[Constants.kquizCategoryId] as! String
            if Int(ID) == catID {
                return categoryDict
            }
        }
        print("Category ID is not configured properly")
        return nil
    }
    
    private func highScoreDictForQuizCategory(catID: Int) -> CategoryDict {
        var returnedDict = CategoryDict()
        _highScores = NSArray(contentsOfFile: DocumentPath.kHiScorePlistFilePath) as? CategoryArray
        for highScoreDict in _highScores! {
            if catID == Int((highScoreDict[Constants.kquizCategoryId] as? String)!) {
                returnedDict = highScoreDict
            }
        }
        return returnedDict
    }
    
    private func highScoreForQuizCategory(catID: Int) -> Int {
        var highScore = 0
        
        if let highScoresArray = NSArray(contentsOfFile: DocumentPath.kHiScorePlistFilePath) as? CategoryArray {
            for scoreDict in highScoresArray {
                if let tempID = scoreDict[Constants.kquizCategoryId] as? String {
                    if let id = Int(tempID) {
                        highScore = scoreDict[Constants.kHighScore] as! Int
                        print("Highscore for id \(id) is \(highScore)")
                    }
                }
            }
        }
        return highScore
    }
    
    private func getIntArrayOfHighScores() -> [Int] {
        print("Returning array of integer for \(__FUNCTION__)")
        var scores = [Int]()
        if _highScores == nil && !NSFileManager.defaultManager().fileExistsAtPath(DocumentPath.kHiScorePlistFilePath) {
            setInitialHighScores()
        }
        
        for (_, value) in _highScores!.enumerate() {
            if let score = (value[Constants.kHighScore] as? Int) {
                scores += [score]
            }
        }
        return scores
    }
    
    //MARK: - AppStore Related
    private func validateAppStoreDataOnAppUpdate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let previousAppVersion = defaults.objectForKey(Constants.kappVersion) as? String
        var validated = false
        
        if previousAppVersion == nil && self.getIntArrayOfHighScores().count != 0 {
            validated = true
            defaults.setObject(currentAppVersion, forKey: Constants.kappVersion)
            defaults.synchronize()
        } else if currentAppVersion != previousAppVersion! {
            validated = true
            defaults.setObject(currentAppVersion, forKey: Constants.kappVersion)
            defaults.synchronize()
        }
        
        if validated {
            let categories = allQuizCategories()
            var newHighScores = CategoryArray()
            for categoryDict in categories {
                guard let tempID = categoryDict[Constants.kquizCategoryId]?.integerValue else {
                    print("error quiz category id in function \(__FUNCTION__)")
                    break
                }
                
                var hiScoreDict = highScoreDictForQuizCategory(tempID)
                
                if hiScoreDict.isEmpty {
                    hiScoreDict.updateValue(categoryDict[Constants.kquizCategoryId]!, forKey: Constants.kquizCategoryId)
                    hiScoreDict.updateValue(categoryDict[Constants.kquizCategoryName]!, forKey: Constants.kquizCategoryName)
                    hiScoreDict.updateValue(0, forKey: Constants.kHighScore)
                    newHighScores.append(hiScoreDict)
                } else {
                    newHighScores.append(hiScoreDict)
                }
            }
            (newHighScores as NSArray).writeToFile(DocumentPath.kHiScorePlistFilePath, atomically: true)
        }
    }
    
    //MARK: - Attempted Question Functions
    func markQuestionAsRead(question: String, forCategoryID categoryID: Int) {
        let attemptedQuestionsFilePath = DocumentPath.kDocumentsFolderPath + "/attempted_questions_for_\(categoryID).plist"
        var attemptedQuestions = [String]()
        
        if NSFileManager.defaultManager().fileExistsAtPath(attemptedQuestionsFilePath) {
            attemptedQuestions = NSArray(contentsOfFile: attemptedQuestionsFilePath) as! Array
        }
        var modified = false
        if attemptedQuestions.count == 0 {
            attemptedQuestions.append(question)
            modified = true
        } else {
            if !attemptedQuestions.contains(question) {
                attemptedQuestions.append(question)
                modified = true
            }
        }
        if modified {
            (attemptedQuestions as NSArray).writeToFile(attemptedQuestionsFilePath, atomically: true)
        }
    }
    
    func attemptedQuestionsCountForCategory(categoryID: Int) -> Int {
        let attemptedQuestionsFilePath = DocumentPath.kDocumentsFolderPath + "/attempted_questions_for_\(categoryID).plist"
        
        var attemptedQuestions: [String]? = [""]
        
        if NSFileManager.defaultManager().fileExistsAtPath(attemptedQuestionsFilePath) {
            attemptedQuestions = NSArray(contentsOfFile: attemptedQuestionsFilePath) as? Array
            return attemptedQuestions!.count
        }
        
        return 0
    }
    
    func updateQuestionsCountForAllCategories() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let previousAppVersion = (defaults.objectForKey(Constants.kappVersion) as? String) ?? currentAppVersion
        
        var categoriesCount = 0
        
        if let count = defaults.objectForKey(Constants.ktotalCategoryCount) as? Int {
            categoriesCount = count
        }
        
        let categories = allQuizCategories()
        
        if (currentAppVersion != previousAppVersion) || categories.count != categoriesCount {
            
            for categoryDict in categories {
                let key = "questionsCount_" + "\(categoryDict[Constants.kquizCategoryId]!)"
                var catID = 1
                
                if let catDictIDString = categoryDict[Constants.kquizCategoryId] as? String {
                    if let id = Int(catDictIDString) {
                        catID = id
                    }
                }
                
                let questionsCount = questionsForCategoryID(catID).count
                
                //Store to UserDefaults
                defaults.setInteger(questionsCount, forKey: key)
                defaults.synchronize()
            }
            defaults.setInteger(categories.count, forKey: Constants.ktotalCategoryCount)
            defaults.synchronize()
        }
    }
    
    func questionsForCategoryID(categoryID: Int) -> CategoryArray {
        var questionsArray = CategoryArray()
        var quizFilePath = ""
        if useSourceDataFormat == QuizDataFormatType.JSONFormat {
            quizFilePath = pathForJSONDataFormatWithCategory(categoryID)
            if let questionData = NSData(contentsOfFile: quizFilePath) {
                questionsArray = parseJSONToQuestions(JSON(data: questionData, options: NSJSONReadingOptions.AllowFragments, error: nil), forKey: "Questions")
            }
        }

        //Shuffle Questions
        if AISettings.sharedInstance.isShuffleQuestionsEnabled == false {
            questionsArray = questionsArray.shuffle()
        }
        return questionsArray
    }
    
    //Utils
    private func parseJSONToQuestions(json: JSON, forKey: String) -> CategoryArray {
        var tempArray = CategoryArray()
        for result in json[forKey].arrayValue {
            if let parsedResult = result.dictionaryObject {
                tempArray.append(parsedResult)
            }
        }
        return tempArray
    }
    
    //File & Path Helper
    private func pathForJSONDataFormatWithCategory(categoryID: Int) -> String {
        return DocumentPath.kJSONQuizFolderSandboxPath + "/Quiz_Category_" + "\(categoryID)" + ".json"
    }
    
    func pathForPictureOrVideoName(fileName: String) -> String {
        var pictureFolderPath = ""
        
        pictureFolderPath = "\(DocumentPath.kPicturesFolderSandboxPath)" + "Quiz_Category_" + "\(currentQuizCategory.catID)" + "/" + fileName
        
        return pictureFolderPath
    }
    
    
    
    //MARK: - Reporting Game Data
    func dataForMultiplayer(categoryDict: NSDictionary, andQuestions questions: CategoryArray, pointsObtained points: Int64, forPlayerID playerID: String) -> NSData {

        let playerIDKey = "\(playerID)" + "_points"
        var appVersion = ""
        let infoDict = NSBundle.mainBundle().infoDictionary
        if let versionString = infoDict!["CFBundleVersion"] as? String {
            appVersion = versionString
        }
        let dataPack = ["category": currentCategoryDict, "Questions": questions, playerIDKey: NSNumber(longLong: points), "v": appVersion]
        
        let jsonData = try! JSON(dataPack).rawData()
        
        return jsonData
    }
    
    func dataDictionaryFromPreviousParticipantMatchData(data: NSData) -> [String: JSON] {

        let json = JSON(data: data, options: NSJSONReadingOptions(), error: nil)
        let quizDict = json.dictionaryValue
        return quizDict
    }
    
    func newDataForMatchData(data: NSData, withPoint points: Int64, forPlayerID playerID: String) -> NSData {
        let playerIDKey = "\(playerID)" + "_points"
        var json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
        var updateDict = json.dictionaryObject
        if var modDict = json.dictionaryObject {
            modDict[playerIDKey] = points as? AnyObject
            updateDict = modDict
        }
        
        let returnedData: NSData = NSKeyedArchiver.archivedDataWithRootObject(updateDict!)
        
        return returnedData
    }
    
}

