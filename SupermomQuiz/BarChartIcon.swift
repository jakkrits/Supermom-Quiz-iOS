//
//  BarChartIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/12/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class BarChartIcon: UIView {
    
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
        let barGraphPath = CAShapeLayer()
        self.layer.addSublayer(barGraphPath)
        barGraphPath.fillColor = self.fillColor.CGColor
        barGraphPath.lineWidth = 0
        layers["barGraphPath"] = barGraphPath
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let barGraphPath : CAShapeLayer = layers["barGraphPath"] as? CAShapeLayer{
            barGraphPath.frame = CGRectMake(0.1358 * barGraphPath.superlayer!.bounds.width, 0.1358 * barGraphPath.superlayer!.bounds.height, 0.72841 * barGraphPath.superlayer!.bounds.width, 0.72841 * barGraphPath.superlayer!.bounds.height)
            barGraphPath.path  = barGraphPathPathWithBounds((layers["barGraphPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func barGraphPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let barGraphPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.97368 * w, minY))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.73684 * w, minY))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + 0.71053 * w, minY + 0.02632 * h), controlPoint1:CGPointMake(minX + 0.72237 * w, minY), controlPoint2:CGPointMake(minX + 0.71053 * w, minY + 0.01184 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.71053 * w, minY + 0.47105 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.52632 * w, minY + 0.47105 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.52632 * w, minY + 0.28947 * h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.26316 * h), controlPoint1:CGPointMake(minX + 0.52632 * w, minY + 0.275 * h), controlPoint2:CGPointMake(minX + 0.51447 * w, minY + 0.26316 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.26316 * w, minY + 0.26316 * h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + 0.23684 * w, minY + 0.28947 * h), controlPoint1:CGPointMake(minX + 0.24868 * w, minY + 0.26316 * h), controlPoint2:CGPointMake(minX + 0.23684 * w, minY + 0.275 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.23684 * w, minY + 0.69605 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.02632 * w, minY + 0.69605 * h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.72237 * h), controlPoint1:CGPointMake(minX + 0.01184 * w, minY + 0.69605 * h), controlPoint2:CGPointMake(minX, minY + 0.70789 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX, minY + 0.97368 * h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + 0.02632 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.98816 * h), controlPoint2:CGPointMake(minX + 0.01184 * w, minY + h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.97368 * w, minY + h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.97368 * h), controlPoint1:CGPointMake(minX + 0.98816 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.98816 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.02632 * h))
        barGraphPathPath.addCurveToPoint(CGPointMake(minX + 0.97368 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.01184 * h), controlPoint2:CGPointMake(minX + 0.98816 * w, minY))
        barGraphPathPath.closePath()
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.23684 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.05263 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.05263 * w, minY + 0.74868 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.23684 * w, minY + 0.74868 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.23684 * w, minY + 0.94737 * h))
        barGraphPathPath.closePath()
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.47368 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.28947 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.28947 * w, minY + 0.31579 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.47368 * w, minY + 0.31579 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.47368 * w, minY + 0.94737 * h))
        barGraphPathPath.closePath()
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.71053 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.52632 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.52632 * w, minY + 0.52368 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.71053 * w, minY + 0.52368 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.71053 * w, minY + 0.94737 * h))
        barGraphPathPath.closePath()
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.94737 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.76316 * w, minY + 0.94737 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.76316 * w, minY + 0.05263 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.94737 * w, minY + 0.05263 * h))
        barGraphPathPath.addLineToPoint(CGPointMake(minX + 0.94737 * w, minY + 0.94737 * h))
        barGraphPathPath.closePath()
        barGraphPathPath.moveToPoint(CGPointMake(minX + 0.94737 * w, minY + 0.94737 * h))
        
        return barGraphPathPath;
    }
    
    
}
