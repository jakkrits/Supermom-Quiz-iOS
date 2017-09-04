//
//  GearIcon.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/10/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//
import UIKit

@IBDesignable
class GearIcon: UIView {
    
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
        self.fillColor = ThemeColor.NavBarTintColor
    }
    
    func setupLayers(){
        let path2 = CAShapeLayer()
        self.layer.addSublayer(path2)
        layers["path2"] = path2
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("path2"){
            let path2 = layers["path2"] as! CAShapeLayer
            path2.fillColor = self.fillColor.CGColor
            path2.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
            path2.frame = CGRectMake(0.08006 * path2.superlayer!.bounds.width, 0.08006 * path2.superlayer!.bounds.height, 0.83988 * path2.superlayer!.bounds.width, 0.83988 * path2.superlayer!.bounds.height)
            path2.path  = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).CGPath;
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
    
    func path2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path2Path.moveToPoint(CGPointMake(minX + 0.56043 * w, minY + h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.43955 * w, minY + h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.39304 * w, minY + 0.95793 * h), controlPoint1:CGPointMake(minX + 0.41541 * w, minY + h), controlPoint2:CGPointMake(minX + 0.39542 * w, minY + 0.98191 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.38065 * w, minY + 0.88367 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.31313 * w, minY + 0.85566 * h), controlPoint1:CGPointMake(minX + 0.35736 * w, minY + 0.87643 * h), controlPoint2:CGPointMake(minX + 0.33474 * w, minY + 0.86703 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.25093 * w, minY + 0.90008 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.22222 * w, minY + 0.91001 * h), controlPoint1:CGPointMake(minX + 0.2435 * w, minY + 0.90624 * h), controlPoint2:CGPointMake(minX + 0.23299 * w, minY + 0.91001 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.18915 * w, minY + 0.8963 * h), controlPoint1:CGPointMake(minX + 0.20972 * w, minY + 0.91001 * h), controlPoint2:CGPointMake(minX + 0.19799 * w, minY + 0.90514 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.10369 * w, minY + 0.81083 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.10058 * w, minY + 0.74816 * h), controlPoint1:CGPointMake(minX + 0.08662 * w, minY + 0.79376 * h), controlPoint2:CGPointMake(minX + 0.0853 * w, minY + 0.76683 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.14434 * w, minY + 0.68687 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.11633 * w, minY + 0.61937 * h), controlPoint1:CGPointMake(minX + 0.13293 * w, minY + 0.66522 * h), controlPoint2:CGPointMake(minX + 0.12355 * w, minY + 0.64258 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.04098 * w, minY + 0.60679 * h))
        path2Path.addCurveToPoint(CGPointMake(minX, minY + 0.56043 * h), controlPoint1:CGPointMake(minX + 0.01811 * w, minY + 0.6046 * h), controlPoint2:CGPointMake(minX, minY + 0.5846 * h))
        path2Path.addLineToPoint(CGPointMake(minX, minY + 0.43957 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.04207 * w, minY + 0.39304 * h), controlPoint1:CGPointMake(minX, minY + 0.41543 * h), controlPoint2:CGPointMake(minX + 0.01809 * w, minY + 0.39544 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.11633 * w, minY + 0.38061 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.14432 * w, minY + 0.31313 * h), controlPoint1:CGPointMake(minX + 0.12358 * w, minY + 0.3573 * h), controlPoint2:CGPointMake(minX + 0.13298 * w, minY + 0.33468 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.09992 * w, minY + 0.25093 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.10369 * w, minY + 0.18918 * h), controlPoint1:CGPointMake(minX + 0.08528 * w, minY + 0.23317 * h), controlPoint2:CGPointMake(minX + 0.0866 * w, minY + 0.20624 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.18917 * w, minY + 0.10369 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.25179 * w, minY + 0.10055 * h), controlPoint1:CGPointMake(minX + 0.20564 * w, minY + 0.08725 * h), controlPoint2:CGPointMake(minX + 0.23385 * w, minY + 0.08588 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.31316 * w, minY + 0.14432 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.38065 * w, minY + 0.11633 * h), controlPoint1:CGPointMake(minX + 0.33469 * w, minY + 0.13297 * h), controlPoint2:CGPointMake(minX + 0.35732 * w, minY + 0.12358 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.39319 * w, minY + 0.041 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.43957 * w, minY), controlPoint1:CGPointMake(minX + 0.39542 * w, minY + 0.01809 * h), controlPoint2:CGPointMake(minX + 0.41543 * w, minY))
        path2Path.addLineToPoint(CGPointMake(minX + 0.56044 * w, minY))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.60698 * w, minY + 0.04204 * h), controlPoint1:CGPointMake(minX + 0.58455 * w, minY), controlPoint2:CGPointMake(minX + 0.60455 * w, minY + 0.01808 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.61939 * w, minY + 0.11633 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.68685 * w, minY + 0.14432 * h), controlPoint1:CGPointMake(minX + 0.64269 * w, minY + 0.12358 * h), controlPoint2:CGPointMake(minX + 0.66531 * w, minY + 0.13297 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.74907 * w, minY + 0.09991 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.77777 * w, minY + 0.09001 * h), controlPoint1:CGPointMake(minX + 0.75649 * w, minY + 0.09376 * h), controlPoint2:CGPointMake(minX + 0.767 * w, minY + 0.09001 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.81082 * w, minY + 0.10369 * h), controlPoint1:CGPointMake(minX + 0.79026 * w, minY + 0.09001 * h), controlPoint2:CGPointMake(minX + 0.80199 * w, minY + 0.09486 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.89628 * w, minY + 0.18918 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.89945 * w, minY + 0.25179 * h), controlPoint1:CGPointMake(minX + 0.91333 * w, minY + 0.20619 * h), controlPoint2:CGPointMake(minX + 0.9147 * w, minY + 0.2331 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.85568 * w, minY + 0.31313 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.88367 * w, minY + 0.38061 * h), controlPoint1:CGPointMake(minX + 0.86705 * w, minY + 0.33468 * h), controlPoint2:CGPointMake(minX + 0.87642 * w, minY + 0.3573 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.95902 * w, minY + 0.39319 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.43957 * h), controlPoint1:CGPointMake(minX + 0.98192 * w, minY + 0.39544 * h), controlPoint2:CGPointMake(minX + w, minY + 0.41543 * h))
        path2Path.addLineToPoint(CGPointMake(minX + w, minY + 0.56043 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.9579 * w, minY + 0.60691 * h), controlPoint1:CGPointMake(minX + w, minY + 0.5846 * h), controlPoint2:CGPointMake(minX + 0.98191 * w, minY + 0.60458 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.88367 * w, minY + 0.61932 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.85568 * w, minY + 0.68683 * h), controlPoint1:CGPointMake(minX + 0.87642 * w, minY + 0.64265 * h), controlPoint2:CGPointMake(minX + 0.86703 * w, minY + 0.66529 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.90009 * w, minY + 0.74902 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.89626 * w, minY + 0.81082 * h), controlPoint1:CGPointMake(minX + 0.91472 * w, minY + 0.76684 * h), controlPoint2:CGPointMake(minX + 0.91335 * w, minY + 0.7938 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.81082 * w, minY + 0.89626 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.74814 * w, minY + 0.89938 * h), controlPoint1:CGPointMake(minX + 0.79441 * w, minY + 0.91269 * h), controlPoint2:CGPointMake(minX + 0.76613 * w, minY + 0.91414 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.68685 * w, minY + 0.85564 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.61939 * w, minY + 0.88365 * h), controlPoint1:CGPointMake(minX + 0.66524 * w, minY + 0.86703 * h), controlPoint2:CGPointMake(minX + 0.64262 * w, minY + 0.87643 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.60679 * w, minY + 0.95902 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.56043 * w, minY + h), controlPoint1:CGPointMake(minX + 0.60455 * w, minY + 0.98191 * h), controlPoint2:CGPointMake(minX + 0.58455 * w, minY + h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + 0.31194 * w, minY + 0.81967 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.32002 * w, minY + 0.82179 * h), controlPoint1:CGPointMake(minX + 0.31472 * w, minY + 0.81967 * h), controlPoint2:CGPointMake(minX + 0.31751 * w, minY + 0.82037 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.39975 * w, minY + 0.85487 * h), controlPoint1:CGPointMake(minX + 0.3452 * w, minY + 0.8359 * h), controlPoint2:CGPointMake(minX + 0.372 * w, minY + 0.84702 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.41155 * w, minY + 0.86806 * h), controlPoint1:CGPointMake(minX + 0.4059 * w, minY + 0.8566 * h), controlPoint2:CGPointMake(minX + 0.41049 * w, minY + 0.86174 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.42577 * w, minY + 0.95358 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.43955 * w, minY + 0.96695 * h), controlPoint1:CGPointMake(minX + 0.4266 * w, minY + 0.96155 * h), controlPoint2:CGPointMake(minX + 0.4326 * w, minY + 0.96695 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.56043 * w, minY + 0.96695 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.57404 * w, minY + 0.95467 * h), controlPoint1:CGPointMake(minX + 0.56738 * w, minY + 0.96695 * h), controlPoint2:CGPointMake(minX + 0.57337 * w, minY + 0.96157 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.58847 * w, minY + 0.86806 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.60027 * w, minY + 0.85489 * h), controlPoint1:CGPointMake(minX + 0.58951 * w, minY + 0.86176 * h), controlPoint2:CGPointMake(minX + 0.59412 * w, minY + 0.85662 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.67995 * w, minY + 0.8218 * h), controlPoint1:CGPointMake(minX + 0.62794 * w, minY + 0.84705 * h), controlPoint2:CGPointMake(minX + 0.65475 * w, minY + 0.83593 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.69763 * w, minY + 0.82278 * h), controlPoint1:CGPointMake(minX + 0.68551 * w, minY + 0.81867 * h), controlPoint2:CGPointMake(minX + 0.69242 * w, minY + 0.81905 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.7682 * w, minY + 0.87319 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.7874 * w, minY + 0.87293 * h), controlPoint1:CGPointMake(minX + 0.77532 * w, minY + 0.87893 * h), controlPoint2:CGPointMake(minX + 0.78258 * w, minY + 0.87774 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.87288 * w, minY + 0.78745 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.87384 * w, minY + 0.76909 * h), controlPoint1:CGPointMake(minX + 0.8779 * w, minY + 0.78245 * h), controlPoint2:CGPointMake(minX + 0.8783 * w, minY + 0.77456 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.82275 * w, minY + 0.69766 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.82177 * w, minY + 0.67996 * h), controlPoint1:CGPointMake(minX + 0.81901 * w, minY + 0.69245 * h), controlPoint2:CGPointMake(minX + 0.81865 * w, minY + 0.68557 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.85482 * w, minY + 0.60028 * h), controlPoint1:CGPointMake(minX + 0.83588 * w, minY + 0.65488 * h), controlPoint2:CGPointMake(minX + 0.84699 * w, minY + 0.62808 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.86802 * w, minY + 0.58847 * h), controlPoint1:CGPointMake(minX + 0.85655 * w, minY + 0.59412 * h), controlPoint2:CGPointMake(minX + 0.86169 * w, minY + 0.58953 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.95357 * w, minY + 0.57421 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.96693 * w, minY + 0.56046 * h), controlPoint1:CGPointMake(minX + 0.96153 * w, minY + 0.57338 * h), controlPoint2:CGPointMake(minX + 0.96693 * w, minY + 0.56742 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.96693 * w, minY + 0.4396 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.95466 * w, minY + 0.42597 * h), controlPoint1:CGPointMake(minX + 0.96693 * w, minY + 0.43265 * h), controlPoint2:CGPointMake(minX + 0.96155 * w, minY + 0.42665 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.86804 * w, minY + 0.41156 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.85483 * w, minY + 0.39975 * h), controlPoint1:CGPointMake(minX + 0.86171 * w, minY + 0.41051 * h), controlPoint2:CGPointMake(minX + 0.85658 * w, minY + 0.40591 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.82179 * w, minY + 0.3201 * h), controlPoint1:CGPointMake(minX + 0.847 * w, minY + 0.37196 * h), controlPoint2:CGPointMake(minX + 0.83588 * w, minY + 0.34515 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.82276 * w, minY + 0.30241 * h), controlPoint1:CGPointMake(minX + 0.81866 * w, minY + 0.3145 * h), controlPoint2:CGPointMake(minX + 0.81903 * w, minY + 0.30761 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.87321 * w, minY + 0.2318 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.87291 * w, minY + 0.21263 * h), controlPoint1:CGPointMake(minX + 0.87832 * w, minY + 0.22549 * h), controlPoint2:CGPointMake(minX + 0.8779 * w, minY + 0.21762 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.78743 * w, minY + 0.12712 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.76913 * w, minY + 0.12618 * h), controlPoint1:CGPointMake(minX + 0.78263 * w, minY + 0.12231 * h), controlPoint2:CGPointMake(minX + 0.77435 * w, minY + 0.1219 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.69764 * w, minY + 0.17729 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.67996 * w, minY + 0.17826 * h), controlPoint1:CGPointMake(minX + 0.69244 * w, minY + 0.18102 * h), controlPoint2:CGPointMake(minX + 0.68553 * w, minY + 0.18138 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.60028 * w, minY + 0.14518 * h), controlPoint1:CGPointMake(minX + 0.65486 * w, minY + 0.16417 * h), controlPoint2:CGPointMake(minX + 0.62806 * w, minY + 0.15305 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.58849 * w, minY + 0.13199 * h), controlPoint1:CGPointMake(minX + 0.59414 * w, minY + 0.14346 * h), controlPoint2:CGPointMake(minX + 0.58954 * w, minY + 0.13831 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.57424 * w, minY + 0.04647 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.56043 * w, minY + 0.03305 * h), controlPoint1:CGPointMake(minX + 0.57337 * w, minY + 0.03833 * h), controlPoint2:CGPointMake(minX + 0.5675 * w, minY + 0.03305 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.43955 * w, minY + 0.03305 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.42592 * w, minY + 0.04533 * h), controlPoint1:CGPointMake(minX + 0.43247 * w, minY + 0.03305 * h), controlPoint2:CGPointMake(minX + 0.42662 * w, minY + 0.03832 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.41155 * w, minY + 0.13193 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.39975 * w, minY + 0.14511 * h), controlPoint1:CGPointMake(minX + 0.4105 * w, minY + 0.13824 * h), controlPoint2:CGPointMake(minX + 0.4059 * w, minY + 0.14338 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.32009 * w, minY + 0.1782 * h), controlPoint1:CGPointMake(minX + 0.37192 * w, minY + 0.153 * h), controlPoint2:CGPointMake(minX + 0.34512 * w, minY + 0.1641 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.30239 * w, minY + 0.17722 * h), controlPoint1:CGPointMake(minX + 0.31447 * w, minY + 0.18132 * h), controlPoint2:CGPointMake(minX + 0.30758 * w, minY + 0.18096 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.23175 * w, minY + 0.12677 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.21255 * w, minY + 0.12707 * h), controlPoint1:CGPointMake(minX + 0.22464 * w, minY + 0.12109 * h), controlPoint2:CGPointMake(minX + 0.21736 * w, minY + 0.12223 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.12707 * w, minY + 0.21255 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.12616 * w, minY + 0.23084 * h), controlPoint1:CGPointMake(minX + 0.12208 * w, minY + 0.21754 * h), controlPoint2:CGPointMake(minX + 0.1217 * w, minY + 0.22541 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.17724 * w, minY + 0.30234 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.17821 * w, minY + 0.32004 * h), controlPoint1:CGPointMake(minX + 0.18097 * w, minY + 0.30756 * h), controlPoint2:CGPointMake(minX + 0.18133 * w, minY + 0.31445 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.14513 * w, minY + 0.3997 * h), controlPoint1:CGPointMake(minX + 0.16413 * w, minY + 0.34509 * h), controlPoint2:CGPointMake(minX + 0.15301 * w, minY + 0.37189 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.13194 * w, minY + 0.4115 * h), controlPoint1:CGPointMake(minX + 0.14341 * w, minY + 0.40585 * h), controlPoint2:CGPointMake(minX + 0.13826 * w, minY + 0.41044 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.04642 * w, minY + 0.42576 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.03305 * w, minY + 0.43958 * h), controlPoint1:CGPointMake(minX + 0.03832 * w, minY + 0.42662 * h), controlPoint2:CGPointMake(minX + 0.03305 * w, minY + 0.43249 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.03305 * w, minY + 0.56043 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.04529 * w, minY + 0.57403 * h), controlPoint1:CGPointMake(minX + 0.03305 * w, minY + 0.5675 * h), controlPoint2:CGPointMake(minX + 0.0383 * w, minY + 0.57335 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.13193 * w, minY + 0.58844 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.14511 * w, minY + 0.60025 * h), controlPoint1:CGPointMake(minX + 0.13824 * w, minY + 0.58948 * h), controlPoint2:CGPointMake(minX + 0.14338 * w, minY + 0.59409 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.1782 * w, minY + 0.67996 * h), controlPoint1:CGPointMake(minX + 0.15293 * w, minY + 0.6279 * h), controlPoint2:CGPointMake(minX + 0.16405 * w, minY + 0.65472 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.17722 * w, minY + 0.69763 * h), controlPoint1:CGPointMake(minX + 0.18132 * w, minY + 0.68555 * h), controlPoint2:CGPointMake(minX + 0.18096 * w, minY + 0.69242 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.12681 * w, minY + 0.7682 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.12705 * w, minY + 0.78742 * h), controlPoint1:CGPointMake(minX + 0.12165 * w, minY + 0.77455 * h), controlPoint2:CGPointMake(minX + 0.12205 * w, minY + 0.78241 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.21253 * w, minY + 0.87288 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.23084 * w, minY + 0.87382 * h), controlPoint1:CGPointMake(minX + 0.21739 * w, minY + 0.87772 * h), controlPoint2:CGPointMake(minX + 0.22564 * w, minY + 0.87815 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.30232 * w, minY + 0.82275 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.31194 * w, minY + 0.81967 * h), controlPoint1:CGPointMake(minX + 0.3052 * w, minY + 0.82071 * h), controlPoint2:CGPointMake(minX + 0.30857 * w, minY + 0.81967 * h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.69779 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.30217 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.39092 * w, minY + 0.69779 * h), controlPoint2:CGPointMake(minX + 0.30217 * w, minY + 0.60906 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.30214 * h), controlPoint1:CGPointMake(minX + 0.30217 * w, minY + 0.39089 * h), controlPoint2:CGPointMake(minX + 0.39092 * w, minY + 0.30214 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.69784 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.60911 * w, minY + 0.30214 * h), controlPoint2:CGPointMake(minX + 0.69784 * w, minY + 0.39089 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.69779 * h), controlPoint1:CGPointMake(minX + 0.69783 * w, minY + 0.60904 * h), controlPoint2:CGPointMake(minX + 0.60909 * w, minY + 0.69779 * h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.33519 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.33522 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.40915 * w, minY + 0.33519 * h), controlPoint2:CGPointMake(minX + 0.33522 * w, minY + 0.40912 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.66474 * h), controlPoint1:CGPointMake(minX + 0.33522 * w, minY + 0.59083 * h), controlPoint2:CGPointMake(minX + 0.40915 * w, minY + 0.66474 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.66479 * w, minY + 0.49998 * h), controlPoint1:CGPointMake(minX + 0.59087 * w, minY + 0.66474 * h), controlPoint2:CGPointMake(minX + 0.66479 * w, minY + 0.59083 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.33519 * h), controlPoint1:CGPointMake(minX + 0.66478 * w, minY + 0.40912 * h), controlPoint2:CGPointMake(minX + 0.59086 * w, minY + 0.33519 * h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + 0.50002 * w, minY + 0.33519 * h))
        
        return path2Path;
    }
    
    
}

