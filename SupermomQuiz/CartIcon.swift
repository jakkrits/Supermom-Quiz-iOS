//
//  CartIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/12/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class CartIcon: UIView {
    
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
        self.fillColor = ThemeColor.IconColor
    }
    
    func setupLayers(){
        let cart = CALayer()
        self.layer.addSublayer(cart)
        layers["cart"] = cart
        let cartPath = CAShapeLayer()
        cart.addSublayer(cartPath)
        layers["cartPath"] = cartPath
        let cartPath2 = CAShapeLayer()
        cart.addSublayer(cartPath2)
        layers["cartPath2"] = cartPath2
        let cartPath3 = CAShapeLayer()
        cart.addSublayer(cartPath3)
        layers["cartPath3"] = cartPath3
        let cartPath4 = CAShapeLayer()
        cart.addSublayer(cartPath4)
        layers["cartPath4"] = cartPath4
        let cartpath = CAShapeLayer()
        cart.addSublayer(cartpath)
        layers["cartpath"] = cartpath
        let cartpath2 = CAShapeLayer()
        cart.addSublayer(cartpath2)
        layers["cartpath2"] = cartpath2
        let cartpath3 = CAShapeLayer()
        cart.addSublayer(cartpath3)
        layers["cartpath3"] = cartpath3
        let cartpath4 = CAShapeLayer()
        cart.addSublayer(cartpath4)
        layers["cartpath4"] = cartpath4
        let cartpath5 = CAShapeLayer()
        cart.addSublayer(cartpath5)
        layers["cartpath5"] = cartpath5
        let cartpath6 = CAShapeLayer()
        cart.addSublayer(cartpath6)
        layers["cartpath6"] = cartpath6
        let cartpath7 = CAShapeLayer()
        cart.addSublayer(cartpath7)
        layers["cartpath7"] = cartpath7
        let cartpath8 = CAShapeLayer()
        cart.addSublayer(cartpath8)
        layers["cartpath8"] = cartpath8
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("cartPath"){
            let cartPath = layers["cartPath"] as! CAShapeLayer
            cartPath.fillColor = self.fillColor.CGColor
            cartPath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartPath2"){
            let cartPath2 = layers["cartPath2"] as! CAShapeLayer
            cartPath2.fillColor = self.fillColor.CGColor
            cartPath2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartPath3"){
            let cartPath3 = layers["cartPath3"] as! CAShapeLayer
            cartPath3.fillColor = self.fillColor.CGColor
            cartPath3.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartPath4"){
            let cartPath4 = layers["cartPath4"] as! CAShapeLayer
            cartPath4.fillColor = self.fillColor.CGColor
            cartPath4.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath"){
            let cartpath = layers["cartpath"] as! CAShapeLayer
            cartpath.fillColor = self.fillColor.CGColor
            cartpath.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath2"){
            let cartpath2 = layers["cartpath2"] as! CAShapeLayer
            cartpath2.fillColor = self.fillColor.CGColor
            cartpath2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath3"){
            let cartpath3 = layers["cartpath3"] as! CAShapeLayer
            cartpath3.fillColor = self.fillColor.CGColor
            cartpath3.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath4"){
            let cartpath4 = layers["cartpath4"] as! CAShapeLayer
            cartpath4.fillColor = self.fillColor.CGColor
            cartpath4.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath5"){
            let cartpath5 = layers["cartpath5"] as! CAShapeLayer
            cartpath5.fillColor = self.fillColor.CGColor
            cartpath5.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath6"){
            let cartpath6 = layers["cartpath6"] as! CAShapeLayer
            cartpath6.fillColor = self.fillColor.CGColor
            cartpath6.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath7"){
            let cartpath7 = layers["cartpath7"] as! CAShapeLayer
            cartpath7.fillColor = self.fillColor.CGColor
            cartpath7.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("cartpath8"){
            let cartpath8 = layers["cartpath8"] as! CAShapeLayer
            cartpath8.fillColor = self.fillColor.CGColor
            cartpath8.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let cart : CALayer = layers["cart"] as? CALayer{
            cart.frame = CGRectMake(0.08061 * cart.superlayer!.bounds.width, 0.18218 * cart.superlayer!.bounds.height, 0.83878 * cart.superlayer!.bounds.width, 0.63564 * cart.superlayer!.bounds.height)
        }
        
        if let cartPath : CAShapeLayer = layers["cartPath"] as? CAShapeLayer{
            cartPath.frame = CGRectMake(0.74675 * cartPath.superlayer!.bounds.width, 0.79897 * cartPath.superlayer!.bounds.height, 0.15238 * cartPath.superlayer!.bounds.width, 0.20103 * cartPath.superlayer!.bounds.height)
            cartPath.path  = cartPathPathWithBounds((layers["cartPath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartPath2 : CAShapeLayer = layers["cartPath2"] as? CAShapeLayer{
            cartPath2.frame = CGRectMake(0.34549 * cartPath2.superlayer!.bounds.width, 0.69244 * cartPath2.superlayer!.bounds.height, 0.52834 * cartPath2.superlayer!.bounds.width, 0.09097 * cartPath2.superlayer!.bounds.height)
            cartPath2.path  = cartPath2PathWithBounds((layers["cartPath2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartPath3 : CAShapeLayer = layers["cartPath3"] as? CAShapeLayer{
            cartPath3.frame = CGRectMake(0.33047 * cartPath3.superlayer!.bounds.width, 0.2664 * cartPath3.superlayer!.bounds.height, 0.65433 * cartPath3.superlayer!.bounds.width, 0.14769 * cartPath3.superlayer!.bounds.height)
            cartPath3.path  = cartPath3PathWithBounds((layers["cartPath3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartPath4 : CAShapeLayer = layers["cartPath4"] as? CAShapeLayer{
            cartPath4.frame = CGRectMake(0.29518 * cartPath4.superlayer!.bounds.width, 0.26632 * cartPath4.superlayer!.bounds.height, 0.68968 * cartPath4.superlayer!.bounds.width, 0.04124 * cartPath4.superlayer!.bounds.height)
            cartPath4.path  = cartPath4PathWithBounds((layers["cartPath4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath : CAShapeLayer = layers["cartpath"] as? CAShapeLayer{
            cartpath.frame = CGRectMake(0.30778 * cartpath.superlayer!.bounds.width, 0.47947 * cartpath.superlayer!.bounds.height, 0.64681 * cartpath.superlayer!.bounds.width, 0.14772 * cartpath.superlayer!.bounds.height)
            cartpath.path  = cartpathPathWithBounds((layers["cartpath"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath2 : CAShapeLayer = layers["cartpath2"] as? CAShapeLayer{
            cartpath2.frame = CGRectMake(0, 0, 0.14789 * cartpath2.superlayer!.bounds.width, 0.04124 * cartpath2.superlayer!.bounds.height)
            cartpath2.path  = cartpath2PathWithBounds((layers["cartpath2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath3 : CAShapeLayer = layers["cartpath3"] as? CAShapeLayer{
            cartpath3.frame = CGRectMake(0.11664 * cartpath3.superlayer!.bounds.width, 0.00005 * cartpath3.superlayer!.bounds.height, 0.22238 * cartpath3.superlayer!.bounds.width, 0.62709 * cartpath3.superlayer!.bounds.height)
            cartpath3.path  = cartpath3PathWithBounds((layers["cartpath3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath4 : CAShapeLayer = layers["cartpath4"] as? CAShapeLayer{
            cartpath4.frame = CGRectMake(0.33055 * cartpath4.superlayer!.bounds.width, 0.37285 * cartpath4.superlayer!.bounds.height, 0.62401 * cartpath4.superlayer!.bounds.width, 0.14768 * cartpath4.superlayer!.bounds.height)
            cartpath4.path  = cartpath4PathWithBounds((layers["cartpath4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath5 : CAShapeLayer = layers["cartpath5"] as? CAShapeLayer{
            cartpath5.frame = CGRectMake(0.00005 * cartpath5.superlayer!.bounds.width, 0.00006 * cartpath5.superlayer!.bounds.height, 0.06648 * cartpath5.superlayer!.bounds.width, 0.14764 * cartpath5.superlayer!.bounds.height)
            cartpath5.path  = cartpath5PathWithBounds((layers["cartpath5"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath6 : CAShapeLayer = layers["cartpath6"] as? CAShapeLayer{
            cartpath6.frame = CGRectMake(0.25991 * cartpath6.superlayer!.bounds.width, 0.1598 * cartpath6.superlayer!.bounds.height, 0.74009 * cartpath6.superlayer!.bounds.width, 0.14772 * cartpath6.superlayer!.bounds.height)
            cartpath6.path  = cartpath6PathWithBounds((layers["cartpath6"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath7 : CAShapeLayer = layers["cartpath7"] as? CAShapeLayer{
            cartpath7.frame = CGRectMake(0.03532 * cartpath7.superlayer!.bounds.width, 0.10653 * cartpath7.superlayer!.bounds.height, 0.06937 * cartpath7.superlayer!.bounds.width, 0.04124 * cartpath7.superlayer!.bounds.height)
            cartpath7.path  = cartpath7PathWithBounds((layers["cartpath7"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let cartpath8 : CAShapeLayer = layers["cartpath8"] as? CAShapeLayer{
            cartpath8.frame = CGRectMake(0.22201 * cartpath8.superlayer!.bounds.width, 0.79897 * cartpath8.superlayer!.bounds.height, 0.15234 * cartpath8.superlayer!.bounds.width, 0.20103 * cartpath8.superlayer!.bounds.height)
            cartpath8.path  = cartpath8PathWithBounds((layers["cartpath8"] as! CAShapeLayer).bounds).CGPath;
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
    
    func cartPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartPathPath.moveToPoint(CGPointMake(minX + 0.49989 * w, minY))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.85345 * w, minY + 0.14636 * h), controlPoint1:CGPointMake(minX + 0.63789 * w, minY), controlPoint2:CGPointMake(minX + 0.76309 * w, minY + 0.05619 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.94383 * w, minY + 0.23675 * h), controlPoint2:CGPointMake(minX + w, minY + 0.36197 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.85345 * w, minY + 0.85364 * h), controlPoint1:CGPointMake(minX + w, minY + 0.63803 * h), controlPoint2:CGPointMake(minX + 0.94383 * w, minY + 0.76325 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.49989 * w, minY + h), controlPoint1:CGPointMake(minX + 0.76309 * w, minY + 0.94403 * h), controlPoint2:CGPointMake(minX + 0.63812 * w, minY + h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.14633 * w, minY + 0.85364 * h), controlPoint1:CGPointMake(minX + 0.36189 * w, minY + h), controlPoint2:CGPointMake(minX + 0.2367 * w, minY + 0.944 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.05595 * w, minY + 0.76326 * h), controlPoint2:CGPointMake(minX, minY + 0.63803 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.14633 * w, minY + 0.14636 * h), controlPoint1:CGPointMake(minX, minY + 0.36197 * h), controlPoint2:CGPointMake(minX + 0.05618 * w, minY + 0.23675 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.49989 * w, minY), controlPoint1:CGPointMake(minX + 0.2367 * w, minY + 0.05599 * h), controlPoint2:CGPointMake(minX + 0.36189 * w, minY))
        cartPathPath.addLineToPoint(CGPointMake(minX + 0.49989 * w, minY))
        cartPathPath.closePath()
        cartPathPath.moveToPoint(CGPointMake(minX + 0.70839 * w, minY + 0.29146 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.49989 * w, minY + 0.20513 * h), controlPoint1:CGPointMake(minX + 0.6552 * w, minY + 0.23825 * h), controlPoint2:CGPointMake(minX + 0.58127 * w, minY + 0.20513 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.2914 * w, minY + 0.29146 * h), controlPoint1:CGPointMake(minX + 0.41851 * w, minY + 0.20513 * h), controlPoint2:CGPointMake(minX + 0.3448 * w, minY + 0.23825 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.20509 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.23801 * w, minY + 0.34487 * h), controlPoint2:CGPointMake(minX + 0.20509 * w, minY + 0.4186 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.2914 * w, minY + 0.70854 * h), controlPoint1:CGPointMake(minX + 0.20509 * w, minY + 0.5814 * h), controlPoint2:CGPointMake(minX + 0.2382 * w, minY + 0.65513 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.49989 * w, minY + 0.79487 * h), controlPoint1:CGPointMake(minX + 0.34459 * w, minY + 0.76175 * h), controlPoint2:CGPointMake(minX + 0.41851 * w, minY + 0.79487 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.70839 * w, minY + 0.70854 * h), controlPoint1:CGPointMake(minX + 0.58127 * w, minY + 0.79487 * h), controlPoint2:CGPointMake(minX + 0.65499 * w, minY + 0.76175 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.7947 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.76159 * w, minY + 0.65513 * h), controlPoint2:CGPointMake(minX + 0.7947 * w, minY + 0.5814 * h))
        cartPathPath.addCurveToPoint(CGPointMake(minX + 0.70839 * w, minY + 0.29146 * h), controlPoint1:CGPointMake(minX + 0.7947 * w, minY + 0.4186 * h), controlPoint2:CGPointMake(minX + 0.76159 * w, minY + 0.34488 * h))
        cartPathPath.closePath()
        cartPathPath.moveToPoint(CGPointMake(minX + 0.70839 * w, minY + 0.29146 * h))
        
        return cartPathPath;
    }
    
    func cartPath2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartPath2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartPath2Path.moveToPoint(CGPointMake(minX + 0.05463 * w, minY + 0.89105 * h))
        cartPath2Path.addCurveToPoint(CGPointMake(minX + 0.01421 * w, minY + 0.96756 * h), controlPoint1:CGPointMake(minX + 0.04625 * w, minY + 0.99776 * h), controlPoint2:CGPointMake(minX + 0.02814 * w, minY + 1.03178 * h))
        cartPath2Path.addCurveToPoint(CGPointMake(minX + 0.00423 * w, minY + 0.65779 * h), controlPoint1:CGPointMake(minX + 0.00029 * w, minY + 0.90333 * h), controlPoint2:CGPointMake(minX + -0.00415 * w, minY + 0.76452 * h))
        cartPath2Path.addLineToPoint(CGPointMake(minX + 0.04761 * w, minY + 0.1105 * h))
        cartPath2Path.addCurveToPoint(CGPointMake(minX + 0.07281 * w, minY + 0.0019 * h), controlPoint1:CGPointMake(minX + 0.05315 * w, minY + 0.0406 * h), controlPoint2:CGPointMake(minX + 0.06282 * w, minY + 0.0019 * h))
        cartPath2Path.addLineToPoint(CGPointMake(minX + 0.07281 * w, minY))
        cartPath2Path.addLineToPoint(CGPointMake(minX + 0.97042 * w, minY))
        cartPath2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.22667 * h), controlPoint1:CGPointMake(minX + 0.98675 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.10152 * h))
        cartPath2Path.addCurveToPoint(CGPointMake(minX + 0.97042 * w, minY + 0.45332 * h), controlPoint1:CGPointMake(minX + w, minY + 0.35183 * h), controlPoint2:CGPointMake(minX + 0.98675 * w, minY + 0.45332 * h))
        cartPath2Path.addLineToPoint(CGPointMake(minX + 0.08926 * w, minY + 0.45332 * h))
        cartPath2Path.addLineToPoint(CGPointMake(minX + 0.05463 * w, minY + 0.89105 * h))
        cartPath2Path.closePath()
        cartPath2Path.moveToPoint(CGPointMake(minX + 0.05463 * w, minY + 0.89105 * h))
        
        return cartPath2Path;
    }
    
    func cartPath3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartPath3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartPath3Path.moveToPoint(CGPointMake(minX + 0.02388 * w, minY + h))
        cartPath3Path.addCurveToPoint(CGPointMake(minX, minY + 0.86038 * h), controlPoint1:CGPointMake(minX + 0.0107 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.93747 * h))
        cartPath3Path.addCurveToPoint(CGPointMake(minX + 0.02388 * w, minY + 0.72076 * h), controlPoint1:CGPointMake(minX, minY + 0.78329 * h), controlPoint2:CGPointMake(minX + 0.0107 * w, minY + 0.72076 * h))
        cartPath3Path.addLineToPoint(CGPointMake(minX + 0.93333 * w, minY + 0.72076 * h))
        cartPath3Path.addLineToPoint(CGPointMake(minX + 0.95279 * w, minY + 0.11374 * h))
        cartPath3Path.addCurveToPoint(CGPointMake(minX + 0.98055 * w, minY + 0.00235 * h), controlPoint1:CGPointMake(minX + 0.95517 * w, minY + 0.03812 * h), controlPoint2:CGPointMake(minX + 0.96766 * w, minY + -0.01161 * h))
        cartPath3Path.addCurveToPoint(CGPointMake(minX + 0.9996 * w, minY + 0.16464 * h), controlPoint1:CGPointMake(minX + 0.99348 * w, minY + 0.0163 * h), controlPoint2:CGPointMake(minX + 1.00199 * w, minY + 0.08932 * h))
        cartPath3Path.addLineToPoint(CGPointMake(minX + 0.97686 * w, minY + 0.87432 * h))
        cartPath3Path.addCurveToPoint(CGPointMake(minX + 0.95309 * w, minY + 0.99997 * h), controlPoint1:CGPointMake(minX + 0.97567 * w, minY + 0.94471 * h), controlPoint2:CGPointMake(minX + 0.96542 * w, minY + 0.99997 * h))
        cartPath3Path.addLineToPoint(CGPointMake(minX + 0.02388 * w, minY + 0.99997 * h))
        cartPath3Path.addLineToPoint(CGPointMake(minX + 0.02388 * w, minY + h))
        cartPath3Path.closePath()
        cartPath3Path.moveToPoint(CGPointMake(minX + 0.02388 * w, minY + h))
        
        return cartPath3Path;
    }
    
    func cartPath4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartPath4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartPath4Path.moveToPoint(CGPointMake(minX + 0.97734 * w, minY))
        cartPath4Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.98985 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22394 * h))
        cartPath4Path.addCurveToPoint(CGPointMake(minX + 0.97734 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77606 * h), controlPoint2:CGPointMake(minX + 0.98985 * w, minY + h))
        cartPath4Path.addLineToPoint(CGPointMake(minX + 0.02266 * w, minY + h))
        cartPath4Path.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.01015 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77606 * h))
        cartPath4Path.addCurveToPoint(CGPointMake(minX + 0.02266 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22394 * h), controlPoint2:CGPointMake(minX + 0.01015 * w, minY))
        cartPath4Path.addLineToPoint(CGPointMake(minX + 0.97734 * w, minY))
        cartPath4Path.closePath()
        cartPath4Path.moveToPoint(CGPointMake(minX + 0.97734 * w, minY))
        
        return cartPath4Path;
    }
    
    func cartpathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpathPath.moveToPoint(CGPointMake(minX + 0.02416 * w, minY + 0.99974 * h))
        cartpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.86015 * h), controlPoint1:CGPointMake(minX + 0.01082 * w, minY + 0.99974 * h), controlPoint2:CGPointMake(minX, minY + 0.93722 * h))
        cartpathPath.addCurveToPoint(CGPointMake(minX + 0.02416 * w, minY + 0.72058 * h), controlPoint1:CGPointMake(minX, minY + 0.78309 * h), controlPoint2:CGPointMake(minX + 0.01082 * w, minY + 0.72058 * h))
        cartpathPath.addLineToPoint(CGPointMake(minX + 0.93251 * w, minY + 0.72058 * h))
        cartpathPath.addLineToPoint(CGPointMake(minX + 0.95218 * w, minY + 0.11372 * h))
        cartpathPath.addCurveToPoint(CGPointMake(minX + 0.98032 * w, minY + 0.00235 * h), controlPoint1:CGPointMake(minX + 0.9546 * w, minY + 0.03811 * h), controlPoint2:CGPointMake(minX + 0.96723 * w, minY + -0.01161 * h))
        cartpathPath.addCurveToPoint(CGPointMake(minX + 0.99959 * w, minY + 0.1649 * h), controlPoint1:CGPointMake(minX + 0.9934 * w, minY + 0.0163 * h), controlPoint2:CGPointMake(minX + 1.00201 * w, minY + 0.0893 * h))
        cartpathPath.addLineToPoint(CGPointMake(minX + 0.9766 * w, minY + 0.87441 * h))
        cartpathPath.addCurveToPoint(CGPointMake(minX + 0.95254 * w, minY + h), controlPoint1:CGPointMake(minX + 0.97539 * w, minY + 0.94475 * h), controlPoint2:CGPointMake(minX + 0.96502 * w, minY + h))
        cartpathPath.addLineToPoint(CGPointMake(minX + 0.02416 * w, minY + h))
        cartpathPath.addLineToPoint(CGPointMake(minX + 0.02416 * w, minY + 0.99974 * h))
        cartpathPath.closePath()
        cartpathPath.moveToPoint(CGPointMake(minX + 0.02416 * w, minY + 0.99974 * h))
        
        return cartpathPath;
    }
    
    func cartpath2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath2Path.moveToPoint(CGPointMake(minX + 0.89434 * w, minY))
        cartpath2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.95267 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22394 * h))
        cartpath2Path.addCurveToPoint(CGPointMake(minX + 0.89434 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77606 * h), controlPoint2:CGPointMake(minX + 0.95268 * w, minY + h))
        cartpath2Path.addLineToPoint(CGPointMake(minX + 0.10566 * w, minY + h))
        cartpath2Path.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.04733 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77606 * h))
        cartpath2Path.addCurveToPoint(CGPointMake(minX + 0.10567 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.22394 * h), controlPoint2:CGPointMake(minX + 0.04733 * w, minY))
        cartpath2Path.addLineToPoint(CGPointMake(minX + 0.89434 * w, minY))
        cartpath2Path.closePath()
        cartpath2Path.moveToPoint(CGPointMake(minX + 0.89434 * w, minY))
        
        return cartpath2Path;
    }
    
    func cartpath3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath3Path.moveToPoint(CGPointMake(minX + 0.99432 * w, minY + 0.95418 * h))
        cartpath3Path.addCurveToPoint(CGPointMake(minX + 0.95758 * w, minY + 0.99734 * h), controlPoint1:CGPointMake(minX + 1.00954 * w, minY + 0.97083 * h), controlPoint2:CGPointMake(minX + 0.99314 * w, minY + 0.99022 * h))
        cartpath3Path.addCurveToPoint(CGPointMake(minX + 0.86536 * w, minY + 0.98015 * h), controlPoint1:CGPointMake(minX + 0.92201 * w, minY + 1.00446 * h), controlPoint2:CGPointMake(minX + 0.88058 * w, minY + 0.99679 * h))
        cartpath3Path.addLineToPoint(CGPointMake(minX + 0.00569 * w, minY + 0.04575 * h))
        cartpath3Path.addCurveToPoint(CGPointMake(minX + 0.04242 * w, minY + 0.00266 * h), controlPoint1:CGPointMake(minX + -0.00954 * w, minY + 0.0291 * h), controlPoint2:CGPointMake(minX + 0.00685 * w, minY + 0.00978 * h))
        cartpath3Path.addCurveToPoint(CGPointMake(minX + 0.13464 * w, minY + 0.01985 * h), controlPoint1:CGPointMake(minX + 0.07799 * w, minY + -0.00446 * h), controlPoint2:CGPointMake(minX + 0.11942 * w, minY + 0.00321 * h))
        cartpath3Path.addLineToPoint(CGPointMake(minX + 0.99432 * w, minY + 0.95418 * h))
        cartpath3Path.closePath()
        cartpath3Path.moveToPoint(CGPointMake(minX + 0.99432 * w, minY + 0.95418 * h))
        
        return cartpath3Path;
    }
    
    func cartpath4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath4Path.moveToPoint(CGPointMake(minX + 0.97506 * w, minY + 0.72196 * h))
        cartpath4Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.86098 * h), controlPoint1:CGPointMake(minX + 0.98884 * w, minY + 0.72196 * h), controlPoint2:CGPointMake(minX + w, minY + 0.7842 * h))
        cartpath4Path.addCurveToPoint(CGPointMake(minX + 0.97506 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.93778 * h), controlPoint2:CGPointMake(minX + 0.98883 * w, minY + h))
        cartpath4Path.addLineToPoint(CGPointMake(minX + 0.08157 * w, minY + 0.99969 * h))
        cartpath4Path.addCurveToPoint(CGPointMake(minX + 0.05872 * w, minY + 0.91621 * h), controlPoint1:CGPointMake(minX + 0.07134 * w, minY + 0.99969 * h), controlPoint2:CGPointMake(minX + 0.06253 * w, minY + 0.96537 * h))
        cartpath4Path.addLineToPoint(CGPointMake(minX + 0.05867 * w, minY + 0.91621 * h))
        cartpath4Path.addLineToPoint(CGPointMake(minX + 0.00207 * w, minY + 0.19489 * h))
        cartpath4Path.addCurveToPoint(CGPointMake(minX + 0.015 * w, minY + 0.01164 * h), controlPoint1:CGPointMake(minX + -0.00341 * w, minY + 0.1245 * h), controlPoint2:CGPointMake(minX + 0.00238 * w, minY + 0.04248 * h))
        cartpath4Path.addCurveToPoint(CGPointMake(minX + 0.04787 * w, minY + 0.08377 * h), controlPoint1:CGPointMake(minX + 0.02763 * w, minY + -0.01919 * h), controlPoint2:CGPointMake(minX + 0.04234 * w, minY + 0.01339 * h))
        cartpath4Path.addLineToPoint(CGPointMake(minX + 0.09795 * w, minY + 0.72162 * h))
        cartpath4Path.addLineToPoint(CGPointMake(minX + 0.97506 * w, minY + 0.72196 * h))
        cartpath4Path.closePath()
        cartpath4Path.moveToPoint(CGPointMake(minX + 0.97506 * w, minY + 0.72196 * h))
        
        return cartpath4Path;
    }
    
    func cartpath5PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath5Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath5Path.moveToPoint(CGPointMake(minX + 0.98061 * w, minY + 0.80519 * h))
        cartpath5Path.addCurveToPoint(CGPointMake(minX + 0.85918 * w, minY + 0.98848 * h), controlPoint1:CGPointMake(minX + 1.03203 * w, minY + 0.87559 * h), controlPoint2:CGPointMake(minX + 0.97766 * w, minY + 0.95764 * h))
        cartpath5Path.addCurveToPoint(CGPointMake(minX + 0.55068 * w, minY + 0.91634 * h), controlPoint1:CGPointMake(minX + 0.74069 * w, minY + 1.01903 * h), controlPoint2:CGPointMake(minX + 0.6026 * w, minY + 0.98673 * h))
        cartpath5Path.addLineToPoint(CGPointMake(minX + 0.01939 * w, minY + 0.19481 * h))
        cartpath5Path.addCurveToPoint(CGPointMake(minX + 0.14082 * w, minY + 0.01152 * h), controlPoint1:CGPointMake(minX + -0.03203 * w, minY + 0.12441 * h), controlPoint2:CGPointMake(minX + 0.02234 * w, minY + 0.04236 * h))
        cartpath5Path.addCurveToPoint(CGPointMake(minX + 0.44932 * w, minY + 0.08366 * h), controlPoint1:CGPointMake(minX + 0.25931 * w, minY + -0.01903 * h), controlPoint2:CGPointMake(minX + 0.3974 * w, minY + 0.01327 * h))
        cartpath5Path.addLineToPoint(CGPointMake(minX + 0.98061 * w, minY + 0.80519 * h))
        cartpath5Path.closePath()
        cartpath5Path.moveToPoint(CGPointMake(minX + 0.98061 * w, minY + 0.80519 * h))
        
        return cartpath5Path;
    }
    
    func cartpath6PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath6Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath6Path.moveToPoint(CGPointMake(minX + 0.08808 * w, minY + 0.80517 * h))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + 0.07717 * w, minY + 0.98836 * h), controlPoint1:CGPointMake(minX + 0.0927 * w, minY + 0.87553 * h), controlPoint2:CGPointMake(minX + 0.08782 * w, minY + 0.95753 * h))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + 0.04946 * w, minY + 0.91626 * h), controlPoint1:CGPointMake(minX + 0.06653 * w, minY + 1.01919 * h), controlPoint2:CGPointMake(minX + 0.05413 * w, minY + 0.98661 * h))
        cartpath6Path.addLineToPoint(CGPointMake(minX + 0.00174 * w, minY + 0.19512 * h))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + 0.01265 * w, minY + 0.01193 * h), controlPoint1:CGPointMake(minX + -0.00288 * w, minY + 0.12475 * h), controlPoint2:CGPointMake(minX + 0.00201 * w, minY + 0.04246 * h))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + 0.02105 * w, minY + 0.00029 * h), controlPoint1:CGPointMake(minX + 0.01538 * w, minY + 0.00407 * h), controlPoint2:CGPointMake(minX + 0.01824 * w, minY + 0.00029 * h))
        cartpath6Path.addLineToPoint(CGPointMake(minX + 0.02105 * w, minY))
        cartpath6Path.addLineToPoint(CGPointMake(minX + 0.97889 * w, minY))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.13958 * h), controlPoint1:CGPointMake(minX + 0.99054 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.06281 * h))
        cartpath6Path.addCurveToPoint(CGPointMake(minX + 0.97889 * w, minY + 0.27917 * h), controlPoint1:CGPointMake(minX + w, minY + 0.21664 * h), controlPoint2:CGPointMake(minX + 0.99054 * w, minY + 0.27917 * h))
        cartpath6Path.addLineToPoint(CGPointMake(minX + 0.05325 * w, minY + 0.27917 * h))
        cartpath6Path.addLineToPoint(CGPointMake(minX + 0.08808 * w, minY + 0.80517 * h))
        cartpath6Path.closePath()
        cartpath6Path.moveToPoint(CGPointMake(minX + 0.08808 * w, minY + 0.80517 * h))
        
        return cartpath6Path;
    }
    
    func cartpath7PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath7Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath7Path.moveToPoint(CGPointMake(minX + 0.77474 * w, minY))
        cartpath7Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.49997 * h), controlPoint1:CGPointMake(minX + 0.89909 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22395 * h))
        cartpath7Path.addCurveToPoint(CGPointMake(minX + 0.77474 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77605 * h), controlPoint2:CGPointMake(minX + 0.89911 * w, minY + h))
        cartpath7Path.addLineToPoint(CGPointMake(minX + 0.22526 * w, minY + h))
        cartpath7Path.addCurveToPoint(CGPointMake(minX, minY + 0.49997 * h), controlPoint1:CGPointMake(minX + 0.10091 * w, minY + h), controlPoint2:CGPointMake(minX, minY + 0.77605 * h))
        cartpath7Path.addCurveToPoint(CGPointMake(minX + 0.22526 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.2239 * h), controlPoint2:CGPointMake(minX + 0.10089 * w, minY))
        cartpath7Path.addLineToPoint(CGPointMake(minX + 0.77474 * w, minY))
        cartpath7Path.closePath()
        cartpath7Path.moveToPoint(CGPointMake(minX + 0.77474 * w, minY))
        
        return cartpath7Path;
    }
    
    func cartpath8PathWithBounds(bound: CGRect) -> UIBezierPath{
        let cartpath8Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        cartpath8Path.moveToPoint(CGPointMake(minX + 0.5 * w, minY))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.85364 * w, minY + 0.14636 * h), controlPoint1:CGPointMake(minX + 0.63804 * w, minY), controlPoint2:CGPointMake(minX + 0.76325 * w, minY + 0.05619 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.94402 * w, minY + 0.23675 * h), controlPoint2:CGPointMake(minX + w, minY + 0.36197 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.85364 * w, minY + 0.85364 * h), controlPoint1:CGPointMake(minX + w, minY + 0.63803 * h), controlPoint2:CGPointMake(minX + 0.94401 * w, minY + 0.76325 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + 0.76326 * w, minY + 0.94403 * h), controlPoint2:CGPointMake(minX + 0.63804 * w, minY + h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.14636 * w, minY + 0.85364 * h), controlPoint1:CGPointMake(minX + 0.36196 * w, minY + h), controlPoint2:CGPointMake(minX + 0.23675 * w, minY + 0.944 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.05598 * w, minY + 0.76326 * h), controlPoint2:CGPointMake(minX, minY + 0.63803 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.14636 * w, minY + 0.14636 * h), controlPoint1:CGPointMake(minX, minY + 0.36197 * h), controlPoint2:CGPointMake(minX + 0.05599 * w, minY + 0.23675 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + 0.23674 * w, minY + 0.05598 * h), controlPoint2:CGPointMake(minX + 0.36197 * w, minY))
        cartpath8Path.addLineToPoint(CGPointMake(minX + 0.5 * w, minY))
        cartpath8Path.closePath()
        cartpath8Path.moveToPoint(CGPointMake(minX + 0.70855 * w, minY + 0.29146 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.20513 * h), controlPoint1:CGPointMake(minX + 0.65514 * w, minY + 0.23825 * h), controlPoint2:CGPointMake(minX + 0.58141 * w, minY + 0.20513 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.29145 * w, minY + 0.29146 * h), controlPoint1:CGPointMake(minX + 0.41859 * w, minY + 0.20513 * h), controlPoint2:CGPointMake(minX + 0.34487 * w, minY + 0.23825 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.20513 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.23825 * w, minY + 0.34487 * h), controlPoint2:CGPointMake(minX + 0.20513 * w, minY + 0.4186 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.29145 * w, minY + 0.70854 * h), controlPoint1:CGPointMake(minX + 0.20513 * w, minY + 0.5814 * h), controlPoint2:CGPointMake(minX + 0.23825 * w, minY + 0.65513 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + 0.79487 * h), controlPoint1:CGPointMake(minX + 0.34486 * w, minY + 0.76175 * h), controlPoint2:CGPointMake(minX + 0.41859 * w, minY + 0.79487 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.70855 * w, minY + 0.70854 * h), controlPoint1:CGPointMake(minX + 0.58141 * w, minY + 0.79487 * h), controlPoint2:CGPointMake(minX + 0.65513 * w, minY + 0.76175 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.79487 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.76175 * w, minY + 0.65513 * h), controlPoint2:CGPointMake(minX + 0.79487 * w, minY + 0.5814 * h))
        cartpath8Path.addCurveToPoint(CGPointMake(minX + 0.70855 * w, minY + 0.29146 * h), controlPoint1:CGPointMake(minX + 0.79487 * w, minY + 0.4186 * h), controlPoint2:CGPointMake(minX + 0.76176 * w, minY + 0.34488 * h))
        cartpath8Path.closePath()
        cartpath8Path.moveToPoint(CGPointMake(minX + 0.70855 * w, minY + 0.29146 * h))
        
        return cartpath8Path;
    }
    
    
}
