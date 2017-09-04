//
//  ProductTableViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 10/2/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import UIKit
import Parse
import StoreKit

class ProductTableViewController: UITableViewController {
    
    var products: [SKProduct] = InAppHelper.sharedInstance.products {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var parseProducts: [PFProduct] = InAppHelper.sharedInstance.parseProducts {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // priceFormatter is used to show proper, localized currency
    lazy var priceFormatter: NSNumberFormatter = {
        let pf = NSNumberFormatter()
        pf.formatterBehavior = .Behavior10_4
        pf.numberStyle = .CurrencyStyle
        return pf
    }()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        //Add Notification Observers for Product Purchased/ Failed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "productPurchased:", name: IAP.ProductPurchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToLoadProducts:", name: IAP.ProductsFailedToLoadNotification, object: nil)
        
        super.viewDidLoad()
        //tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // Set up a refresh control, call reload to start things up
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "reload", forControlEvents: .ValueChanged)
        reload()
        refreshControl?.beginRefreshing()
        
        // Create a Restore Purchases button and hook it up to restoreTapped
        let restoreButton = UIBarButtonItem(title: "Restore", style: .Plain, target: self, action: "restoreTapped:")
        navigationItem.rightBarButtonItem = restoreButton
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.PurchaseCell, forIndexPath: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.row]
        cell.productTitle.text = product.localizedTitle
        cell.productDescription.text = product.localizedDescription
        cell.productPrice.text = "\(product.price)"
        
        for (var i = 0; i < parseProducts.count; i++) {
            if products[indexPath.row].productIdentifier == parseProducts[i].productIdentifier {
                if let imageFile = parseProducts[i].icon {
                    imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if error == nil {
                            cell.productImageView.image = UIImage(data: data!)
                        }
                    })
                }
            }
        }
        
        if InAppHelper.sharedInstance.isProductPurchased(product.productIdentifier) {
            cell.accessoryType = .Checkmark
            cell.accessoryView = nil
            cell.productPrice.text = "Installed"
            cell.productPrice.textColor = UIColor.grayColor()
        } else if InAppHelper.canMakePayments() {
            priceFormatter.locale = product.priceLocale
            cell.detailTextLabel?.text = priceFormatter.stringFromNumber(product.price)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 37))
            button.setTitleColor(view.tintColor, forState: .Normal)
            button.setTitle("Buy", forState: .Normal)
            button.tag = indexPath.row
            button.addTarget(self, action: "buyButtonTapped:", forControlEvents: .TouchUpInside)
            cell.accessoryType = .None
            cell.accessoryView = button
        }
        else {
            cell.accessoryType = .None
            cell.accessoryView = nil
            cell.detailTextLabel?.text = "Not available"
        }

        return cell
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    //MARK: - Helpers
    func reload() {
        tableView.reloadData()
        InAppHelper.sharedInstance.requestProductWithCompletionBlock { success, products in
            if success {
                self.products = products
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // Restore purchases to this device.
    func restoreTapped(sender: AnyObject) {
        appDelegate.showActivityIndicator()
        InAppHelper.sharedInstance.restoreCompletedTransactions()
    }
    
    //Buy Product
    func buyButtonTapped(sender: UIButton) {
        let product = products[sender.tag]
        InAppHelper.sharedInstance.buyProduct(product.productIdentifier)
    }
    
    //MARK: - Notifications
    func failedToLoadProducts(notification: NSNotification) {
        print(__FUNCTION__)
        let alert = UIAlertController(title: "Loading Products Failed", message: "Failed to load products, please try again later", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        if let mainVC = self.navigationController?.viewControllers.last {
            mainVC.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productPurchased(notification: NSNotification) {
        print(__FUNCTION__)
        self.tableView.reloadData()
        let removeAdsID = AISettings.sharedInstance.removeAdsProductIdentifier!
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: removeAdsID)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: Settings.kAdsTurnedOff)
        AISettings.sharedInstance.isAdsTurnedOff = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueID.InAppToChooseGameVCSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("INDEX PATH = \(indexPath)")
                let quizmanager = AIQuizDataManager.sharedInstance
                
                quizmanager.freeAndPurchasedQuizCategory
            }
        }
    }
}















