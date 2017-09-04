//
//  AIProducts.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/19/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation

//Managing Product IDs
public class AIProducts: NSObject {
    
    static let sharedInstance = AIProducts()
    
    //initialIDs
    var availableProductIDs = ProductIdentifiers()
    
    //MARK: - CHANGE DROPBOX LINK HERE
    private let productIDsURLString = "https://dl.dropboxusercontent.com/u/28654156/productIDs.json"
    
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getDownloaedProductIDsFromDisk:", name: "ProductIDsDownloaded", object: nil)
        
        if NSFileManager.defaultManager().fileExistsAtPath(DocumentPath.kPathForProductIDsJSON) {
            print("begin reading from disk")
            readingFromDisk()
        } else {
            print("begin download")
            let url = NSURL(string: productIDsURLString)!
            Downloader().download(url)
        }
        
        checkingForNewContent()
    }
    
    func getDownloaedProductIDsFromDisk(sender: NSNotification) {
        readingFromDisk()
    }
    
    func readingFromDisk() {
        let filePath = DocumentPath.kPathForProductIDsJSON
        if let data = NSData(contentsOfFile: filePath) {
            let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            if let jsonArray = json["productIDs"].arrayObject as? [String] {
                for id in jsonArray {
                    availableProductIDs.insert(id)
                }
            }
            
        }
    }
    
    func checkingForNewContent() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) { () -> Void in
            let url = NSURL(string: self.productIDsURLString)!
            Downloader().download(url)
        }
    }
    
}
