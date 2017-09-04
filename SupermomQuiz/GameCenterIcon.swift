//
//  GameCenterIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/3/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class GameCenterIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var topFillColor : UIColor!
    var topRightFillColor : UIColor!
    var mainFillColor : UIColor!
    var bottomFillColor : UIColor!
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    override var frame: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func setupProperties(){
        self.topFillColor       = ThemeColor.GameCenterPurple
        self.topRightFillColor  = ThemeColor.GameCenterBlue
        self.mainFillColor      = ThemeColor.GameCenterPink
        self.bottomFillColor    = ThemeColor.GameCenterGreen
    }
    
    func setupLayers(){
        let path = CAShapeLayer()
        self.layer.addSublayer(path)
        layers["path"] = path
        
        let path2 = CAShapeLayer()
        self.layer.addSublayer(path2)
        layers["path2"] = path2
        
        let path3 = CAShapeLayer()
        self.layer.addSublayer(path3)
        layers["path3"] = path3
        
        let path4 = CAShapeLayer()
        self.layer.addSublayer(path4)
        layers["path4"] = path4
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("path"){
            let path = layers["path"] as! CAShapeLayer
            path.fillColor = self.topFillColor.CGColor
            path.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path2"){
            let path2 = layers["path2"] as! CAShapeLayer
            path2.fillColor = self.topRightFillColor.CGColor
            path2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path3"){
            let path3 = layers["path3"] as! CAShapeLayer
            path3.fillColor = self.mainFillColor.CGColor
            path3.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path4"){
            let path4 = layers["path4"] as! CAShapeLayer
            path4.fillColor = self.bottomFillColor.CGColor
            path4.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
            path.frame = CGRectMake(0.14726 * path.superlayer!.bounds.width, 0.19348 * path.superlayer!.bounds.height, 0.29286 * path.superlayer!.bounds.width, 0.28836 * path.superlayer!.bounds.height)
            path.path  = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
            path2.frame = CGRectMake(0.51842 * path2.superlayer!.bounds.width, 0.14936 * path2.superlayer!.bounds.height, 0.15925 * path2.superlayer!.bounds.width, 0.15925 * path2.superlayer!.bounds.height)
            path2.path  = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
            path3.frame = CGRectMake(0.14726 * path3.superlayer!.bounds.width, 0.29145 * path3.superlayer!.bounds.height, 0.70547 * path3.superlayer!.bounds.width, 0.55919 * path3.superlayer!.bounds.height)
            path3.path  = path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path4 : CAShapeLayer = layers["path4"] as? CAShapeLayer{
            path4.frame = CGRectMake(0.43518 * path4.superlayer!.bounds.width, 0.58375 * path4.superlayer!.bounds.height, 0.28457 * path4.superlayer!.bounds.width, 0.22235 * path4.superlayer!.bounds.height)
            path4.path  = path4PathWithBounds((layers["path4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        CATransaction.commit()
    }
    
    
    
    //MARK: - Animation Cleanup
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValueForKey(anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.valueForKey("needEndAnim") as! Bool{
                updateLayerValuesForAnimationId(anim.valueForKey("animId") as! String)
                removeAnimationsForAnimationId(anim.valueForKey("animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValuesForAnimationId(identifier: String){
        
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func pathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let pathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        pathPath.moveToPoint(CGPointMake(minX + 0.00008 * w, minY + 0.5001 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.36873 * w, minY + h), controlPoint1:CGPointMake(minX + -0.00401 * w, minY + 0.73771 * h), controlPoint2:CGPointMake(minX + 0.15291 * w, minY + 0.94013 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.42482 * w, minY + 0.88268 * h), controlPoint1:CGPointMake(minX + 0.3845 * w, minY + 0.95971 * h), controlPoint2:CGPointMake(minX + 0.4032 * w, minY + 0.92054 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.65519 * w, minY + 0.61923 * h), controlPoint1:CGPointMake(minX + 0.4835 * w, minY + 0.77989 * h), controlPoint2:CGPointMake(minX + 0.561 * w, minY + 0.69125 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.90794 * w, minY + 0.48498 * h), controlPoint1:CGPointMake(minX + 0.73215 * w, minY + 0.56041 * h), controlPoint2:CGPointMake(minX + 0.81719 * w, minY + 0.51524 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.45991 * h), controlPoint1:CGPointMake(minX + 0.93821 * w, minY + 0.47488 * h), controlPoint2:CGPointMake(minX + 0.96894 * w, minY + 0.46655 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.50992 * w, minY + 0.00008 * h), controlPoint1:CGPointMake(minX + 0.97605 * w, minY + 0.20562 * h), controlPoint2:CGPointMake(minX + 0.76738 * w, minY + 0.00465 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.00008 * w, minY + 0.5001 * h), controlPoint1:CGPointMake(minX + 0.23318 * w, minY + -0.00483 * h), controlPoint2:CGPointMake(minX + 0.00492 * w, minY + 0.21903 * h))
        pathPath.closePath()
        pathPath.moveToPoint(CGPointMake(minX + 0.00008 * w, minY + 0.5001 * h))
        
        return pathPath;
    }
    
    func path2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path2Path.moveToPoint(CGPointMake(minX + w, minY + 0.5 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77614 * w, minY + h))
        path2Path.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.22386 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77614 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22386 * h), controlPoint2:CGPointMake(minX + 0.22386 * w, minY))
        path2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77614 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + w, minY + 0.5 * h))
        
        return path2Path;
    }
    
    func path3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path3Path.moveToPoint(CGPointMake(minX + 0.92442 * w, minY))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.82336 * w, minY + 0.03358 * h), controlPoint1:CGPointMake(minX + 0.8906 * w, minY + -0 * h), controlPoint2:CGPointMake(minX + 0.8528 * w, minY + 0.01713 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.80509 * w, minY + 0.09777 * h), controlPoint1:CGPointMake(minX + 0.80386 * w, minY + 0.04448 * h), controlPoint2:CGPointMake(minX + 0.79555 * w, minY + 0.07372 * h))
        path3Path.addLineToPoint(CGPointMake(minX + 0.80786 * w, minY + 0.10476 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.8413 * w, minY + 0.13084 * h), controlPoint1:CGPointMake(minX + 0.81437 * w, minY + 0.1212 * h), controlPoint2:CGPointMake(minX + 0.82755 * w, minY + 0.13084 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.856 * w, minY + 0.12702 * h), controlPoint1:CGPointMake(minX + 0.84622 * w, minY + 0.13084 * h), controlPoint2:CGPointMake(minX + 0.85121 * w, minY + 0.12961 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.92246 * w, minY + 0.10314 * h), controlPoint1:CGPointMake(minX + 0.89379 * w, minY + 0.10656 * h), controlPoint2:CGPointMake(minX + 0.91351 * w, minY + 0.10314 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.92495 * w, minY + 0.10324 * h), controlPoint1:CGPointMake(minX + 0.92341 * w, minY + 0.10314 * h), controlPoint2:CGPointMake(minX + 0.92424 * w, minY + 0.10318 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.78744 * w, minY + 0.31999 * h), controlPoint1:CGPointMake(minX + 0.92982 * w, minY + 0.13162 * h), controlPoint2:CGPointMake(minX + 0.85969 * w, minY + 0.25389 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.75775 * w, minY + 0.25972 * h), controlPoint1:CGPointMake(minX + 0.77906 * w, minY + 0.29919 * h), controlPoint2:CGPointMake(minX + 0.76925 * w, minY + 0.27901 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.50237 * w, minY + 0.09911 * h), controlPoint1:CGPointMake(minX + 0.69499 * w, minY + 0.15454 * h), controlPoint2:CGPointMake(minX + 0.59926 * w, minY + 0.09912 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.42723 * w, minY + 0.11041 * h), controlPoint1:CGPointMake(minX + 0.47721 * w, minY + 0.09911 * h), controlPoint2:CGPointMake(minX + 0.45198 * w, minY + 0.10285 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.31058 * w, minY + 0.1801 * h), controlPoint1:CGPointMake(minX + 0.38619 * w, minY + 0.12296 * h), controlPoint2:CGPointMake(minX + 0.34647 * w, minY + 0.14603 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.20962 * w, minY + 0.34169 * h), controlPoint1:CGPointMake(minX + 0.26476 * w, minY + 0.22362 * h), controlPoint2:CGPointMake(minX + 0.23087 * w, minY + 0.27971 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.24748 * w, minY + 0.7442 * h), controlPoint1:CGPointMake(minX + 0.16553 * w, minY + 0.47028 * h), controlPoint2:CGPointMake(minX + 0.17592 * w, minY + 0.62426 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.28558 * w, minY + 0.79737 * h), controlPoint1:CGPointMake(minX + 0.25911 * w, minY + 0.76367 * h), controlPoint2:CGPointMake(minX + 0.2719 * w, minY + 0.78133 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.08235 * w, minY + 0.90546 * h), controlPoint1:CGPointMake(minX + 0.19781 * w, minY + 0.88017 * h), controlPoint2:CGPointMake(minX + 0.1148 * w, minY + 0.90333 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.1172 * w, minY + 0.82991 * h), controlPoint1:CGPointMake(minX + 0.0838 * w, minY + 0.89667 * h), controlPoint2:CGPointMake(minX + 0.08987 * w, minY + 0.87316 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.11317 * w, minY + 0.76564 * h), controlPoint1:CGPointMake(minX + 0.12948 * w, minY + 0.81048 * h), controlPoint2:CGPointMake(minX + 0.12773 * w, minY + 0.78238 * h))
        path3Path.addLineToPoint(CGPointMake(minX + 0.10856 * w, minY + 0.76034 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.08336 * w, minY + 0.74801 * h), controlPoint1:CGPointMake(minX + 0.10137 * w, minY + 0.75207 * h), controlPoint2:CGPointMake(minX + 0.09234 * w, minY + 0.74801 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.05458 * w, minY + 0.76513 * h), controlPoint1:CGPointMake(minX + 0.07263 * w, minY + 0.74801 * h), controlPoint2:CGPointMake(minX + 0.06196 * w, minY + 0.75381 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.01585 * w, minY + 0.96586 * h), controlPoint1:CGPointMake(minX + 0.01918 * w, minY + 0.81942 * h), controlPoint2:CGPointMake(minX + -0.02379 * w, minY + 0.90383 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.08543 * w, minY + h), controlPoint1:CGPointMake(minX + 0.03086 * w, minY + 0.98934 * h), controlPoint2:CGPointMake(minX + 0.05481 * w, minY + h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.99064 * w, minY + 0.04021 * h), controlPoint1:CGPointMake(minX + 0.34572 * w, minY + h), controlPoint2:CGPointMake(minX + 1.09176 * w, minY + 0.232 * h))
        path3Path.addCurveToPoint(CGPointMake(minX + 0.92442 * w, minY), controlPoint1:CGPointMake(minX + 0.975 * w, minY + 0.01054 * h), controlPoint2:CGPointMake(minX + 0.95094 * w, minY))
        path3Path.closePath()
        path3Path.moveToPoint(CGPointMake(minX + 0.92442 * w, minY))
        
        return path3Path;
    }
    
    func path4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path4Path.moveToPoint(CGPointMake(minX + 0.6845 * w, minY + 0.79631 * h))
        path4Path.addCurveToPoint(CGPointMake(minX + w, minY), controlPoint1:CGPointMake(minX + 0.88815 * w, minY + 0.60019 * h), controlPoint2:CGPointMake(minX + 0.99676 * w, minY + 0.30262 * h))
        path4Path.addCurveToPoint(CGPointMake(minX + 0.50902 * w, minY + 0.5165 * h), controlPoint1:CGPointMake(minX + 0.8593 * w, minY + 0.16039 * h), controlPoint2:CGPointMake(minX + 0.69231 * w, minY + 0.33994 * h))
        path4Path.addCurveToPoint(CGPointMake(minX, minY + 0.96411 * h), controlPoint1:CGPointMake(minX + 0.32855 * w, minY + 0.69049 * h), controlPoint2:CGPointMake(minX + 0.15274 * w, minY + 0.84114 * h))
        path4Path.addCurveToPoint(CGPointMake(minX + 0.6845 * w, minY + 0.79631 * h), controlPoint1:CGPointMake(minX + 0.22798 * w, minY + 1.04365 * h), controlPoint2:CGPointMake(minX + 0.48117 * w, minY + 0.99237 * h))
        path4Path.closePath()
        path4Path.moveToPoint(CGPointMake(minX + 0.6845 * w, minY + 0.79631 * h))
        
        return path4Path;
    }
    
    
}

