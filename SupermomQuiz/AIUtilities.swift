//
//  AIUtilities.swift
//  SuperMomQuiz
//
//  Created by Jakkrit S on 5/23/2558 BE.
//  Copyright (c) 2558 AppIllus. All rights reserved.
//

import UIKit

class AIUtilities {
    
    class func appScreenShot() -> UIImage? {
        if let keyWindow = UIApplication.sharedApplication().keyWindow {
            let windowsRect = keyWindow.bounds
            UIGraphicsBeginImageContextWithOptions(windowsRect.size, true, 0.0)
            let context = UIGraphicsGetCurrentContext()!
            keyWindow.layer.renderInContext(context)
            let captureScreen = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return captureScreen
        }
        return nil
    }
    
    class func getImageFromCategory(quizCategoryKey: String) -> UIImage {
        var imageFilePath = ""
        let quizManager = AIQuizDataManager.sharedInstance
        if quizManager.useSourceDataFormat == QuizDataFormatType.JSONFormat {
            imageFilePath = DocumentPath.kJSONQuizFolderSandboxPath + "/" + quizCategoryKey
        }

        guard let image = UIImage(contentsOfFile: imageFilePath) else {
            print("** No image found **")
            return UIImage(named: "placeholder")!
        }
        return image
    }
    
    class func getRootViewController() -> UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    class func presentViewController(viewController: UIViewController) {
        guard let rootVC = getRootViewController() else {
            print("Can't get root vc")
            return
        }
        rootVC.presentViewController(viewController, animated: true, completion: nil)
    }
    
    class func getVCPresentedByTopVC() -> UIViewController? {
        let navVC = UIApplication.sharedApplication().keyWindow?.rootViewController as! UINavigationController
        return navVC.topViewController?.presentedViewController
    }

}



















