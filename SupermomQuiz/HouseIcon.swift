//
//  HouseIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/3/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//
import UIKit

@IBDesignable
class HouseIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var houseFillColor : UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
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
        self.houseFillColor = ThemeColor.LimeGreen
    }
    
    func setupLayers(){
        let House : CALayer = CALayer()
        self.layer.addSublayer(House)
        layers["House"] = House
        let houseBottompath : CAShapeLayer = CAShapeLayer()
        House.addSublayer(houseBottompath)
        layers["houseBottompath"] = houseBottompath
        let houseRoofPath : CAShapeLayer = CAShapeLayer()
        House.addSublayer(houseRoofPath)
        layers["houseRoofPath"] = houseRoofPath
        let houseBodyPath : CAShapeLayer = CAShapeLayer()
        House.addSublayer(houseBodyPath)
        layers["houseBodyPath"] = houseBodyPath
        
        setupLayerFrames()
        resetLayerPropertiesForLayerIdentifiers(nil)
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("houseBottompath"){
            let houseBottompath = layers["houseBottompath"] as! CAShapeLayer
            houseBottompath.fillColor = self.houseFillColor.CGColor
            houseBottompath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("houseRoofPath"){
            let houseRoofPath = layers["houseRoofPath"] as! CAShapeLayer
            houseRoofPath.fillColor = self.houseFillColor.CGColor
            houseRoofPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("houseBodyPath"){
            let houseBodyPath = layers["houseBodyPath"] as! CAShapeLayer
            houseBodyPath.fillColor = self.houseFillColor.CGColor
            houseBodyPath.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        if let House : CALayer = layers["House"] as? CALayer{
            House.frame = CGRectMake(0.05394 * House.superlayer!.bounds.width, 0.0881 * House.superlayer!.bounds.height, 0.89211 * House.superlayer!.bounds.width, 0.82381 * House.superlayer!.bounds.height)
        }
        
        if let houseBottompath : CAShapeLayer = layers["houseBottompath"] as? CAShapeLayer{
            houseBottompath.frame = CGRectMake(0, 0.58885 * houseBottompath.superlayer!.bounds.height, 1 * houseBottompath.superlayer!.bounds.width, 0.41115 * houseBottompath.superlayer!.bounds.height)
            houseBottompath.path  = houseBottompathPathWithBounds(houseBottompath.bounds).CGPath;
        }
        
        if let houseRoofPath : CAShapeLayer = layers["houseRoofPath"] as? CAShapeLayer{
            houseRoofPath.frame = CGRectMake(0.10707 * houseRoofPath.superlayer!.bounds.width, 0, 0.78539 * houseRoofPath.superlayer!.bounds.width, 0.40973 * houseRoofPath.superlayer!.bounds.height)
            houseRoofPath.path  = houseRoofPathPathWithBounds(houseRoofPath.bounds).CGPath;
        }
        
        if let houseBodyPath : CAShapeLayer = layers["houseBodyPath"] as? CAShapeLayer{
            houseBodyPath.frame = CGRectMake(0.207 * houseBodyPath.superlayer!.bounds.width, 0.13265 * houseBodyPath.superlayer!.bounds.height, 0.58555 * houseBodyPath.superlayer!.bounds.width, 0.66623 * houseBodyPath.superlayer!.bounds.height)
            houseBodyPath.path  = houseBodyPathPathWithBounds(houseBodyPath.bounds).CGPath;
        }
        
    }
    
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
    
    //MARK: - Bezier Path
    
    func houseBottompathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let houseBottompathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        houseBottompathPath.moveToPoint(CGPointMake(minX + 0.99907 * w, minY + 0.92005 * h))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.90391 * w, minY + 0.04539 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.88102 * w, minY), controlPoint1:CGPointMake(minX + 0.90098 * w, minY + 0.01852 * h), controlPoint2:CGPointMake(minX + 0.89163 * w, minY))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.84061 * w, minY))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.84061 * w, minY + 0.44816 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.76921 * w, minY + 0.63622 * h), controlPoint1:CGPointMake(minX + 0.84061 * w, minY + 0.55182 * h), controlPoint2:CGPointMake(minX + 0.80857 * w, minY + 0.63622 * h))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.23127 * w, minY + 0.63622 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.15987 * w, minY + 0.44816 * h), controlPoint1:CGPointMake(minX + 0.19188 * w, minY + 0.63622 * h), controlPoint2:CGPointMake(minX + 0.15987 * w, minY + 0.55182 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.15946 * w, minY + 0.4497 * h), controlPoint1:CGPointMake(minX + 0.15987 * w, minY + 0.44816 * h), controlPoint2:CGPointMake(minX + 0.15952 * w, minY + 0.44944 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.15939 * w, minY + 0.44816 * h), controlPoint1:CGPointMake(minX + 0.15946 * w, minY + 0.44918 * h), controlPoint2:CGPointMake(minX + 0.15939 * w, minY + 0.4487 * h))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.15939 * w, minY))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.11898 * w, minY))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.09609 * w, minY + 0.04539 * h), controlPoint1:CGPointMake(minX + 0.10837 * w, minY), controlPoint2:CGPointMake(minX + 0.09902 * w, minY + 0.01852 * h))
        houseBottompathPath.addLineToPoint(CGPointMake(minX + 0.00093 * w, minY + 0.92005 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.00479 * w, minY + 0.97504 * h), controlPoint1:CGPointMake(minX + -0.00113 * w, minY + 0.93896 * h), controlPoint2:CGPointMake(minX + 0.00027 * w, minY + 0.95929 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.02378 * w, minY + 0.99999 * h), controlPoint1:CGPointMake(minX + 0.00926 * w, minY + 0.99076 * h), controlPoint2:CGPointMake(minX + 0.01634 * w, minY + 0.99999 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.97622 * w, minY + 0.99999 * h), controlPoint1:CGPointMake(minX + 0.02387 * w, minY + 1.00002 * h), controlPoint2:CGPointMake(minX + 0.97622 * w, minY + 0.99999 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.99521 * w, minY + 0.97504 * h), controlPoint1:CGPointMake(minX + 0.98367 * w, minY + 0.99999 * h), controlPoint2:CGPointMake(minX + 0.99074 * w, minY + 0.99076 * h))
        houseBottompathPath.addCurveToPoint(CGPointMake(minX + 0.99907 * w, minY + 0.92005 * h), controlPoint1:CGPointMake(minX + 0.99973 * w, minY + 0.95929 * h), controlPoint2:CGPointMake(minX + 1.00113 * w, minY + 0.93896 * h))
        houseBottompathPath.closePath()
        houseBottompathPath.moveToPoint(CGPointMake(minX + 0.99907 * w, minY + 0.92005 * h))
        
        return houseBottompathPath;
    }
    
    func houseRoofPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let houseRoofPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        houseRoofPathPath.moveToPoint(CGPointMake(minX + 0.0751 * w, minY + 0.97716 * h))
        houseRoofPathPath.addLineToPoint(CGPointMake(minX + 0.50003 * w, minY + 0.21877 * h))
        houseRoofPathPath.addLineToPoint(CGPointMake(minX + 0.92495 * w, minY + 0.97716 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.95448 * w, minY + 0.99996 * h), controlPoint1:CGPointMake(minX + 0.93351 * w, minY + 0.99244 * h), controlPoint2:CGPointMake(minX + 0.94404 * w, minY + 0.99996 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.989 * w, minY + 0.96715 * h), controlPoint1:CGPointMake(minX + 0.9673 * w, minY + 0.99996 * h), controlPoint2:CGPointMake(minX + 0.98001 * w, minY + 0.98883 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.98416 * w, minY + 0.8341 * h), controlPoint1:CGPointMake(minX + 1.00535 * w, minY + 0.9276 * h), controlPoint2:CGPointMake(minX + 1.00325 * w, minY + 0.86803 * h))
        houseRoofPathPath.addLineToPoint(CGPointMake(minX + 0.52965 * w, minY + 0.02282 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.47038 * w, minY + 0.02282 * h), controlPoint1:CGPointMake(minX + 0.51265 * w, minY + -0.00761 * h), controlPoint2:CGPointMake(minX + 0.4874 * w, minY + -0.00761 * h))
        houseRoofPathPath.addLineToPoint(CGPointMake(minX + 0.01584 * w, minY + 0.83411 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.01098 * w, minY + 0.96715 * h), controlPoint1:CGPointMake(minX + -0.0032 * w, minY + 0.86804 * h), controlPoint2:CGPointMake(minX + -0.00538 * w, minY + 0.92761 * h))
        houseRoofPathPath.addCurveToPoint(CGPointMake(minX + 0.0751 * w, minY + 0.97716 * h), controlPoint1:CGPointMake(minX + 0.02741 * w, minY + 1.00667 * h), controlPoint2:CGPointMake(minX + 0.05615 * w, minY + 1.01118 * h))
        houseRoofPathPath.closePath()
        houseRoofPathPath.moveToPoint(CGPointMake(minX + 0.0751 * w, minY + 0.97716 * h))
        
        return houseRoofPathPath;
    }
    
    func houseBodyPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let houseBodyPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.47343 * w, minY + 0.00938 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.01405 * w, minY + 0.38663 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.41594 * h), controlPoint1:CGPointMake(minX + 0.00516 * w, minY + 0.39404 * h), controlPoint2:CGPointMake(minX, minY + 0.40471 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX, minY + 0.96134 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.04062 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.98271 * h), controlPoint2:CGPointMake(minX + 0.0182 * w, minY + h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.95931 * w, minY + h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.96134 * h), controlPoint1:CGPointMake(minX + 0.9818 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.98271 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.41594 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.98584 * w, minY + 0.38663 * h), controlPoint1:CGPointMake(minX + w, minY + 0.40471 * h), controlPoint2:CGPointMake(minX + 0.99485 * w, minY + 0.39404 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.52654 * w, minY + 0.00938 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.47343 * w, minY + 0.00938 * h), controlPoint1:CGPointMake(minX + 0.5113 * w, minY + -0.00313 * h), controlPoint2:CGPointMake(minX + 0.48867 * w, minY + -0.00313 * h))
        houseBodyPathPath.closePath()
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.82893 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.41869 * w, minY + 0.86763 * h), controlPoint1:CGPointMake(minX + 0.45931 * w, minY + 0.85029 * h), controlPoint2:CGPointMake(minX + 0.44111 * w, minY + 0.86763 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.27645 * w, minY + 0.86763 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.23575 * w, minY + 0.82893 * h), controlPoint1:CGPointMake(minX + 0.25395 * w, minY + 0.86763 * h), controlPoint2:CGPointMake(minX + 0.23575 * w, minY + 0.85029 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.23575 * w, minY + 0.69341 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.27645 * w, minY + 0.65473 * h), controlPoint1:CGPointMake(minX + 0.23575 * w, minY + 0.67205 * h), controlPoint2:CGPointMake(minX + 0.25395 * w, minY + 0.65473 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.41869 * w, minY + 0.65473 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.69341 * h), controlPoint1:CGPointMake(minX + 0.44111 * w, minY + 0.65473 * h), controlPoint2:CGPointMake(minX + 0.45931 * w, minY + 0.67205 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.82893 * h))
        houseBodyPathPath.closePath()
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.53867 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.41869 * w, minY + 0.57737 * h), controlPoint1:CGPointMake(minX + 0.45931 * w, minY + 0.56005 * h), controlPoint2:CGPointMake(minX + 0.44111 * w, minY + 0.57737 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.27645 * w, minY + 0.57737 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.23575 * w, minY + 0.53867 * h), controlPoint1:CGPointMake(minX + 0.25395 * w, minY + 0.57737 * h), controlPoint2:CGPointMake(minX + 0.23575 * w, minY + 0.56005 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.23575 * w, minY + 0.40317 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.27645 * w, minY + 0.36447 * h), controlPoint1:CGPointMake(minX + 0.23575 * w, minY + 0.38179 * h), controlPoint2:CGPointMake(minX + 0.25395 * w, minY + 0.36447 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.41869 * w, minY + 0.36447 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.40317 * h), controlPoint1:CGPointMake(minX + 0.44111 * w, minY + 0.36447 * h), controlPoint2:CGPointMake(minX + 0.45931 * w, minY + 0.38179 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.45931 * w, minY + 0.53867 * h))
        houseBodyPathPath.closePath()
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.40317 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.58132 * w, minY + 0.36447 * h), controlPoint1:CGPointMake(minX + 0.54062 * w, minY + 0.38179 * h), controlPoint2:CGPointMake(minX + 0.55878 * w, minY + 0.36447 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.72352 * w, minY + 0.36447 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.76414 * w, minY + 0.40317 * h), controlPoint1:CGPointMake(minX + 0.74594 * w, minY + 0.36447 * h), controlPoint2:CGPointMake(minX + 0.76414 * w, minY + 0.38179 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.76414 * w, minY + 0.53867 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.72352 * w, minY + 0.57737 * h), controlPoint1:CGPointMake(minX + 0.76414 * w, minY + 0.56005 * h), controlPoint2:CGPointMake(minX + 0.74594 * w, minY + 0.57737 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.58132 * w, minY + 0.57737 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.53867 * h), controlPoint1:CGPointMake(minX + 0.55878 * w, minY + 0.57737 * h), controlPoint2:CGPointMake(minX + 0.54062 * w, minY + 0.56005 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.40317 * h))
        houseBodyPathPath.closePath()
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.6934 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.58132 * w, minY + 0.65473 * h), controlPoint1:CGPointMake(minX + 0.54062 * w, minY + 0.67205 * h), controlPoint2:CGPointMake(minX + 0.55878 * w, minY + 0.65473 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.72352 * w, minY + 0.65473 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.76414 * w, minY + 0.6934 * h), controlPoint1:CGPointMake(minX + 0.74594 * w, minY + 0.65473 * h), controlPoint2:CGPointMake(minX + 0.76414 * w, minY + 0.67205 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.76414 * w, minY + 0.82893 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.72352 * w, minY + 0.86762 * h), controlPoint1:CGPointMake(minX + 0.76414 * w, minY + 0.85028 * h), controlPoint2:CGPointMake(minX + 0.74594 * w, minY + 0.86762 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.58132 * w, minY + 0.86762 * h))
        houseBodyPathPath.addCurveToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.82893 * h), controlPoint1:CGPointMake(minX + 0.55878 * w, minY + 0.86762 * h), controlPoint2:CGPointMake(minX + 0.54062 * w, minY + 0.85028 * h))
        houseBodyPathPath.addLineToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.6934 * h))
        houseBodyPathPath.closePath()
        houseBodyPathPath.moveToPoint(CGPointMake(minX + 0.54062 * w, minY + 0.6934 * h))
        
        return houseBodyPathPath;
    }
    
    
}
