//
//  PlayIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/12/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class PlayIcon: UIView {
    
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
        let playIcon = CALayer()
        self.layer.addSublayer(playIcon)
        
        layers["playIcon"] = playIcon
        let arrowPlayPath = CAShapeLayer()
        playIcon.addSublayer(arrowPlayPath)
        arrowPlayPath.fillColor = self.fillColor.CGColor
        arrowPlayPath.lineWidth = 0
        layers["arrowPlayPath"] = arrowPlayPath
        let circlePlayPath = CAShapeLayer()
        playIcon.addSublayer(circlePlayPath)
        circlePlayPath.fillColor = self.fillColor.CGColor
        circlePlayPath.lineWidth = 0
        layers["circlePlayPath"] = circlePlayPath
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let playIcon : CALayer = layers["playIcon"] as? CALayer{
            playIcon.frame = CGRectMake(0.08064 * playIcon.superlayer!.bounds.width, 0.08064 * playIcon.superlayer!.bounds.height, 0.83872 * playIcon.superlayer!.bounds.width, 0.83872 * playIcon.superlayer!.bounds.height)
        }
        
        if let arrowPlayPath : CAShapeLayer = layers["arrowPlayPath"] as? CAShapeLayer{
            arrowPlayPath.frame = CGRectMake(0.3296 * arrowPlayPath.superlayer!.bounds.width, 0.24959 * arrowPlayPath.superlayer!.bounds.height, 0.43915 * arrowPlayPath.superlayer!.bounds.width, 0.50081 * arrowPlayPath.superlayer!.bounds.height)
            arrowPlayPath.path  = arrowPlayPathPathWithBounds((layers["arrowPlayPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let circlePlayPath : CAShapeLayer = layers["circlePlayPath"] as? CAShapeLayer{
            circlePlayPath.frame = CGRectMake(0, 0,  circlePlayPath.superlayer!.bounds.width,  circlePlayPath.superlayer!.bounds.height)
            circlePlayPath.path  = circlePlayPathPathWithBounds((layers["circlePlayPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func arrowPlayPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let arrowPlayPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        arrowPlayPathPath.moveToPoint(CGPointMake(minX + 0.0462 * w, minY + h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + 0.0231 * w, minY + 0.99457 * h), controlPoint1:CGPointMake(minX + 0.03822 * w, minY + h), controlPoint2:CGPointMake(minX + 0.03025 * w, minY + 0.99819 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.95949 * h), controlPoint1:CGPointMake(minX + 0.00881 * w, minY + 0.98734 * h), controlPoint2:CGPointMake(minX, minY + 0.97396 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX, minY + 0.04051 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + 0.0231 * w, minY + 0.00543 * h), controlPoint1:CGPointMake(minX, minY + 0.02604 * h), controlPoint2:CGPointMake(minX + 0.00881 * w, minY + 0.01266 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + 0.0693 * w, minY + 0.00543 * h), controlPoint1:CGPointMake(minX + 0.0374 * w, minY + -0.00181 * h), controlPoint2:CGPointMake(minX + 0.05501 * w, minY + -0.00181 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX + 0.9769 * w, minY + 0.46492 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.99119 * w, minY + 0.47215 * h), controlPoint2:CGPointMake(minX + w, minY + 0.48553 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + 0.9769 * w, minY + 0.53509 * h), controlPoint1:CGPointMake(minX + w, minY + 0.51448 * h), controlPoint2:CGPointMake(minX + 0.99119 * w, minY + 0.52785 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX + 0.0693 * w, minY + 0.99457 * h))
        arrowPlayPathPath.addCurveToPoint(CGPointMake(minX + 0.0462 * w, minY + h), controlPoint1:CGPointMake(minX + 0.06216 * w, minY + 0.99819 * h), controlPoint2:CGPointMake(minX + 0.05418 * w, minY + h))
        arrowPlayPathPath.closePath()
        arrowPlayPathPath.moveToPoint(CGPointMake(minX + 0.09241 * w, minY + 0.11069 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX + 0.09241 * w, minY + 0.88931 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX + 0.86139 * w, minY + 0.5 * h))
        arrowPlayPathPath.addLineToPoint(CGPointMake(minX + 0.09241 * w, minY + 0.11069 * h))
        arrowPlayPathPath.closePath()
        arrowPlayPathPath.moveToPoint(CGPointMake(minX + 0.09241 * w, minY + 0.11069 * h))
        
        return arrowPlayPathPath;
    }
    
    func circlePlayPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let circlePlayPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        circlePlayPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY + h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h), controlPoint1:CGPointMake(minX + 0.36644 * w, minY + h), controlPoint2:CGPointMake(minX + 0.24088 * w, minY + 0.94799 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.05201 * w, minY + 0.75911 * h), controlPoint2:CGPointMake(minX, minY + 0.63356 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h), controlPoint1:CGPointMake(minX, minY + 0.36644 * h), controlPoint2:CGPointMake(minX + 0.05201 * w, minY + 0.24088 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + 0.24088 * w, minY + 0.05201 * h), controlPoint2:CGPointMake(minX + 0.36644 * w, minY))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h), controlPoint1:CGPointMake(minX + 0.63356 * w, minY), controlPoint2:CGPointMake(minX + 0.75912 * w, minY + 0.05201 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.94799 * w, minY + 0.24088 * h), controlPoint2:CGPointMake(minX + w, minY + 0.36644 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h), controlPoint1:CGPointMake(minX + w, minY + 0.63356 * h), controlPoint2:CGPointMake(minX + 0.94799 * w, minY + 0.75912 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + 0.75912 * w, minY + 0.94799 * h), controlPoint2:CGPointMake(minX + 0.63356 * w, minY + h))
        circlePlayPathPath.closePath()
        circlePlayPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.04098 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.17542 * w, minY + 0.17542 * h), controlPoint1:CGPointMake(minX + 0.37739 * w, minY + 0.04098 * h), controlPoint2:CGPointMake(minX + 0.26212 * w, minY + 0.08873 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.04098 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.08873 * w, minY + 0.26212 * h), controlPoint2:CGPointMake(minX + 0.04098 * w, minY + 0.37739 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.17542 * w, minY + 0.82458 * h), controlPoint1:CGPointMake(minX + 0.04098 * w, minY + 0.62261 * h), controlPoint2:CGPointMake(minX + 0.08873 * w, minY + 0.73788 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.95902 * h), controlPoint1:CGPointMake(minX + 0.26212 * w, minY + 0.91128 * h), controlPoint2:CGPointMake(minX + 0.37739 * w, minY + 0.95902 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.82458 * w, minY + 0.82458 * h), controlPoint1:CGPointMake(minX + 0.62261 * w, minY + 0.95902 * h), controlPoint2:CGPointMake(minX + 0.73788 * w, minY + 0.91128 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.95902 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.91127 * w, minY + 0.73788 * h), controlPoint2:CGPointMake(minX + 0.95902 * w, minY + 0.62261 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.82458 * w, minY + 0.17542 * h), controlPoint1:CGPointMake(minX + 0.95902 * w, minY + 0.37739 * h), controlPoint2:CGPointMake(minX + 0.91128 * w, minY + 0.26212 * h))
        circlePlayPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.04098 * h), controlPoint1:CGPointMake(minX + 0.73788 * w, minY + 0.08873 * h), controlPoint2:CGPointMake(minX + 0.62261 * w, minY + 0.04098 * h))
        circlePlayPathPath.closePath()
        circlePlayPathPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.04098 * h))
        
        return circlePlayPathPath;
    }
    
    
}
