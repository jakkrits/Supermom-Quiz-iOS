//
//  InfoIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/11/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class InfoIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var infoFillColor : UIColor!
    
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
        self.infoFillColor = ThemeColor.IconColor
    }
    
    func setupLayers(){
        let infoPaths = CALayer()
        self.layer.addSublayer(infoPaths)
        layers["infoPaths"] = infoPaths
        let circleInfoPath = CAShapeLayer()
        infoPaths.addSublayer(circleInfoPath)
        layers["circleInfoPath"] = circleInfoPath
        let infoPath = CAShapeLayer()
        infoPaths.addSublayer(infoPath)
        layers["infoPath"] = infoPath
        let dotPath = CAShapeLayer()
        infoPaths.addSublayer(dotPath)
        layers["dotPath"] = dotPath
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("circleInfoPath"){
            let circleInfoPath = layers["circleInfoPath"] as! CAShapeLayer
            circleInfoPath.fillColor = self.infoFillColor.CGColor
            circleInfoPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("infoPath"){
            let infoPath = layers["infoPath"] as! CAShapeLayer
            infoPath.fillColor = self.infoFillColor.CGColor
            infoPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("dotPath"){
            let dotPath = layers["dotPath"] as! CAShapeLayer
            dotPath.fillColor = self.infoFillColor.CGColor
            dotPath.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let infoPaths : CALayer = layers["infoPaths"] as? CALayer{
            infoPaths.frame = CGRectMake(0.07619 * infoPaths.superlayer!.bounds.width, 0.07621 * infoPaths.superlayer!.bounds.height, 0.84762 * infoPaths.superlayer!.bounds.width, 0.84759 * infoPaths.superlayer!.bounds.height)
        }
        
        if let circleInfoPath : CAShapeLayer = layers["circleInfoPath"] as? CAShapeLayer{
            circleInfoPath.frame = CGRectMake(0, 0,  circleInfoPath.superlayer!.bounds.width,  circleInfoPath.superlayer!.bounds.height)
            circleInfoPath.path  = circleInfoPathPathWithBounds((layers["circleInfoPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let infoPath : CAShapeLayer = layers["infoPath"] as? CAShapeLayer{
            infoPath.frame = CGRectMake(0.46312 * infoPath.superlayer!.bounds.width, 0.33686 * infoPath.superlayer!.bounds.height, 0.06734 * infoPath.superlayer!.bounds.width, 0.44737 * infoPath.superlayer!.bounds.height)
            infoPath.path  = infoPathPathWithBounds((layers["infoPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let dotPath : CAShapeLayer = layers["dotPath"] as? CAShapeLayer{
            dotPath.frame = CGRectMake(0.45797 * dotPath.superlayer!.bounds.width, 0.20264 * dotPath.superlayer!.bounds.height, 0.0818 * dotPath.superlayer!.bounds.width, 0.08181 * dotPath.superlayer!.bounds.height)
            dotPath.path  = dotPathPathWithBounds((layers["dotPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func circleInfoPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let circleInfoPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        circleInfoPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.22431 * w, minY), controlPoint2:CGPointMake(minX, minY + 0.22429 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.77569 * h), controlPoint2:CGPointMake(minX + 0.2243 * w, minY + h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.7757 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.77569 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + 0.99999 * w, minY + 0.22429 * h), controlPoint2:CGPointMake(minX + 0.77568 * w, minY))
        circleInfoPathPath.closePath()
        circleInfoPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.95507 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.04489 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.24909 * w, minY + 0.95507 * h), controlPoint2:CGPointMake(minX + 0.04489 * w, minY + 0.75094 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.04487 * h), controlPoint1:CGPointMake(minX + 0.04489 * w, minY + 0.24904 * h), controlPoint2:CGPointMake(minX + 0.24909 * w, minY + 0.04487 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.95514 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.75095 * w, minY + 0.04487 * h), controlPoint2:CGPointMake(minX + 0.95514 * w, minY + 0.24902 * h))
        circleInfoPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.95507 * h), controlPoint1:CGPointMake(minX + 0.95514 * w, minY + 0.75094 * h), controlPoint2:CGPointMake(minX + 0.75095 * w, minY + 0.95507 * h))
        circleInfoPathPath.closePath()
        circleInfoPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.95507 * h))
        
        return circleInfoPathPath;
    }
    
    func infoPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let infoPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        infoPathPath.moveToPoint(CGPointMake(minX + 0.49948 * w, minY))
        infoPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.07522 * h), controlPoint1:CGPointMake(minX + 0.22408 * w, minY), controlPoint2:CGPointMake(minX, minY + 0.03365 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX, minY + 0.92466 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.49948 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.96627 * h), controlPoint2:CGPointMake(minX + 0.22408 * w, minY + h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.92466 * h), controlPoint1:CGPointMake(minX + 0.77592 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.96627 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.07522 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.49948 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.03365 * h), controlPoint2:CGPointMake(minX + 0.77562 * w, minY))
        infoPathPath.closePath()
        infoPathPath.moveToPoint(CGPointMake(minX + 0.49948 * w, minY))
        
        return infoPathPath;
    }
    
    func dotPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let dotPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        dotPathPath.moveToPoint(CGPointMake(minX + w, minY + 0.5 * h))
        dotPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77614 * w, minY + h))
        dotPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.22386 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77614 * h))
        dotPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22386 * h), controlPoint2:CGPointMake(minX + 0.22386 * w, minY))
        dotPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77614 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        dotPathPath.closePath()
        dotPathPath.moveToPoint(CGPointMake(minX + w, minY + 0.5 * h))
        
        return dotPathPath;
    }
    
    
}
