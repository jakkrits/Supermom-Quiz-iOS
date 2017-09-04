//
//  MultiplayerIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/12/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//


import UIKit

@IBDesignable
class MultiplayerIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = true
    
    var startColor : UIColor!
    var stopColor : UIColor!
    var fillColor : UIColor!
    
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
        self.startColor = UIColor.whiteColor()
        self.stopColor = UIColor(red:1, green: 0.408, blue:0.404, alpha:1)
        self.fillColor = ThemeColor.IconColor
    }
    
    func setupLayers(){
        let multiplayerIcon = CALayer()
        self.layer.addSublayer(multiplayerIcon)
        
        layers["multiplayerIcon"] = multiplayerIcon
        let headPath = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath)
        headPath.fillColor = self.fillColor.CGColor
        headPath.lineWidth = 0
        layers["headPath"] = headPath
        let headPath2 = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath2)
        headPath2.fillColor = self.fillColor.CGColor
        headPath2.lineWidth = 0
        layers["headPath2"] = headPath2
        let headPath3 = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath3)
        headPath3.fillColor = self.fillColor.CGColor
        headPath3.lineWidth = 0
        layers["headPath3"] = headPath3
        let headPath4 = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath4)
        headPath4.fillColor = self.fillColor.CGColor
        headPath4.lineWidth = 0
        layers["headPath4"] = headPath4
        let headPath5 = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath5)
        headPath5.fillColor = self.fillColor.CGColor
        headPath5.lineWidth = 0
        layers["headPath5"] = headPath5
        let headPath6 = CAShapeLayer()
        multiplayerIcon.addSublayer(headPath6)
        headPath6.fillColor = self.fillColor.CGColor
        headPath6.lineWidth = 0
        layers["headPath6"] = headPath6
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let multiplayerIcon : CALayer = layers["multiplayerIcon"] as? CALayer{
            multiplayerIcon.frame = CGRectMake(0.06348 * multiplayerIcon.superlayer!.bounds.width, 0.14801 * multiplayerIcon.superlayer!.bounds.height, 0.87304 * multiplayerIcon.superlayer!.bounds.width, 0.70399 * multiplayerIcon.superlayer!.bounds.height)
        }
        
        if let headPath : CAShapeLayer = layers["headPath"] as? CAShapeLayer{
            headPath.frame = CGRectMake(0.1296 * headPath.superlayer!.bounds.width, 0.58296 * headPath.superlayer!.bounds.height, 0.74079 * headPath.superlayer!.bounds.width, 0.41704 * headPath.superlayer!.bounds.height)
            headPath.path  = headPathPathWithBounds((layers["headPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let headPath2 : CAShapeLayer = layers["headPath2"] as? CAShapeLayer{
            headPath2.frame = CGRectMake(0.30295 * headPath2.superlayer!.bounds.width, 0.08075 * headPath2.superlayer!.bounds.height, 0.39377 * headPath2.superlayer!.bounds.width, 0.59613 * headPath2.superlayer!.bounds.height)
            headPath2.path  = headPath2PathWithBounds((layers["headPath2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let headPath3 : CAShapeLayer = layers["headPath3"] as? CAShapeLayer{
            headPath3.frame = CGRectMake(0.77206 * headPath3.superlayer!.bounds.width, 0.44088 * headPath3.superlayer!.bounds.height, 0.22794 * headPath3.superlayer!.bounds.width, 0.28909 * headPath3.superlayer!.bounds.height)
            headPath3.path  = headPath3PathWithBounds((layers["headPath3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let headPath4 : CAShapeLayer = layers["headPath4"] as? CAShapeLayer{
            headPath4.frame = CGRectMake(0.64862 * headPath4.superlayer!.bounds.width, 0, 0.19886 * headPath4.superlayer!.bounds.width, 0.44792 * headPath4.superlayer!.bounds.height)
            headPath4.path  = headPath4PathWithBounds((layers["headPath4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let headPath5 : CAShapeLayer = layers["headPath5"] as? CAShapeLayer{
            headPath5.frame = CGRectMake(0, 0.44091 * headPath5.superlayer!.bounds.height, 0.22794 * headPath5.superlayer!.bounds.width, 0.28906 * headPath5.superlayer!.bounds.height)
            headPath5.path  = headPath5PathWithBounds((layers["headPath5"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let headPath6 : CAShapeLayer = layers["headPath6"] as? CAShapeLayer{
            headPath6.frame = CGRectMake(0.15255 * headPath6.superlayer!.bounds.width, 0, 0.19886 * headPath6.superlayer!.bounds.width, 0.44792 * headPath6.superlayer!.bounds.height)
            headPath6.path  = headPath6PathWithBounds((layers["headPath6"] as! CAShapeLayer).bounds).CGPath;
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
    
    func headPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPathPath.moveToPoint(CGPointMake(minX + 0.86453 * w, minY + h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.13554 * w, minY + h))
        headPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.70142 * h), controlPoint1:CGPointMake(minX + 0.06077 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.86612 * h))
        headPathPath.addLineToPoint(CGPointMake(minX, minY + 0.60258 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.25962 * w, minY + 0.00173 * h), controlPoint1:CGPointMake(minX, minY + 0.28147 * h), controlPoint2:CGPointMake(minX + 0.11403 * w, minY + 0.01755 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.27604 * w, minY))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.28602 * w, minY + 0.02878 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.49974 * w, minY + 0.27876 * h), controlPoint1:CGPointMake(minX + 0.34098 * w, minY + 0.1876 * h), controlPoint2:CGPointMake(minX + 0.41889 * w, minY + 0.27876 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.71353 * w, minY + 0.02878 * h), controlPoint1:CGPointMake(minX + 0.58056 * w, minY + 0.27876 * h), controlPoint2:CGPointMake(minX + 0.6585 * w, minY + 0.1876 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.72345 * w, minY + 0.00008 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.73983 * w, minY + 0.00173 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.60258 * h), controlPoint1:CGPointMake(minX + 0.88573 * w, minY + 0.0168 * h), controlPoint2:CGPointMake(minX + w, minY + 0.28072 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.70142 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.86453 * w, minY + h), controlPoint1:CGPointMake(minX + 1.00007 * w, minY + 0.86612 * h), controlPoint2:CGPointMake(minX + 0.93926 * w, minY + h))
        headPathPath.closePath()
        headPathPath.moveToPoint(CGPointMake(minX + 0.24717 * w, minY + 0.14232 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.06255 * w, minY + 0.60258 * h), controlPoint1:CGPointMake(minX + 0.14245 * w, minY + 0.17065 * h), controlPoint2:CGPointMake(minX + 0.06255 * w, minY + 0.36661 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.06255 * w, minY + 0.70142 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.13557 * w, minY + 0.86228 * h), controlPoint1:CGPointMake(minX + 0.06255 * w, minY + 0.7901 * h), controlPoint2:CGPointMake(minX + 0.09532 * w, minY + 0.86228 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.86453 * w, minY + 0.86228 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.93755 * w, minY + 0.70142 * h), controlPoint1:CGPointMake(minX + 0.90478 * w, minY + 0.86228 * h), controlPoint2:CGPointMake(minX + 0.93755 * w, minY + 0.7901 * h))
        headPathPath.addLineToPoint(CGPointMake(minX + 0.93755 * w, minY + 0.60258 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.75245 * w, minY + 0.14224 * h), controlPoint1:CGPointMake(minX + 0.93755 * w, minY + 0.36601 * h), controlPoint2:CGPointMake(minX + 0.85742 * w, minY + 0.17004 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.49978 * w, minY + 0.41656 * h), controlPoint1:CGPointMake(minX + 0.68617 * w, minY + 0.31703 * h), controlPoint2:CGPointMake(minX + 0.59499 * w, minY + 0.41656 * h))
        headPathPath.addCurveToPoint(CGPointMake(minX + 0.24717 * w, minY + 0.14232 * h), controlPoint1:CGPointMake(minX + 0.40456 * w, minY + 0.41656 * h), controlPoint2:CGPointMake(minX + 0.31338 * w, minY + 0.31711 * h))
        headPathPath.closePath()
        headPathPath.moveToPoint(CGPointMake(minX + 0.24717 * w, minY + 0.14232 * h))
        
        return headPathPath;
    }
    
    func headPath2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPath2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPath2Path.moveToPoint(CGPointMake(minX + 0.5 * w, minY + h))
        headPath2Path.addCurveToPoint(CGPointMake(minX, minY + 0.50003 * h), controlPoint1:CGPointMake(minX + 0.2243 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77568 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22432 * h), controlPoint2:CGPointMake(minX + 0.22423 * w, minY))
        headPath2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.50003 * h), controlPoint1:CGPointMake(minX + 0.77577 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22432 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + 0.99994 * w, minY + 0.77568 * h), controlPoint2:CGPointMake(minX + 0.7757 * w, minY + h))
        headPath2Path.closePath()
        headPath2Path.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.09629 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.11768 * w, minY + 0.49997 * h), controlPoint1:CGPointMake(minX + 0.28922 * w, minY + 0.09629 * h), controlPoint2:CGPointMake(minX + 0.11768 * w, minY + 0.27739 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.9036 * h), controlPoint1:CGPointMake(minX + 0.11768 * w, minY + 0.72255 * h), controlPoint2:CGPointMake(minX + 0.28922 * w, minY + 0.9036 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.88232 * w, minY + 0.49997 * h), controlPoint1:CGPointMake(minX + 0.71078 * w, minY + 0.9036 * h), controlPoint2:CGPointMake(minX + 0.88232 * w, minY + 0.7225 * h))
        headPath2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.09629 * h), controlPoint1:CGPointMake(minX + 0.88232 * w, minY + 0.27739 * h), controlPoint2:CGPointMake(minX + 0.71078 * w, minY + 0.09629 * h))
        headPath2Path.closePath()
        headPath2Path.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.09629 * h))
        
        return headPath2Path;
    }
    
    func headPath3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPath3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPath3Path.moveToPoint(CGPointMake(minX + 0.89841 * w, minY + h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.79682 * w, minY + 0.90066 * h), controlPoint1:CGPointMake(minX + 0.84228 * w, minY + h), controlPoint2:CGPointMake(minX + 0.79682 * w, minY + 0.95555 * h))
        headPath3Path.addLineToPoint(CGPointMake(minX + 0.79682 * w, minY + 0.77557 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.28608 * w, minY + 0.2053 * h), controlPoint1:CGPointMake(minX + 0.79682 * w, minY + 0.4843 * h), controlPoint2:CGPointMake(minX + 0.57629 * w, minY + 0.24269 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.16826 * w, minY + 0.32246 * h), controlPoint1:CGPointMake(minX + 0.2494 * w, minY + 0.2478 * h), controlPoint2:CGPointMake(minX + 0.20994 * w, minY + 0.28703 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.02487 * w, minY + 0.31257 * h), controlPoint1:CGPointMake(minX + 0.12602 * w, minY + 0.35844 * h), controlPoint2:CGPointMake(minX + 0.06178 * w, minY + 0.35409 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.03499 * w, minY + 0.17237 * h), controlPoint1:CGPointMake(minX + -0.01192 * w, minY + 0.27117 * h), controlPoint2:CGPointMake(minX + -0.00736 * w, minY + 0.20846 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.16014 * w, minY + 0.04141 * h), controlPoint1:CGPointMake(minX + 0.08001 * w, minY + 0.13401 * h), controlPoint2:CGPointMake(minX + 0.12213 * w, minY + 0.08999 * h))
        headPath3Path.addLineToPoint(CGPointMake(minX + 0.19249 * w, minY))
        headPath3Path.addLineToPoint(CGPointMake(minX + 0.24573 * w, minY + 0.00239 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.77546 * h), controlPoint1:CGPointMake(minX + 0.66877 * w, minY + 0.02185 * h), controlPoint2:CGPointMake(minX + w, minY + 0.36148 * h))
        headPath3Path.addLineToPoint(CGPointMake(minX + w, minY + 0.90055 * h))
        headPath3Path.addCurveToPoint(CGPointMake(minX + 0.89841 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.95555 * h), controlPoint2:CGPointMake(minX + 0.95454 * w, minY + h))
        headPath3Path.closePath()
        headPath3Path.moveToPoint(CGPointMake(minX + 0.89841 * w, minY + h))
        
        return headPath3Path;
    }
    
    func headPath4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPath4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPath4Path.moveToPoint(CGPointMake(minX + 0.69831 * w, minY + h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.63244 * w, minY + 0.98878 * h), controlPoint1:CGPointMake(minX + 0.6755 * w, minY + h), controlPoint2:CGPointMake(minX + 0.65269 * w, minY + 0.99635 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.60237 * w, minY + 0.89962 * h), controlPoint1:CGPointMake(minX + 0.57944 * w, minY + 0.96871 * h), controlPoint2:CGPointMake(minX + 0.56606 * w, minY + 0.9288 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.76698 * w, minY + 0.59203 * h), controlPoint1:CGPointMake(minX + 0.7085 * w, minY + 0.8146 * h), controlPoint2:CGPointMake(minX + 0.76698 * w, minY + 0.70532 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.11645 * w, minY + 0.12823 * h), controlPoint1:CGPointMake(minX + 0.76698 * w, minY + 0.33628 * h), controlPoint2:CGPointMake(minX + 0.47509 * w, minY + 0.12823 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX, minY + 0.06411 * h), controlPoint1:CGPointMake(minX + 0.05211 * w, minY + 0.12823 * h), controlPoint2:CGPointMake(minX, minY + 0.09954 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.11645 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.02869 * h), controlPoint2:CGPointMake(minX + 0.05211 * w, minY))
        headPath4Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.59203 * h), controlPoint1:CGPointMake(minX + 0.60364 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.26557 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.79462 * w, minY + 0.97222 * h), controlPoint1:CGPointMake(minX + w, minY + 0.73099 * h), controlPoint2:CGPointMake(minX + 0.92712 * w, minY + 0.86602 * h))
        headPath4Path.addCurveToPoint(CGPointMake(minX + 0.69831 * w, minY + h), controlPoint1:CGPointMake(minX + 0.77182 * w, minY + 0.99025 * h), controlPoint2:CGPointMake(minX + 0.73538 * w, minY + h))
        headPath4Path.closePath()
        headPath4Path.moveToPoint(CGPointMake(minX + 0.69831 * w, minY + h))
        
        return headPath4Path;
    }
    
    func headPath5PathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPath5Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPath5Path.moveToPoint(CGPointMake(minX + 0.10159 * w, minY + h))
        headPath5Path.addCurveToPoint(CGPointMake(minX, minY + 0.90065 * h), controlPoint1:CGPointMake(minX + 0.04546 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.95554 * h))
        headPath5Path.addLineToPoint(CGPointMake(minX, minY + 0.77554 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.75427 * w, minY + 0.00239 * h), controlPoint1:CGPointMake(minX, minY + 0.36141 * h), controlPoint2:CGPointMake(minX + 0.33123 * w, minY + 0.02174 * h))
        headPath5Path.addLineToPoint(CGPointMake(minX + 0.80751 * w, minY))
        headPath5Path.addLineToPoint(CGPointMake(minX + 0.83986 * w, minY + 0.04141 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.96501 * w, minY + 0.17239 * h), controlPoint1:CGPointMake(minX + 0.87787 * w, minY + 0.09 * h), controlPoint2:CGPointMake(minX + 0.91999 * w, minY + 0.13413 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.97513 * w, minY + 0.31261 * h), controlPoint1:CGPointMake(minX + 1.00736 * w, minY + 0.20848 * h), controlPoint2:CGPointMake(minX + 1.01192 * w, minY + 0.2712 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.83174 * w, minY + 0.3225 * h), controlPoint1:CGPointMake(minX + 0.93833 * w, minY + 0.35413 * h), controlPoint2:CGPointMake(minX + 0.87409 * w, minY + 0.35848 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.71392 * w, minY + 0.20533 * h), controlPoint1:CGPointMake(minX + 0.79006 * w, minY + 0.28707 * h), controlPoint2:CGPointMake(minX + 0.75071 * w, minY + 0.24772 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.20318 * w, minY + 0.77565 * h), controlPoint1:CGPointMake(minX + 0.42382 * w, minY + 0.24272 * h), controlPoint2:CGPointMake(minX + 0.20318 * w, minY + 0.48435 * h))
        headPath5Path.addLineToPoint(CGPointMake(minX + 0.20318 * w, minY + 0.90076 * h))
        headPath5Path.addCurveToPoint(CGPointMake(minX + 0.10159 * w, minY + h), controlPoint1:CGPointMake(minX + 0.20318 * w, minY + 0.95554 * h), controlPoint2:CGPointMake(minX + 0.15772 * w, minY + h))
        headPath5Path.closePath()
        headPath5Path.moveToPoint(CGPointMake(minX + 0.10159 * w, minY + h))
        
        return headPath5Path;
    }
    
    func headPath6PathWithBounds(bound: CGRect) -> UIBezierPath{
        let headPath6Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        headPath6Path.moveToPoint(CGPointMake(minX + 0.30157 * w, minY + h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.20538 * w, minY + 0.97222 * h), controlPoint1:CGPointMake(minX + 0.26449 * w, minY + h), controlPoint2:CGPointMake(minX + 0.22805 * w, minY + 0.99025 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX, minY + 0.59203 * h), controlPoint1:CGPointMake(minX + 0.07288 * w, minY + 0.86602 * h), controlPoint2:CGPointMake(minX, minY + 0.73106 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.88355 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.26557 * h), controlPoint2:CGPointMake(minX + 0.39623 * w, minY))
        headPath6Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.06411 * h), controlPoint1:CGPointMake(minX + 0.94789 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.02869 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.88355 * w, minY + 0.12823 * h), controlPoint1:CGPointMake(minX + w, minY + 0.09954 * h), controlPoint2:CGPointMake(minX + 0.94789 * w, minY + 0.12823 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.23302 * w, minY + 0.59203 * h), controlPoint1:CGPointMake(minX + 0.52491 * w, minY + 0.12823 * h), controlPoint2:CGPointMake(minX + 0.23302 * w, minY + 0.33635 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.39763 * w, minY + 0.89962 * h), controlPoint1:CGPointMake(minX + 0.23302 * w, minY + 0.70532 * h), controlPoint2:CGPointMake(minX + 0.2915 * w, minY + 0.8146 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.36756 * w, minY + 0.98878 * h), controlPoint1:CGPointMake(minX + 0.43394 * w, minY + 0.9288 * h), controlPoint2:CGPointMake(minX + 0.42056 * w, minY + 0.96871 * h))
        headPath6Path.addCurveToPoint(CGPointMake(minX + 0.30157 * w, minY + h), controlPoint1:CGPointMake(minX + 0.34718 * w, minY + 0.99635 * h), controlPoint2:CGPointMake(minX + 0.32425 * w, minY + h))
        headPath6Path.closePath()
        headPath6Path.moveToPoint(CGPointMake(minX + 0.30157 * w, minY + h))
        
        return headPath6Path;
    }
    
    
}

