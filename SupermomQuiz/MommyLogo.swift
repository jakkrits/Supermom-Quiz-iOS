//
//  MommyLogo.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/10/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//
import UIKit

@IBDesignable
class MommyLogo: UIView {
    
    var updateLayerValueForCompletedAnimation : Bool = true
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var layers : Dictionary<String, AnyObject> = [:]
    let fillColor = ThemeColor.MainLogoColor
    
    //
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
        
    }
    
    func setupLayers(){
        let mommyLogo = CALayer()
        self.layer.addSublayer(mommyLogo)
        
        layers["mommyLogo"] = mommyLogo
        let hair = CAShapeLayer()
        mommyLogo.addSublayer(hair)
        hair.fillColor = self.fillColor.CGColor
        hair.lineWidth = 0
        layers["hair"] = hair
        let frontHair = CAShapeLayer()
        mommyLogo.addSublayer(frontHair)
        frontHair.fillColor = self.fillColor.CGColor
        frontHair.lineWidth = 0
        layers["frontHair"] = frontHair
        let body = CAShapeLayer()
        mommyLogo.addSublayer(body)
        body.fillColor   = self.fillColor.CGColor
        body.strokeColor = UIColor(red:1, green: 0.996, blue:0.989, alpha:1).CGColor
        body.lineWidth   = 6
        layers["body"] = body
        let eye = CAShapeLayer()
        mommyLogo.addSublayer(eye)
        eye.fillColor = self.fillColor.CGColor
        eye.lineWidth = 0
        layers["eye"] = eye
        let arm = CAShapeLayer()
        mommyLogo.addSublayer(arm)
        arm.fillColor = self.fillColor.CGColor
        arm.lineWidth = 0
        layers["arm"] = arm
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let mommyLogo : CALayer = layers["mommyLogo"] as? CALayer{
            mommyLogo.frame = CGRectMake(0.17453 * mommyLogo.superlayer!.bounds.width, 0.03175 * mommyLogo.superlayer!.bounds.height, 0.65488 * mommyLogo.superlayer!.bounds.width, 0.94049 * mommyLogo.superlayer!.bounds.height)
        }
        
        if let hair : CAShapeLayer = layers["hair"] as? CAShapeLayer{
            hair.frame = CGRectMake(0.11201 * hair.superlayer!.bounds.width, 0, 0.68346 * hair.superlayer!.bounds.width, 0.35772 * hair.superlayer!.bounds.height)
            hair.path  = hairPathWithBounds((layers["hair"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let frontHair : CAShapeLayer = layers["frontHair"] as? CAShapeLayer{
            frontHair.frame = CGRectMake(0.37301 * frontHair.superlayer!.bounds.width, 0.18098 * frontHair.superlayer!.bounds.height, 0.30213 * frontHair.superlayer!.bounds.width, 0.24933 * frontHair.superlayer!.bounds.height)
            frontHair.path  = frontHairPathWithBounds((layers["frontHair"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let body : CAShapeLayer = layers["body"] as? CAShapeLayer{
            body.frame = CGRectMake(0, 0.25318 * body.superlayer!.bounds.height,  body.superlayer!.bounds.width, 0.74682 * body.superlayer!.bounds.height)
            body.path  = bodyPathWithBounds((layers["body"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let eye : CAShapeLayer = layers["eye"] as? CAShapeLayer{
            eye.frame = CGRectMake(0.47442 * eye.superlayer!.bounds.width, 0.3545 * eye.superlayer!.bounds.height, 0.08051 * eye.superlayer!.bounds.width, 0.03345 * eye.superlayer!.bounds.height)
            eye.path  = eyePathWithBounds((layers["eye"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let arm : CAShapeLayer = layers["arm"] as? CAShapeLayer{
            arm.frame = CGRectMake(0.27495 * arm.superlayer!.bounds.width, 0.57987 * arm.superlayer!.bounds.height, 0.44562 * arm.superlayer!.bounds.width, 0.25663 * arm.superlayer!.bounds.height)
            arm.path  = armPathWithBounds((layers["arm"] as! CAShapeLayer).bounds).CGPath;
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addMommyAnimationsAnimation(){
        addMommyAnimationsAnimationCompletionBlock(nil)
    }
    
    func addMommyAnimationsAnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)?){
        addMommyAnimationsAnimationTotalDuration(1.009, completionBlock:completionBlock)
    }
    
    func addMommyAnimationsAnimationTotalDuration(totalDuration: CFTimeInterval, completionBlock: ((finished: Bool) -> Void)?){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = totalDuration
            completionAnim.delegate = self
            completionAnim.setValue("mommyAnimations", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.addAnimation(completionAnim, forKey:"mommyAnimations")
            if let anim = layer.animationForKey("mommyAnimations"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = kCAFillModeForwards
        
        let mommyLogo = layers["mommyLogo"] as! CALayer
        
        ////MommyLogo animation
        let mommyLogoTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        mommyLogoTransformAnim.values   = [NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 0.5)),
            NSValue(CATransform3D: CATransform3DIdentity)]
        mommyLogoTransformAnim.keyTimes = [0, 1]
        mommyLogoTransformAnim.duration = 0.991 * totalDuration
        
        let mommyLogoOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        mommyLogoOpacityAnim.values   = [0, 1]
        mommyLogoOpacityAnim.keyTimes = [0, 1]
        mommyLogoOpacityAnim.duration = 0.991 * totalDuration
        
        let mommyLogoMommyAnimationsAnim : CAAnimationGroup = QCMethod.groupAnimations([mommyLogoTransformAnim, mommyLogoOpacityAnim], fillMode:fillMode)
        mommyLogo.addAnimation(mommyLogoMommyAnimationsAnim, forKey:"mommyLogoMommyAnimationsAnim")
        
        ////Body animation
        let bodyStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        bodyStrokeStartAnim.values   = [0, 0.4, 2]
        bodyStrokeStartAnim.keyTimes = [0, 0.519, 1]
        bodyStrokeStartAnim.duration = 0.991 * totalDuration
        
        let bodyPathAnim            = CAKeyframeAnimation(keyPath:"path")

        //bodyPathAnim.values         = [nil, nil, nil]
        bodyPathAnim.keyTimes       = [0, 0.267, 1]
        bodyPathAnim.duration       = 0.991 * totalDuration
        bodyPathAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let bodyMommyAnimationsAnim : CAAnimationGroup = QCMethod.groupAnimations([bodyStrokeStartAnim, bodyPathAnim], fillMode:fillMode)
        layers["body"]?.addAnimation(bodyMommyAnimationsAnim, forKey:"bodyMommyAnimationsAnim")
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
        if identifier == "mommyAnimations"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["mommyLogo"] as! CALayer).animationForKey("mommyLogoMommyAnimationsAnim"), theLayer:(layers["mommyLogo"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["body"] as! CALayer).animationForKey("bodyMommyAnimationsAnim"), theLayer:(layers["body"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "mommyAnimations"{
            (layers["mommyLogo"] as! CALayer).removeAnimationForKey("mommyLogoMommyAnimationsAnim")
            (layers["body"] as! CALayer).removeAnimationForKey("bodyMommyAnimationsAnim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func hairPathWithBounds(bound: CGRect) -> UIBezierPath{
        let hairPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        hairPath.moveToPoint(CGPointMake(minX + 0.55437 * w, minY + 0.00868 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.98218 * w, minY + 0.62063 * h), controlPoint1:CGPointMake(minX + 0.80405 * w, minY + -0.05962 * h), controlPoint2:CGPointMake(minX + 1.07225 * w, minY + 0.28716 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.48224 * w, minY + 0.18073 * h), controlPoint1:CGPointMake(minX + 0.97354 * w, minY + 0.30566 * h), controlPoint2:CGPointMake(minX + 0.69923 * w, minY + 0.09237 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.29703 * w, minY + 0.33385 * h), controlPoint1:CGPointMake(minX + 0.41192 * w, minY + 0.21099 * h), controlPoint2:CGPointMake(minX + 0.35129 * w, minY + 0.26866 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.31652 * w, minY + 0.25569 * h), controlPoint1:CGPointMake(minX + 0.29956 * w, minY + 0.30618 * h), controlPoint2:CGPointMake(minX + 0.31041 * w, minY + 0.28189 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.13612 * w, minY + 0.65141 * h), controlPoint1:CGPointMake(minX + 0.15886 * w, minY + 0.19612 * h), controlPoint2:CGPointMake(minX + 0.02317 * w, minY + 0.49267 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.1742 * w, minY + 0.60697 * h), controlPoint1:CGPointMake(minX + 0.15288 * w, minY + 0.69533 * h), controlPoint2:CGPointMake(minX + 0.15016 * w, minY + 0.61215 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.22632 * w, minY + h), controlPoint1:CGPointMake(minX + 0.15984 * w, minY + 0.74296 * h), controlPoint2:CGPointMake(minX + 0.18531 * w, minY + 0.87567 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.11292 * w, minY + 0.71729 * h), controlPoint1:CGPointMake(minX + 0.16413 * w, minY + 0.92729 * h), controlPoint2:CGPointMake(minX + 0.12494 * w, minY + 0.8257 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.06411 * w, minY + 0.23754 * h), controlPoint1:CGPointMake(minX + -0.0294 * w, minY + 0.63757 * h), controlPoint2:CGPointMake(minX + -0.02726 * w, minY + 0.375 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.3342 * w, minY + 0.13794 * h), controlPoint1:CGPointMake(minX + 0.12605 * w, minY + 0.12834 * h), controlPoint2:CGPointMake(minX + 0.23951 * w, minY + 0.10482 * h))
        hairPath.addCurveToPoint(CGPointMake(minX + 0.55437 * w, minY + 0.00868 * h), controlPoint1:CGPointMake(minX + 0.40152 * w, minY + 0.07949 * h), controlPoint2:CGPointMake(minX + 0.47204 * w, minY + 0.01906 * h))
        hairPath.closePath()
        hairPath.moveToPoint(CGPointMake(minX + 0.55437 * w, minY + 0.00868 * h))
        
        return hairPath;
    }
    
    func frontHairPathWithBounds(bound: CGRect) -> UIBezierPath{
        let frontHairPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        frontHairPath.moveToPoint(CGPointMake(minX + 0.9925 * w, minY))
        frontHairPath.addCurveToPoint(CGPointMake(minX + 0.89826 * w, minY + 0.30588 * h), controlPoint1:CGPointMake(minX + 1.01925 * w, minY + 0.07405 * h), controlPoint2:CGPointMake(minX + 0.97133 * w, minY + 0.22277 * h))
        frontHairPath.addCurveToPoint(CGPointMake(minX + 0.07677 * w, minY + 0.74175 * h), controlPoint1:CGPointMake(minX + 0.69627 * w, minY + 0.54155 * h), controlPoint2:CGPointMake(minX + 0.27538 * w, minY + 0.50533 * h))
        frontHairPath.addCurveToPoint(CGPointMake(minX + 0.02972 * w, minY + h), controlPoint1:CGPointMake(minX + 0.01487 * w, minY + 0.81791 * h), controlPoint2:CGPointMake(minX + 0.0356 * w, minY + 0.91355 * h))
        frontHairPath.addCurveToPoint(CGPointMake(minX + 0.1635 * w, minY + 0.57926 * h), controlPoint1:CGPointMake(minX + -0.0332 * w, minY + 0.87472 * h), controlPoint2:CGPointMake(minX + 0.00032 * w, minY + 0.66348 * h))
        frontHairPath.addCurveToPoint(CGPointMake(minX + 0.9925 * w, minY), controlPoint1:CGPointMake(minX + 0.46973 * w, minY + 0.42843 * h), controlPoint2:CGPointMake(minX + 0.9209 * w, minY + 0.34656 * h))
        frontHairPath.closePath()
        frontHairPath.moveToPoint(CGPointMake(minX + 0.9925 * w, minY))
        
        return frontHairPath;
    }
    
    func bodyPathWithBounds(bound: CGRect) -> UIBezierPath{
        let bodyPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        bodyPath.moveToPoint(CGPointMake(minX + 0.59079 * w, minY + 0.22788 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.79306 * w, minY + 0.0014 * h), controlPoint1:CGPointMake(minX + 0.52745 * w, minY + 0.10555 * h), controlPoint2:CGPointMake(minX + 0.66501 * w, minY + -0.01434 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.96282 * w, minY + 0.23057 * h), controlPoint1:CGPointMake(minX + 0.91543 * w, minY + -0.00009 * h), controlPoint2:CGPointMake(minX + 1.01767 * w, minY + 0.12203 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.88491 * w, minY + 0.3237 * h), controlPoint1:CGPointMake(minX + 0.94905 * w, minY + 0.26933 * h), controlPoint2:CGPointMake(minX + 0.91885 * w, minY + 0.29927 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.84818 * w, minY + 0.54327 * h), controlPoint1:CGPointMake(minX + 0.93848 * w, minY + 0.39153 * h), controlPoint2:CGPointMake(minX + 0.90179 * w, minY + 0.48604 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.83601 * w, minY + 0.32822 * h), controlPoint1:CGPointMake(minX + 0.88971 * w, minY + 0.47837 * h), controlPoint2:CGPointMake(minX + 0.89322 * w, minY + 0.38661 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.91369 * w, minY + 0.14634 * h), controlPoint1:CGPointMake(minX + 0.88873 * w, minY + 0.28353 * h), controlPoint2:CGPointMake(minX + 0.92862 * w, minY + 0.21413 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.6273 * w, minY + 0.12087 * h), controlPoint1:CGPointMake(minX + 0.87661 * w, minY + 0.03759 * h), controlPoint2:CGPointMake(minX + 0.68984 * w, minY + 0.02595 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.61051 * w, minY + 0.25442 * h), controlPoint1:CGPointMake(minX + 0.59101 * w, minY + 0.16224 * h), controlPoint2:CGPointMake(minX + 0.63454 * w, minY + 0.21255 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.66257 * w, minY + 0.34101 * h), controlPoint1:CGPointMake(minX + 0.59434 * w, minY + 0.29364 * h), controlPoint2:CGPointMake(minX + 0.62592 * w, minY + 0.32772 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.72546 * w, minY + 0.35029 * h), controlPoint1:CGPointMake(minX + 0.68349 * w, minY + 0.34428 * h), controlPoint2:CGPointMake(minX + 0.70454 * w, minY + 0.34677 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.70498 * w, minY + 0.35484 * h), controlPoint1:CGPointMake(minX + 0.71858 * w, minY + 0.35178 * h), controlPoint2:CGPointMake(minX + 0.71174 * w, minY + 0.3531 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.68033 * w, minY + 0.36246 * h), controlPoint1:CGPointMake(minX + 0.69655 * w, minY + 0.35679 * h), controlPoint2:CGPointMake(minX + 0.68824 * w, minY + 0.35919 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.65253 * w, minY + 0.37721 * h), controlPoint1:CGPointMake(minX + 0.67038 * w, minY + 0.36619 * h), controlPoint2:CGPointMake(minX + 0.66146 * w, minY + 0.37182 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.62668 * w, minY + 0.39224 * h), controlPoint1:CGPointMake(minX + 0.64391 * w, minY + 0.38218 * h), controlPoint2:CGPointMake(minX + 0.63521 * w, minY + 0.3871 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.46336 * w, minY + 0.39228 * h), controlPoint1:CGPointMake(minX + 0.57738 * w, minY + 0.42048 * h), controlPoint2:CGPointMake(minX + 0.51346 * w, minY + 0.41617 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.37711 * w, minY + 0.32602 * h), controlPoint1:CGPointMake(minX + 0.42779 * w, minY + 0.37832 * h), controlPoint2:CGPointMake(minX + 0.40438 * w, minY + 0.34979 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.4344 * w, minY + 0.43771 * h), controlPoint1:CGPointMake(minX + 0.35055 * w, minY + 0.36859 * h), controlPoint2:CGPointMake(minX + 0.40065 * w, minY + 0.41216 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.68948 * w, minY + 0.48467 * h), controlPoint1:CGPointMake(minX + 0.50596 * w, minY + 0.49026 * h), controlPoint2:CGPointMake(minX + 0.60238 * w, minY + 0.49631 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.39185 * w, minY + 0.43431 * h), controlPoint1:CGPointMake(minX + 0.59283 * w, minY + 0.52442 * h), controlPoint2:CGPointMake(minX + 0.46638 * w, minY + 0.5091 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.343 * w, minY + 0.35919 * h), controlPoint1:CGPointMake(minX + 0.37173 * w, minY + 0.4117 * h), controlPoint2:CGPointMake(minX + 0.35472 * w, minY + 0.38648 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.34175 * w, minY + 0.35174 * h), controlPoint1:CGPointMake(minX + 0.34269 * w, minY + 0.35733 * h), controlPoint2:CGPointMake(minX + 0.34206 * w, minY + 0.3536 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.33891 * w, minY + 0.26809 * h), controlPoint1:CGPointMake(minX + 0.33167 * w, minY + 0.32126 * h), controlPoint2:CGPointMake(minX + 0.36978 * w, minY + 0.29306 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.26234 * w, minY + 0.34416 * h), controlPoint1:CGPointMake(minX + 0.3489 * w, minY + 0.31153 * h), controlPoint2:CGPointMake(minX + 0.30631 * w, minY + 0.34627 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.24888 * w, minY + 0.34408 * h), controlPoint1:CGPointMake(minX + 0.25896 * w, minY + 0.34416 * h), controlPoint2:CGPointMake(minX + 0.25221 * w, minY + 0.34412 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.2268 * w, minY + 0.34362 * h), controlPoint1:CGPointMake(minX + 0.24151 * w, minY + 0.34375 * h), controlPoint2:CGPointMake(minX + 0.23413 * w, minY + 0.34366 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.18217 * w, minY + 0.34383 * h), controlPoint1:CGPointMake(minX + 0.21188 * w, minY + 0.34341 * h), controlPoint2:CGPointMake(minX + 0.19705 * w, minY + 0.343 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.15943 * w, minY + 0.34664 * h), controlPoint1:CGPointMake(minX + 0.17453 * w, minY + 0.34416 * h), controlPoint2:CGPointMake(minX + 0.16693 * w, minY + 0.3452 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.13731 * w, minY + 0.35149 * h), controlPoint1:CGPointMake(minX + 0.15201 * w, minY + 0.34797 * h), controlPoint2:CGPointMake(minX + 0.1445 * w, minY + 0.34921 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.11648 * w, minY + 0.36275 * h), controlPoint1:CGPointMake(minX + 0.12962 * w, minY + 0.35385 * h), controlPoint2:CGPointMake(minX + 0.12265 * w, minY + 0.35791 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.07739 * w, minY + 0.49602 * h), controlPoint1:CGPointMake(minX + 0.07006 * w, minY + 0.39158 * h), controlPoint2:CGPointMake(minX + 0.06229 * w, minY + 0.44922 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.28104 * w, minY + 0.78184 * h), controlPoint1:CGPointMake(minX + 0.11497 * w, minY + 0.60708 * h), controlPoint2:CGPointMake(minX + 0.19611 * w, minY + 0.69893 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.52825 * w, minY + 0.94073 * h), controlPoint1:CGPointMake(minX + 0.35379 * w, minY + 0.84578 * h), controlPoint2:CGPointMake(minX + 0.43236 * w, minY + 0.90959 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.73652 * w, minY + 0.85625 * h), controlPoint1:CGPointMake(minX + 0.60878 * w, minY + 0.95722 * h), controlPoint2:CGPointMake(minX + 0.67962 * w, minY + 0.90156 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.96384 * w, minY + 0.52997 * h), controlPoint1:CGPointMake(minX + 0.8401 * w, minY + 0.76763 * h), controlPoint2:CGPointMake(minX + 0.92084 * w, minY + 0.65504 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.93928 * w, minY + 0.36702 * h), controlPoint1:CGPointMake(minX + 0.97943 * w, minY + 0.47639 * h), controlPoint2:CGPointMake(minX + 0.98032 * w, minY + 0.41154 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.91036 * w, minY + 0.32275 * h), controlPoint1:CGPointMake(minX + 0.92986 * w, minY + 0.35232 * h), controlPoint2:CGPointMake(minX + 0.91098 * w, minY + 0.34118 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.95895 * w, minY + 0.36118 * h), controlPoint1:CGPointMake(minX + 0.92666 * w, minY + 0.33542 * h), controlPoint2:CGPointMake(minX + 0.94287 * w, minY + 0.34826 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.98618 * w, minY + 0.38876 * h), controlPoint1:CGPointMake(minX + 0.96797 * w, minY + 0.37037 * h), controlPoint2:CGPointMake(minX + 0.97699 * w, minY + 0.37969 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.95811 * w, minY + 0.64046 * h), controlPoint1:CGPointMake(minX + 1.02082 * w, minY + 0.47204 * h), controlPoint2:CGPointMake(minX + 0.98232 * w, minY + 0.5595 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.61144 * w, minY + 0.99639 * h), controlPoint1:CGPointMake(minX + 0.89855 * w, minY + 0.79211 * h), controlPoint2:CGPointMake(minX + 0.79581 * w, minY + 0.96272 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.26296 * w, minY + 0.86093 * h), controlPoint1:CGPointMake(minX + 0.47624 * w, minY + 1.01826 * h), controlPoint2:CGPointMake(minX + 0.3601 * w, minY + 0.93672 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.00206 * w, minY + 0.40189 * h), controlPoint1:CGPointMake(minX + 0.12438 * w, minY + 0.74473 * h), controlPoint2:CGPointMake(minX + -0.01895 * w, minY + 0.58733 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.02369 * w, minY + 0.33658 * h), controlPoint1:CGPointMake(minX + 0.00641 * w, minY + 0.37936 * h), controlPoint2:CGPointMake(minX + 0.0137 * w, minY + 0.35745 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.17568 * w, minY + 0.27906 * h), controlPoint1:CGPointMake(minX + 0.05007 * w, minY + 0.28585 * h), controlPoint2:CGPointMake(minX + 0.12123 * w, minY + 0.27244 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.3123 * w, minY + 0.26606 * h), controlPoint1:CGPointMake(minX + 0.21943 * w, minY + 0.28101 * h), controlPoint2:CGPointMake(minX + 0.27779 * w, minY + 0.30155 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.31182 * w, minY + 0.19379 * h), controlPoint1:CGPointMake(minX + 0.33003 * w, minY + 0.24535 * h), controlPoint2:CGPointMake(minX + 0.31337 * w, minY + 0.21657 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.42676 * w, minY + 0.33559 * h), controlPoint1:CGPointMake(minX + 0.33798 * w, minY + 0.24796 * h), controlPoint2:CGPointMake(minX + 0.37244 * w, minY + 0.30196 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.49392 * w, minY + 0.36801 * h), controlPoint1:CGPointMake(minX + 0.4472 * w, minY + 0.3495 * h), controlPoint2:CGPointMake(minX + 0.4702 * w, minY + 0.35994 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.51462 * w, minY + 0.37373 * h), controlPoint1:CGPointMake(minX + 0.50072 * w, minY + 0.37017 * h), controlPoint2:CGPointMake(minX + 0.5076 * w, minY + 0.37211 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.537 * w, minY + 0.37708 * h), controlPoint1:CGPointMake(minX + 0.5219 * w, minY + 0.37551 * h), controlPoint2:CGPointMake(minX + 0.52941 * w, minY + 0.37679 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.60931 * w, minY + 0.3389 * h), controlPoint1:CGPointMake(minX + 0.55481 * w, minY + 0.38495 * h), controlPoint2:CGPointMake(minX + 0.6699 * w, minY + 0.36271 * h))
        bodyPath.addCurveToPoint(CGPointMake(minX + 0.59079 * w, minY + 0.22788 * h), controlPoint1:CGPointMake(minX + 0.5645 * w, minY + 0.31646 * h), controlPoint2:CGPointMake(minX + 0.57032 * w, minY + 0.26316 * h))
        bodyPath.closePath()
        bodyPath.moveToPoint(CGPointMake(minX + 0.59079 * w, minY + 0.22788 * h))
        
        return bodyPath;
    }
    
    func eyePathWithBounds(bound: CGRect) -> UIBezierPath{
        let eyePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        eyePath.moveToPoint(CGPointMake(minX, minY))
        eyePath.addCurveToPoint(CGPointMake(minX + 0.99794 * w, minY + 0.89122 * h), controlPoint1:CGPointMake(minX + 0.20632 * w, minY + 0.71372 * h), controlPoint2:CGPointMake(minX + 1.04703 * w, minY + 0.26071 * h))
        eyePath.addCurveToPoint(CGPointMake(minX, minY), controlPoint1:CGPointMake(minX + 0.60682 * w, minY + 1.23884 * h), controlPoint2:CGPointMake(minX + 0.07502 * w, minY + 0.70262 * h))
        eyePath.closePath()
        eyePath.moveToPoint(CGPointMake(minX, minY))
        
        return eyePath;
    }
    
    func armPathWithBounds(bound: CGRect) -> UIBezierPath{
        let armPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        armPath.moveToPoint(CGPointMake(minX, minY))
        armPath.addCurveToPoint(CGPointMake(minX + 0.67886 * w, minY + 0.83273 * h), controlPoint1:CGPointMake(minX + 0.23752 * w, minY + 0.26332 * h), controlPoint2:CGPointMake(minX + 0.456 * w, minY + 0.55266 * h))
        armPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.61352 * h), controlPoint1:CGPointMake(minX + 0.78042 * w, minY + 0.75247 * h), controlPoint2:CGPointMake(minX + 0.8802 * w, minY + 0.64955 * h))
        armPath.addCurveToPoint(CGPointMake(minX + 0.65105 * w, minY + h), controlPoint1:CGPointMake(minX + 0.88697 * w, minY + 0.7462 * h), controlPoint2:CGPointMake(minX + 0.75431 * w, minY + 0.85515 * h))
        armPath.addCurveToPoint(CGPointMake(minX, minY), controlPoint1:CGPointMake(minX + 0.46975 * w, minY + 0.63485 * h), controlPoint2:CGPointMake(minX + 0.14861 * w, minY + 0.39058 * h))
        armPath.closePath()
        armPath.moveToPoint(CGPointMake(minX, minY))
        
        return armPath;
    }
    
    
}

