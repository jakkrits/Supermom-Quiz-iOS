//
//  AdvertisingIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/16/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//
//

import UIKit

@IBDesignable
class AdvertisingIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
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
        self.fillColor = ThemeColor.SettingsIconColor
    }
    
    func setupLayers(){
        let advertisingIcon = CALayer()
        self.layer.addSublayer(advertisingIcon)
        layers["advertisingIcon"] = advertisingIcon
        let bottomArrowPath = CAShapeLayer()
        advertisingIcon.addSublayer(bottomArrowPath)
        layers["bottomArrowPath"] = bottomArrowPath
        let innerAPath = CAShapeLayer()
        advertisingIcon.addSublayer(innerAPath)
        layers["innerAPath"] = innerAPath
        let innerDPath = CAShapeLayer()
        advertisingIcon.addSublayer(innerDPath)
        layers["innerDPath"] = innerDPath
        let backgroundPath = CAShapeLayer()
        advertisingIcon.addSublayer(backgroundPath)
        layers["backgroundPath"] = backgroundPath
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("bottomArrowPath"){
            let bottomArrowPath = layers["bottomArrowPath"] as! CAShapeLayer
            bottomArrowPath.fillColor = self.fillColor.CGColor
            bottomArrowPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("innerAPath"){
            let innerAPath = layers["innerAPath"] as! CAShapeLayer
            innerAPath.fillColor = self.fillColor.CGColor
            innerAPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("innerDPath"){
            let innerDPath = layers["innerDPath"] as! CAShapeLayer
            innerDPath.fillColor = self.fillColor.CGColor
            innerDPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("backgroundPath"){
            let backgroundPath = layers["backgroundPath"] as! CAShapeLayer
            backgroundPath.fillColor = self.fillColor.CGColor
            backgroundPath.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let advertisingIcon : CALayer = layers["advertisingIcon"] as? CALayer{
            advertisingIcon.frame = CGRectMake(0.06842 * advertisingIcon.superlayer!.bounds.width, 0.15648 * advertisingIcon.superlayer!.bounds.height, 0.86317 * advertisingIcon.superlayer!.bounds.width, 0.66822 * advertisingIcon.superlayer!.bounds.height)
        }
        
        if let bottomArrowPath : CAShapeLayer = layers["bottomArrowPath"] as? CAShapeLayer{
            bottomArrowPath.frame = CGRectMake(0.75931 * bottomArrowPath.superlayer!.bounds.width, 0.68907 * bottomArrowPath.superlayer!.bounds.height, 0.24069 * bottomArrowPath.superlayer!.bounds.width, 0.31093 * bottomArrowPath.superlayer!.bounds.height)
            bottomArrowPath.path  = bottomArrowPathPathWithBounds((layers["bottomArrowPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let innerAPath : CAShapeLayer = layers["innerAPath"] as? CAShapeLayer{
            innerAPath.frame = CGRectMake(0.3517 * innerAPath.superlayer!.bounds.width, 0.2618 * innerAPath.superlayer!.bounds.height, 0.03003 * innerAPath.superlayer!.bounds.width, 0.05178 * innerAPath.superlayer!.bounds.height)
            innerAPath.path  = innerAPathPathWithBounds((layers["innerAPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let innerDPath : CAShapeLayer = layers["innerDPath"] as? CAShapeLayer{
            innerDPath.frame = CGRectMake(0.51889 * innerDPath.superlayer!.bounds.width, 0.2258 * innerDPath.superlayer!.bounds.height, 0.11444 * innerDPath.superlayer!.bounds.width, 0.16879 * innerDPath.superlayer!.bounds.height)
            innerDPath.path  = innerDPathPathWithBounds((layers["innerDPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let backgroundPath : CAShapeLayer = layers["backgroundPath"] as? CAShapeLayer{
            backgroundPath.frame = CGRectMake(0, 0, 0.92986 * backgroundPath.superlayer!.bounds.width, 0.62187 * backgroundPath.superlayer!.bounds.height)
            backgroundPath.path  = backgroundPathPathWithBounds((layers["backgroundPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func bottomArrowPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let bottomArrowPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        bottomArrowPathPath.moveToPoint(CGPointMake(minX + 0.95818 * w, minY + 0.75613 * h))
        bottomArrowPathPath.addLineToPoint(CGPointMake(minX + 0.66888 * w, minY + 0.46685 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.78882 * w, minY + 0.37263 * h), controlPoint1:CGPointMake(minX + 0.72314 * w, minY + 0.46122 * h), controlPoint2:CGPointMake(minX + 0.77028 * w, minY + 0.42478 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.78324 * w, minY + 0.26342 * h), controlPoint1:CGPointMake(minX + 0.80162 * w, minY + 0.33668 * h), controlPoint2:CGPointMake(minX + 0.79964 * w, minY + 0.29789 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.70209 * w, minY + 0.19015 * h), controlPoint1:CGPointMake(minX + 0.76688 * w, minY + 0.22895 * h), controlPoint2:CGPointMake(minX + 0.73803 * w, minY + 0.20293 * h))
        bottomArrowPathPath.addLineToPoint(CGPointMake(minX + 0.19062 * w, minY + 0.00823 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.1428 * w, minY), controlPoint1:CGPointMake(minX + 0.17521 * w, minY + 0.00277 * h), controlPoint2:CGPointMake(minX + 0.15913 * w, minY))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.04178 * w, minY + 0.04181 * h), controlPoint1:CGPointMake(minX + 0.10461 * w, minY), controlPoint2:CGPointMake(minX + 0.06872 * w, minY + 0.01486 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.00818 * w, minY + 0.19072 * h), controlPoint1:CGPointMake(minX + 0.00299 * w, minY + 0.08059 * h), controlPoint2:CGPointMake(minX + -0.0102 * w, minY + 0.13903 * h))
        bottomArrowPathPath.addLineToPoint(CGPointMake(minX + 0.18305 * w, minY + 0.68225 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.31766 * w, minY + 0.77725 * h), controlPoint1:CGPointMake(minX + 0.20327 * w, minY + 0.73908 * h), controlPoint2:CGPointMake(minX + 0.25736 * w, minY + 0.77725 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.36557 * w, minY + 0.76897 * h), controlPoint1:CGPointMake(minX + 0.33396 * w, minY + 0.77725 * h), controlPoint2:CGPointMake(minX + 0.35008 * w, minY + 0.77447 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.45815 * w, minY + 0.66021 * h), controlPoint1:CGPointMake(minX + 0.41529 * w, minY + 0.75128 * h), controlPoint2:CGPointMake(minX + 0.44916 * w, minY + 0.7087 * h))
        bottomArrowPathPath.addLineToPoint(CGPointMake(minX + 0.7561 * w, minY + 0.95814 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.85713 * w, minY + h), controlPoint1:CGPointMake(minX + 0.78308 * w, minY + 0.98513 * h), controlPoint2:CGPointMake(minX + 0.81895 * w, minY + h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.95814 * w, minY + 0.95817 * h), controlPoint1:CGPointMake(minX + 0.8953 * w, minY + h), controlPoint2:CGPointMake(minX + 0.93119 * w, minY + 0.98513 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.85714 * h), controlPoint1:CGPointMake(minX + 0.98514 * w, minY + 0.93118 * h), controlPoint2:CGPointMake(minX + w, minY + 0.89531 * h))
        bottomArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.95818 * w, minY + 0.75613 * h), controlPoint1:CGPointMake(minX + w, minY + 0.81897 * h), controlPoint2:CGPointMake(minX + 0.98518 * w, minY + 0.78311 * h))
        bottomArrowPathPath.closePath()
        bottomArrowPathPath.moveToPoint(CGPointMake(minX + 0.95818 * w, minY + 0.75613 * h))
        
        return bottomArrowPathPath;
    }
    
    func innerAPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let innerAPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        innerAPathPath.moveToPoint(CGPointMake(minX, minY + h))
        innerAPathPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        innerAPathPath.addLineToPoint(CGPointMake(minX + 0.49697 * w, minY))
        innerAPathPath.closePath()
        innerAPathPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return innerAPathPath;
    }
    
    func innerDPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let innerDPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        innerDPathPath.moveToPoint(CGPointMake(minX + 0.41079 * w, minY))
        innerDPathPath.addLineToPoint(CGPointMake(minX, minY))
        innerDPathPath.addLineToPoint(CGPointMake(minX, minY + h))
        innerDPathPath.addLineToPoint(CGPointMake(minX + 0.41079 * w, minY + h))
        innerDPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50093 * h), controlPoint1:CGPointMake(minX + 0.7357 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.77613 * h))
        innerDPathPath.addCurveToPoint(CGPointMake(minX + 0.41079 * w, minY), controlPoint1:CGPointMake(minX + 1.00003 * w, minY + 0.22472 * h), controlPoint2:CGPointMake(minX + 0.7357 * w, minY))
        innerDPathPath.closePath()
        innerDPathPath.moveToPoint(CGPointMake(minX + 0.41079 * w, minY))
        
        return innerDPathPath;
    }
    
    func backgroundPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let backgroundPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        backgroundPathPath.moveToPoint(CGPointMake(minX + w, minY + 0.89765 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.10235 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.94702 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.04591 * h), controlPoint2:CGPointMake(minX + 0.97623 * w, minY))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.05299 * w, minY))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.10235 * h), controlPoint1:CGPointMake(minX + 0.02377 * w, minY), controlPoint2:CGPointMake(minX, minY + 0.04591 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX, minY + 0.89765 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.05299 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.95409 * h), controlPoint2:CGPointMake(minX + 0.02377 * w, minY + h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.94702 * w, minY + h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.89765 * h), controlPoint1:CGPointMake(minX + 0.97623 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.95409 * h))
        backgroundPathPath.closePath()
        backgroundPathPath.moveToPoint(CGPointMake(minX + 0.48191 * w, minY + 0.72261 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.48184 * w, minY + 0.72261 * h), controlPoint1:CGPointMake(minX + 0.48188 * w, minY + 0.72261 * h), controlPoint2:CGPointMake(minX + 0.48186 * w, minY + 0.72261 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.46208 * w, minY + 0.72261 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.44996 * w, minY + 0.70643 * h), controlPoint1:CGPointMake(minX + 0.45669 * w, minY + 0.72261 * h), controlPoint2:CGPointMake(minX + 0.45186 * w, minY + 0.71617 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.42724 * w, minY + 0.58997 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.36171 * w, minY + 0.58997 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.33929 * w, minY + 0.70633 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.32717 * w, minY + 0.72261 * h), controlPoint1:CGPointMake(minX + 0.33741 * w, minY + 0.71612 * h), controlPoint2:CGPointMake(minX + 0.33257 * w, minY + 0.72261 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.30743 * w, minY + 0.72261 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.2968 * w, minY + 0.71187 * h), controlPoint1:CGPointMake(minX + 0.3032 * w, minY + 0.72261 * h), controlPoint2:CGPointMake(minX + 0.29922 * w, minY + 0.7186 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.2953 * w, minY + 0.68889 * h), controlPoint1:CGPointMake(minX + 0.29438 * w, minY + 0.70515 * h), controlPoint2:CGPointMake(minX + 0.29382 * w, minY + 0.69656 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.37112 * w, minY + 0.29544 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.38322 * w, minY + 0.27916 * h), controlPoint1:CGPointMake(minX + 0.373 * w, minY + 0.28567 * h), controlPoint2:CGPointMake(minX + 0.37783 * w, minY + 0.27919 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.40503 * w, minY + 0.27908 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.40506 * w, minY + 0.27908 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.41717 * w, minY + 0.29526 * h), controlPoint1:CGPointMake(minX + 0.41045 * w, minY + 0.27908 * h), controlPoint2:CGPointMake(minX + 0.41527 * w, minY + 0.28552 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.49348 * w, minY + 0.68637 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.49486 * w, minY + 0.69761 * h), controlPoint1:CGPointMake(minX + 0.49436 * w, minY + 0.68975 * h), controlPoint2:CGPointMake(minX + 0.49486 * w, minY + 0.69356 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.48191 * w, minY + 0.72261 * h), controlPoint1:CGPointMake(minX + 0.49486 * w, minY + 0.71142 * h), controlPoint2:CGPointMake(minX + 0.48906 * w, minY + 0.72261 * h))
        backgroundPathPath.closePath()
        backgroundPathPath.moveToPoint(CGPointMake(minX + 0.60858 * w, minY + 0.72023 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.52659 * w, minY + 0.72023 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.51365 * w, minY + 0.69523 * h), controlPoint1:CGPointMake(minX + 0.51944 * w, minY + 0.72023 * h), controlPoint2:CGPointMake(minX + 0.51365 * w, minY + 0.70904 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.51365 * w, minY + 0.30238 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.52659 * w, minY + 0.27738 * h), controlPoint1:CGPointMake(minX + 0.51365 * w, minY + 0.28857 * h), controlPoint2:CGPointMake(minX + 0.51944 * w, minY + 0.27738 * h))
        backgroundPathPath.addLineToPoint(CGPointMake(minX + 0.60858 * w, minY + 0.27738 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.72547 * w, minY + 0.49906 * h), controlPoint1:CGPointMake(minX + 0.67304 * w, minY + 0.27738 * h), controlPoint2:CGPointMake(minX + 0.72547 * w, minY + 0.37682 * h))
        backgroundPathPath.addCurveToPoint(CGPointMake(minX + 0.60858 * w, minY + 0.72023 * h), controlPoint1:CGPointMake(minX + 0.72548 * w, minY + 0.62101 * h), controlPoint2:CGPointMake(minX + 0.67304 * w, minY + 0.72023 * h))
        backgroundPathPath.closePath()
        backgroundPathPath.moveToPoint(CGPointMake(minX + 0.60858 * w, minY + 0.72023 * h))
        
        return backgroundPathPath;
    }
    
    
}
