//
//  InfoIcon-Thick.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/16/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class InfoIcon_Thick: UIView {
    
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
        let infoPath = CAShapeLayer()
        self.layer.addSublayer(infoPath)
        layers["infoPath"] = infoPath
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("infoPath"){
            let infoPath = layers["infoPath"] as! CAShapeLayer
            infoPath.fillColor = self.fillColor.CGColor
            infoPath.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let infoPath : CAShapeLayer = layers["infoPath"] as? CAShapeLayer{
            infoPath.frame = CGRectMake(0.12104 * infoPath.superlayer!.bounds.width, 0.11759 * infoPath.superlayer!.bounds.height, 0.75792 * infoPath.superlayer!.bounds.width, 0.76482 * infoPath.superlayer!.bounds.height)
            infoPath.path  = infoPathPathWithBounds((layers["infoPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func infoPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let infoPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        infoPathPath.moveToPoint(CGPointMake(minX + 0.51995 * w, minY))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.03994 * w, minY + 0.4757 * h), controlPoint1:CGPointMake(minX + 0.25485 * w, minY), controlPoint2:CGPointMake(minX + 0.03994 * w, minY + 0.21297 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.09906 * w, minY + 0.70439 * h), controlPoint1:CGPointMake(minX + 0.03994 * w, minY + 0.55862 * h), controlPoint2:CGPointMake(minX + 0.06144 * w, minY + 0.63652 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + 0.00325 * w, minY + 0.93937 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.01304 * w, minY + 0.98707 * h), controlPoint1:CGPointMake(minX + -0.00345 * w, minY + 0.95579 * h), controlPoint2:CGPointMake(minX + 0.00041 * w, minY + 0.97456 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.06116 * w, minY + 0.99678 * h), controlPoint1:CGPointMake(minX + 0.02564 * w, minY + 0.99959 * h), controlPoint2:CGPointMake(minX + 0.0446 * w, minY + 1.00342 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + 0.30337 * w, minY + 0.89983 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.51995 * w, minY + 0.95139 * h), controlPoint1:CGPointMake(minX + 0.36853 * w, minY + 0.93255 * h), controlPoint2:CGPointMake(minX + 0.44194 * w, minY + 0.95139 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.4757 * h), controlPoint1:CGPointMake(minX + 0.78509 * w, minY + 0.95139 * h), controlPoint2:CGPointMake(minX + w, minY + 0.73842 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.51995 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.21297 * h), controlPoint2:CGPointMake(minX + 0.78509 * w, minY))
        infoPathPath.closePath()
        infoPathPath.moveToPoint(CGPointMake(minX + 0.51942 * w, minY + 0.19179 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.6039 * w, minY + 0.2755 * h), controlPoint1:CGPointMake(minX + 0.56607 * w, minY + 0.19179 * h), controlPoint2:CGPointMake(minX + 0.6039 * w, minY + 0.22927 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.51942 * w, minY + 0.35922 * h), controlPoint1:CGPointMake(minX + 0.6039 * w, minY + 0.32174 * h), controlPoint2:CGPointMake(minX + 0.56607 * w, minY + 0.35922 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.43494 * w, minY + 0.2755 * h), controlPoint1:CGPointMake(minX + 0.47277 * w, minY + 0.35922 * h), controlPoint2:CGPointMake(minX + 0.43494 * w, minY + 0.32174 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.51942 * w, minY + 0.19179 * h), controlPoint1:CGPointMake(minX + 0.43494 * w, minY + 0.22927 * h), controlPoint2:CGPointMake(minX + 0.47277 * w, minY + 0.19179 * h))
        infoPathPath.closePath()
        infoPathPath.moveToPoint(CGPointMake(minX + 0.60473 * w, minY + 0.72082 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.56558 * w, minY + 0.75962 * h), controlPoint1:CGPointMake(minX + 0.60473 * w, minY + 0.74225 * h), controlPoint2:CGPointMake(minX + 0.5872 * w, minY + 0.75962 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + 0.47326 * w, minY + 0.75962 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.43411 * w, minY + 0.72082 * h), controlPoint1:CGPointMake(minX + 0.45164 * w, minY + 0.75962 * h), controlPoint2:CGPointMake(minX + 0.43411 * w, minY + 0.74225 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + 0.43411 * w, minY + 0.40098 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.51942 * w, minY + 0.42685 * h), controlPoint1:CGPointMake(minX + 0.45847 * w, minY + 0.41731 * h), controlPoint2:CGPointMake(minX + 0.48786 * w, minY + 0.42685 * h))
        infoPathPath.addCurveToPoint(CGPointMake(minX + 0.60474 * w, minY + 0.40098 * h), controlPoint1:CGPointMake(minX + 0.55098 * w, minY + 0.42685 * h), controlPoint2:CGPointMake(minX + 0.58037 * w, minY + 0.41731 * h))
        infoPathPath.addLineToPoint(CGPointMake(minX + 0.60474 * w, minY + 0.72082 * h))
        infoPathPath.closePath()
        infoPathPath.moveToPoint(CGPointMake(minX + 0.60473 * w, minY + 0.72082 * h))
        
        return infoPathPath;
    }
    
    
}

