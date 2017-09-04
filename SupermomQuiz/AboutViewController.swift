//
//  AboutViewController.swift
//  SupermomQuiz
//
//  Created by JakkritS on 11/7/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.showActivityIndicator()
        
        let configuration = WKWebViewConfiguration()
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        configuration.preferences = preference
        webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        let url = NSURL(string: "http://appillustrator.com/supermomquiz")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        appDelegate.hideActivityIndicator()
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow)
    }
}