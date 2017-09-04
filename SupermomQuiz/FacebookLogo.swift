//
//  FacebookLogo.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/3/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class FacebookLogo: UIView {
    
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
        self.fillColor = ThemeColor.FacebookBlue
    }
    
    func setupLayers(){
        let path = CAShapeLayer()
        self.layer.addSublayer(path)
        layers["path"] = path
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("path"){
            let path = layers["path"] as! CAShapeLayer
            path.fillColor = self.fillColor.CGColor
            path.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
            path.frame = CGRectMake(0.11456 * path.superlayer!.bounds.width, 0.11456 * path.superlayer!.bounds.height, 0.77089 * path.superlayer!.bounds.width, 0.77089 * path.superlayer!.bounds.height)
            path.path  = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).CGPath;
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
        
        pathPath.moveToPoint(CGPointMake(minX + w, minY + 0.50339 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.61136 * w, minY + 0.99378 * h), controlPoint1:CGPointMake(minX + w, minY + 0.7428 * h), controlPoint2:CGPointMake(minX + 0.83386 * w, minY + 0.94276 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.61136 * w, minY + 0.57561 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.73151 * w, minY + 0.57561 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.73151 * w, minY + 0.43598 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.61014 * w, minY + 0.43598 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.61014 * w, minY + 0.40481 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.69805 * w, minY + 0.29632 * h), controlPoint1:CGPointMake(minX + 0.61014 * w, minY + 0.34496 * h), controlPoint2:CGPointMake(minX + 0.63616 * w, minY + 0.29632 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.75881 * w, minY + 0.30505 * h), controlPoint1:CGPointMake(minX + 0.72286 * w, minY + 0.29632 * h), controlPoint2:CGPointMake(minX + 0.74269 * w, minY + 0.30007 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.76621 * w, minY + 0.15917 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.66593 * w, minY + 0.14667 * h), controlPoint1:CGPointMake(minX + 0.74019 * w, minY + 0.1517 * h), controlPoint2:CGPointMake(minX + 0.70807 * w, minY + 0.14667 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.49874 * w, minY + 0.20781 * h), controlPoint1:CGPointMake(minX + 0.61145 * w, minY + 0.14667 * h), controlPoint2:CGPointMake(minX + 0.54577 * w, minY + 0.16295 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.42193 * w, minY + 0.41228 * h), controlPoint1:CGPointMake(minX + 0.44421 * w, minY + 0.2577 * h), controlPoint2:CGPointMake(minX + 0.42193 * w, minY + 0.33874 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.42193 * w, minY + 0.43595 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.34265 * w, minY + 0.43595 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.34265 * w, minY + 0.57559 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.42191 * w, minY + 0.57559 * h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.42191 * w, minY + h))
        pathPath.addCurveToPoint(CGPointMake(minX, minY + 0.50339 * h), controlPoint1:CGPointMake(minX + 0.18296 * w, minY + 0.9622 * h), controlPoint2:CGPointMake(minX, minY + 0.75458 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22538 * h), controlPoint2:CGPointMake(minX + 0.22388 * w, minY))
        pathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50339 * h), controlPoint1:CGPointMake(minX + 0.77617 * w, minY + -0.00002 * h), controlPoint2:CGPointMake(minX + w, minY + 0.22536 * h))
        pathPath.closePath()
        pathPath.moveToPoint(CGPointMake(minX + w, minY + 0.50339 * h))
        
        return pathPath;
    }
    
    
}


