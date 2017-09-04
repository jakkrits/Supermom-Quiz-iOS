//
//  InAppHelper.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 9/30/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import StoreKit
import Parse
import SSZipArchive

public typealias RequestProductsCompletionHandler = (success: Bool, products: [SKProduct]) -> ()

public class InAppHelper: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //Available & Purchased Product IDs
    private let productIdentifiers: ProductIdentifiers
    private var purchasedProductIdentifiers = ProductIdentifiers()
    
    // Used by SKProductsRequestDelegate
    private var productsRequest: SKProductsRequest?
    private var completionHandler: RequestProductsCompletionHandler?
    
    public var products = [SKProduct]()
    public var parseProducts = [PFProduct]()
    
    static let sharedInstance = InAppHelper()
    
    override init() {
        AISettings.sharedInstance
        productIdentifiers = AIProducts.sharedInstance.availableProductIDs
        
        for productIdentifier in productIdentifiers {
            let purchased = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            }
            else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        getProductsDetailFromParse()
    }
    
    /// Gets the list of SKProducts from the Apple server calls the handler with the list of products.
    public func requestProductWithCompletionBlock(handler: RequestProductsCompletionHandler) {
        completionHandler = handler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        
        productsRequest?.delegate = self
        productsRequest?.start()
        print("Product Request sent with product identifiers: \(productIdentifiers)")
    }
    
    
    func loadProducts() {
        appDelegate.showActivityIndicator()
        if self.products.count == 0 {
            InAppHelper.sharedInstance.requestProductWithCompletionBlock { (success, products) -> Void in
                self.appDelegate.hideActivityIndicator()
                if success {
                    self.products = products
                    NSNotificationCenter.defaultCenter().postNotificationName(IAP.ProductsLoadedNotification, object: nil, userInfo: nil)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(IAP.ProductsFailedToLoadNotification, object: nil, userInfo: nil)
                }
            }
        } else {
            
            NSNotificationCenter.defaultCenter().postNotificationName(IAP.ProductsLoadedNotification, object: nil, userInfo: nil)
        }
        
    }
    
    /// Initiates purchase of a product on Apple server.
    public func purchaseProduct(product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func isProductPurchased(productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    
    func hasProduct(productIdentifier:String) -> Bool {
        for product in self.products {
            if product.productIdentifier == productIdentifier {
                if NSUserDefaults.standardUserDefaults().valueForKey(productIdentifier) == nil {
                    return true
                }
                print("purchased productIdentifier: \(productIdentifier)")
                return false
            }
        }
        print("ProductID: \(productIdentifier) might be wrong")
        return false
    }
    
    public func restoreCompletedTransactions() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    
}

//MARK: - Extension - SKProductsRequestDelegate
extension InAppHelper: SKProductsRequestDelegate {
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        completionHandler?(success: true, products: products)
        clearRequest()
        
        // debug printing
        for p in products {
            print("Found product: \(p.productIdentifier) - \(p.localizedTitle) - USD\(p.price.floatValue)")
        }
    }
    
    public func request(request: SKRequest, didFailWithError error: NSError) {
        print("Failed to load list of products.")
        print("Error: \(error)")
        clearRequest()
    }
    
    private func clearRequest() {
        productsRequest = nil
        completionHandler = nil
    }
    
    public func requestDidFinish(request: SKRequest) {
        ColorLog.blue("Products Request Finished")
    }
}

//MARK: - Extension - SKPaymentTransactionObserver
extension InAppHelper: SKPaymentTransactionObserver {
    //MARK: - SKPaymentTransactionObserver
    public func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print(__FUNCTION__)
    }
    
    public func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        print(__FUNCTION__)
    }
    
    public
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                completeTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                failedTransaction(transaction)
            case SKPaymentTransactionState.Restored:
                restoreTransaction(transaction)
            case SKPaymentTransactionState.Deferred:
                break
            case SKPaymentTransactionState.Purchasing:
                break
            }
        }
        
    }
    public
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print(__FUNCTION__)
        appDelegate.hideActivityIndicator()
    }
    public
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print(__FUNCTION__)
        appDelegate.hideActivityIndicator()
    }
    
    //MARK: - SKPaymentTransactionObserver Supplements
    private func completeTransaction(transaction: SKPaymentTransaction) {
        appDelegate.hideActivityIndicator()
        self.provideContentForProductIdentifier(transaction.payment.productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        appDelegate.hideActivityIndicator()
        print("failedTransaction...")
        if transaction.error!.code != SKErrorPaymentCancelled {
            
            let alert = UIAlertController(title: "Error", message: "Error occured, please try again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.appDelegate.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            print("Transaction error: \(transaction.error!.localizedDescription)")
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        appDelegate.hideActivityIndicator()
        let productIdentifier = transaction.originalTransaction!.payment.productIdentifier
        print("restoreTransaction... \(productIdentifier)")
        provideContentForProductIdentifier(productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func provideContentForProductIdentifier(productIdentifier: String) {
        purchasedProductIdentifiers.insert(productIdentifier)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: productIdentifier)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(IAP.ProductPurchasedNotification, object: productIdentifier)
    }
    
}

//MARK: - Parse
extension InAppHelper {
    
    func getProductsDetailFromParse() {
        
        //CHECK AVAILABLE PRODUCTS ON PARSE
        var parseProductIDs = ProductIdentifiers()
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_DEFAULT.rawValue), 0), { () -> Void in
            let parseProductsQuery = PFProduct.query()
            if let fetched = try! parseProductsQuery?.findObjects() as? [PFProduct] {
                self.parseProducts = fetched
            }
            for id in self.parseProducts {
                parseProductIDs.insert(id.productIdentifier!)
            }
            if parseProductIDs.count != self.productIdentifiers.count {
                print("Products on StoreKit not equal to Parse products")
                print("Products on StoreKit = \(self.productIdentifiers) Products on Parse = \(parseProductIDs)")
            }
        })
        
        for id in self.productIdentifiers {
            PFPurchase.addObserverForProduct(id, block: { (transaction: SKPaymentTransaction?) -> Void in
                
                if let transaction = transaction {
                    //MARK: - Download Content Path
                    PFPurchase.downloadAssetForTransaction(transaction, completion: { (filePath: String?, error: NSError?) -> Void in
                        if error == nil {
                            let unzipPath = self.tempUnzipPath()
                            var mediaResources = [String]()
                            var newquestion = CategoryArray()
                            var catID: String = ""
                            var newQuestionJSONFile = ""
                            var newJSONHeaderData: NSData?
                            SSZipArchive.unzipFileAtPath(filePath, toDestination: unzipPath, progressHandler: { (unzippedFile, unzipFileInfo, int1, int2) -> Void in
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.showActivityIndicator()
                               let myurl = NSURL(fileURLWithPath: filePath!).URLByDeletingPathExtension!
                                
                                //Get .json file to extract catID for naming folder
                                let file = unzipPath! + "/" + unzippedFile
                                if file.containsString("header.json") && !file.containsString("__MACOSX") {
                                    guard let data = NSData(contentsOfFile: file) else {
                                        print("NIL DATA \(file)")
                                        return
                                    }
                                    catID = self.parseJSONToCategoryID(JSON(data: data), forKey: "Categories")
                                    newJSONHeaderData = data
                                    //self.savingQuizJSONData(data)
                                    
                                } else if file.containsString("question.json") && !file.containsString("__MACOSX") {
                                        guard let data = NSData(contentsOfFile: file) else {
                                        print("NIL DATA \(file)")
                                        return
                                    }
                                    
                                    newQuestionJSONFile = file
                                    newquestion = self.parseJSONToQuestions(JSON(data: data), forKey: "Questions")
                                    
                                } else if (file.containsString(".mp4") || file.containsString(".jpg") || file.containsString(".png")) && !file.containsString("__MACOSX") {
                                    mediaResources.append(file)
                                }
                                }, completionHandler: { (originalZipFile, success, error) -> Void in
                                    if success {
                                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        appDelegate.hideActivityIndicator()
                                        print("Successfully unzip file: \(originalZipFile)")
                                        
                                        let newJSONPath = DocumentPath.kJSONQuizFolderSandboxPath + "/Quiz_Category_" + catID + ".json"
                                        //put them in coorect places
                                        //1. make file name quiz_category_x.json in json_format folder
                                        let fileManager = NSFileManager.defaultManager()
                                        do {
                                            try fileManager.moveItemAtPath(newQuestionJSONFile, toPath: newJSONPath)
                                            print("Moved JSON Question file successfully")
                                        } catch let error as NSError {
                                            print(error.localizedDescription)
                                        }
                                        
                                        //2.move media assets to correct folder
                                        let newFolderForNewMedia = DocumentPath.kPicturesFolderSandboxPath + "Quiz_Category_" + catID
                                        do {
                                            try fileManager.createDirectoryAtPath(newFolderForNewMedia, withIntermediateDirectories: true, attributes: nil)
                                            
                                        } catch let error as NSError {
                                            print("Error creating folder \(error.localizedDescription)")
                                        }
                                        
                                        for mediaFile in mediaResources {
                                            let url = NSURL(string: mediaFile)!
                                            
                                            let destinationMediaPath = newFolderForNewMedia + "/" + url.lastPathComponent!
                                            
                                                //Copy image icon file to sandbox \Quiz Data\JSON_Format root
                                                //Get the folder icon name, the one that same as folder's name
                                                let getURL = NSURL(fileURLWithPath: mediaFile)
                                                let urlWithoutExt = getURL.URLByDeletingPathExtension!.lastPathComponent!
                                                for component in getURL.pathComponents! {
                                                    if component == urlWithoutExt {
                                                        //This is the icon file
                                                        //Move to JSON_Format Folder
                                                       let destinationJSON_Format = DocumentPath.kJSONQuizFolderSandboxPath + "/" + getURL.lastPathComponent!
                                                        print("++++++++++++++\(destinationJSON_Format)++++++++++++++++++ \(mediaFile)")
                                                       
                                                        do {
                                                        try fileManager.copyItemAtPath(mediaFile, toPath: destinationJSON_Format)
                                                        } catch let error as NSError {
                                                            print(error.localizedDescription)
                                                        }

                                                    } else {
                                                        //These are something else
                                                        //Move to media folders
                                                        do {
                                                            
                                                            
                                                            try fileManager.copyItemAtPath(mediaFile, toPath: destinationMediaPath)
                                                        } catch let error as NSError {
                                                            print("+++++++ EVERYTHINGELSE.JPG +++++++")

                                                            print(error.localizedDescription)
                                                        }
                                                    }
                                                }

                                        }
                                        
                                        
                                        //3. append quizcategories.json
                                        guard let data = newJSONHeaderData  else {
                                            print("NO JSON DATA READ \(__FUNCTION__)")
                                            return
                                        }
                                        self.appendingQuizJSONData(data)
                                        
                                        //4. TESTING FILES READING
                                        self.testReading()
                                    }
                                    
                                    if error != nil {
                                        print("Error unzipping files: \(error.localizedDescription)")
                                    }
                            })
                            
                        }
                        }, progress: { (progressNumber) -> Void in
                            if progressNumber == 100 {
                                self.appDelegate.hideActivityIndicator()
                            }
                    })
                }
            })
        }
    }
    
    func buyProduct(productID: String) {
        //BUY ON PARSE.COM
        appDelegate.showActivityIndicator()
        PFPurchase.buyProduct(productID, block: { (error) -> Void in
            if error == nil {
                //Buying product code
            }
        })
    }
    
}

//Zip/Unzip File Manager
extension InAppHelper {
    
    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    func parseJSONToCategoryID(json: JSON, forKey: String) -> String {
        var category_id = ""
        for result in json[forKey].arrayValue {
            category_id = result[Constants.kquizCategoryId].stringValue
        }
        return category_id
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
    
    func parseJSONToQuestions(json: JSON, forKey: String) -> CategoryArray {
        var tempArray = CategoryArray()
        for result in json[forKey].arrayValue {
            if let parsedResult = result.dictionaryObject {
                tempArray.append(parsedResult)
            }
        }
        return tempArray
    }
    
    func appendingQuizJSONData(data: NSData) {
        let orignalJsonPath = DocumentPath.kQuizCatJSONSandboxFilePath
        let originalData = NSData(contentsOfFile: orignalJsonPath)
        let originalJson = JSON(data: originalData!)
        
        let newHeaderJson = JSON(data: data)
        
        let appendJson = originalJson["Categories"].arrayValue + newHeaderJson["Categories"].arrayValue
        
        let json = JSON(appendJson)
        let newJsonForKeyCategories = JSON(["Categories": json])
        
        //Write to original file
        do {
            try newJsonForKeyCategories.rawData(options: .PrettyPrinted).writeToFile(orignalJsonPath, atomically: true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        //Set Purchased to true
        provideContentForProductIdentifier(newHeaderJson["Categories"][0]["productIdentifier"].stringValue)
        
    }
    
    func savingQuizResources(file: String) {
    }
    
    func testReading() {
        
    }
    
}