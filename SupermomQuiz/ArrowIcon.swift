//
//  ArrowIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/1/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class ArrowIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var playArrowFillColor : UIColor!
    
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
        self.playArrowFillColor = UIColor.whiteColor()
    }
    
    func setupLayers(){
        let playArrowPath : CAShapeLayer = CAShapeLayer()
        self.layer.addSublayer(playArrowPath)
        layers["playArrowPath"] = playArrowPath
        
        setupLayerFrames()
        resetLayerPropertiesForLayerIdentifiers(nil)
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("playArrowPath") {
            let playArrowPath = layers["playArrowPath"] as! CAShapeLayer
            playArrowPath.fillColor     = self.playArrowFillColor.CGColor
            playArrowPath.lineWidth     = 0
            playArrowPath.shadowColor   = UIColor(red:0.666, green: 0.653, blue:0.662, alpha:0.59).CGColor
            playArrowPath.shadowOpacity = 0.59
            playArrowPath.shadowOffset  = CGSizeMake(4, 4)
            playArrowPath.shadowRadius  = 5
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let playArrowPath : CAShapeLayer = layers["playArrowPath"] as? CAShapeLayer{
            playArrowPath.frame = CGRectMake(0.33254 * playArrowPath.superlayer!.bounds.width, 0.2 * playArrowPath.superlayer!.bounds.height, 0.5 * playArrowPath.superlayer!.bounds.width, 0.6 * playArrowPath.superlayer!.bounds.height)
            playArrowPath.path  = playArrowPathPathWithBounds((layers["playArrowPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func playArrowPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let playArrowPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        playArrowPathPath.moveToPoint(CGPointMake(minX + 0.96958 * w, minY + 0.45724 * h))
        playArrowPathPath.addLineToPoint(CGPointMake(minX + 0.11344 * w, minY + 0.01525 * h))
        playArrowPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.07101 * h), controlPoint1:CGPointMake(minX + 0.05106 * w, minY + -0.01887 * h), controlPoint2:CGPointMake(minX, minY + 0.00623 * h))
        playArrowPathPath.addLineToPoint(CGPointMake(minX, minY + 0.92901 * h))
        playArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.11344 * w, minY + 0.98478 * h), controlPoint1:CGPointMake(minX, minY + 0.99376 * h), controlPoint2:CGPointMake(minX + 0.05106 * w, minY + 1.01886 * h))
        playArrowPathPath.addLineToPoint(CGPointMake(minX + 0.96958 * w, minY + 0.54278 * h))
        playArrowPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50001 * h), controlPoint1:CGPointMake(minX + 0.96958 * w, minY + 0.54278 * h), controlPoint2:CGPointMake(minX + w, minY + 0.52494 * h))
        playArrowPathPath.addCurveToPoint(CGPointMake(minX + 0.96958 * w, minY + 0.45724 * h), controlPoint1:CGPointMake(minX + w, minY + 0.47508 * h), controlPoint2:CGPointMake(minX + 0.96958 * w, minY + 0.45724 * h))
        playArrowPathPath.closePath()
        playArrowPathPath.moveToPoint(CGPointMake(minX + 0.96958 * w, minY + 0.45724 * h))
        
        return playArrowPathPath;
    }
    
    
}

