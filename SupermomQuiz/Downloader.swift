//
//  DownloadHelper.swift
//  ParsePurchase
//
//  Created by Jakkrits on 11/19/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation
class Downloader : NSObject, NSURLSessionDownloadDelegate
{
    var url : NSURL?
    
    override init()
    {
        super.init()
    }
    
    //called once download completes
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(url!.lastPathComponent!)
        
        print("DESTINATION = \(destinationUrl)")
        print("LOCATION" + destinationUrl.absoluteString)
        if let dataFromURL = NSData(contentsOfURL: location) {
        dataFromURL.writeToURL(destinationUrl, atomically: true)
        NSNotificationCenter.defaultCenter().postNotificationName("ProductIDsDownloaded", object: nil)
        }
    }
    
    //this is to track progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
    }
    
    // if there is an error during download this will be called
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        if(error != nil)
        {
            //handle the error
            print("Download completed with error: \(error!.localizedDescription)");
        }
    }
    
    //method to be called to download
    func download(url: NSURL)
    {
        self.url = url
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url.absoluteString)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url)
        task.resume()
    }
}
