//
//  SpeakerView.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/16/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class SpeakerView: UIView {
    
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
        let speaker = CALayer()
        self.layer.addSublayer(speaker)
        layers["speaker"] = speaker
        let soundPath1 = CAShapeLayer()
        speaker.addSublayer(soundPath1)
        layers["soundPath1"] = soundPath1
        let soundPath2 = CAShapeLayer()
        speaker.addSublayer(soundPath2)
        layers["soundPath2"] = soundPath2
        let speakerPath = CAShapeLayer()
        speaker.addSublayer(speakerPath)
        layers["speakerPath"] = speakerPath
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("soundPath1"){
            let soundPath1 = layers["soundPath1"] as! CAShapeLayer
            soundPath1.fillColor = self.fillColor.CGColor
            soundPath1.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("soundPath2"){
            let soundPath2 = layers["soundPath2"] as! CAShapeLayer
            soundPath2.fillColor = self.fillColor.CGColor
            soundPath2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("speakerPath"){
            let speakerPath = layers["speakerPath"] as! CAShapeLayer
            speakerPath.fillColor = self.fillColor.CGColor
            speakerPath.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let speaker : CALayer = layers["speaker"] as? CALayer{
            speaker.frame = CGRectMake(0.1297 * speaker.superlayer!.bounds.width, 0.21692 * speaker.superlayer!.bounds.height, 0.76819 * speaker.superlayer!.bounds.width, 0.54424 * speaker.superlayer!.bounds.height)
        }
        
        if let soundPath1 : CAShapeLayer = layers["soundPath1"] as? CAShapeLayer{
            soundPath1.frame = CGRectMake(0.77212 * soundPath1.superlayer!.bounds.width, 0.01382 * soundPath1.superlayer!.bounds.height, 0.22788 * soundPath1.superlayer!.bounds.width, 0.97235 * soundPath1.superlayer!.bounds.height)
            soundPath1.path  = soundPath1PathWithBounds((layers["soundPath1"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let soundPath2 : CAShapeLayer = layers["soundPath2"] as? CAShapeLayer{
            soundPath2.frame = CGRectMake(0.61342 * soundPath2.superlayer!.bounds.width, 0.22553 * soundPath2.superlayer!.bounds.height, 0.15719 * soundPath2.superlayer!.bounds.width, 0.54894 * soundPath2.superlayer!.bounds.height)
            soundPath2.path  = soundPath2PathWithBounds((layers["soundPath2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let speakerPath : CAShapeLayer = layers["speakerPath"] as? CAShapeLayer{
            speakerPath.frame = CGRectMake(0, 0, 0.51269 * speakerPath.superlayer!.bounds.width,  speakerPath.superlayer!.bounds.height)
            speakerPath.path  = speakerPathPathWithBounds((layers["speakerPath"] as! CAShapeLayer).bounds).CGPath;
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
    
    func soundPath1PathWithBounds(bound: CGRect) -> UIBezierPath{
        let soundPath1Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        soundPath1Path.moveToPoint(CGPointMake(minX + 0.37844 * w, minY + 0.00441 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.31405 * w, minY + 0.00442 * h), controlPoint1:CGPointMake(minX + 0.36065 * w, minY + -0.00147 * h), controlPoint2:CGPointMake(minX + 0.33179 * w, minY + -0.00147 * h))
        soundPath1Path.addLineToPoint(CGPointMake(minX + 0.01335 * w, minY + 0.10389 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX, minY + 0.11454 * h), controlPoint1:CGPointMake(minX + 0.0048 * w, minY + 0.10672 * h), controlPoint2:CGPointMake(minX, minY + 0.11054 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.01335 * w, minY + 0.12519 * h), controlPoint1:CGPointMake(minX, minY + 0.11854 * h), controlPoint2:CGPointMake(minX + 0.0048 * w, minY + 0.12237 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.48346 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.3165 * w, minY + 0.22548 * h), controlPoint2:CGPointMake(minX + 0.48346 * w, minY + 0.35859 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.01335 * w, minY + 0.8748 * h), controlPoint1:CGPointMake(minX + 0.48344 * w, minY + 0.64142 * h), controlPoint2:CGPointMake(minX + 0.3165 * w, minY + 0.77453 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX, minY + 0.88546 * h), controlPoint1:CGPointMake(minX + 0.0048 * w, minY + 0.87762 * h), controlPoint2:CGPointMake(minX, minY + 0.88146 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.01335 * w, minY + 0.89611 * h), controlPoint1:CGPointMake(minX, minY + 0.88945 * h), controlPoint2:CGPointMake(minX + 0.0048 * w, minY + 0.89328 * h))
        soundPath1Path.addLineToPoint(CGPointMake(minX + 0.31405 * w, minY + 0.99558 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.34625 * w, minY + h), controlPoint1:CGPointMake(minX + 0.32257 * w, minY + 0.99841 * h), controlPoint2:CGPointMake(minX + 0.33414 * w, minY + h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.37848 * w, minY + 0.99558 * h), controlPoint1:CGPointMake(minX + 0.35833 * w, minY + 1 * h), controlPoint2:CGPointMake(minX + 0.36993 * w, minY + 0.99841 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.49999 * h), controlPoint1:CGPointMake(minX + 0.77928 * w, minY + 0.863 * h), controlPoint2:CGPointMake(minX + w, minY + 0.687 * h))
        soundPath1Path.addCurveToPoint(CGPointMake(minX + 0.37844 * w, minY + 0.00441 * h), controlPoint1:CGPointMake(minX + 0.99997 * w, minY + 0.313 * h), controlPoint2:CGPointMake(minX + 0.77926 * w, minY + 0.13699 * h))
        soundPath1Path.closePath()
        soundPath1Path.moveToPoint(CGPointMake(minX + 0.37844 * w, minY + 0.00441 * h))
        
        return soundPath1Path;
    }
    
    func soundPath2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let soundPath2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        soundPath2Path.moveToPoint(CGPointMake(minX + 0.452 * w, minY))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.40994 * w, minY + 0.00705 * h), controlPoint1:CGPointMake(minX + 0.43624 * w, minY), controlPoint2:CGPointMake(minX + 0.42113 * w, minY + 0.00253 * h))
        soundPath2Path.addLineToPoint(CGPointMake(minX + 0.01742 * w, minY + 0.1657 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX, minY + 0.18269 * h), controlPoint1:CGPointMake(minX + 0.00628 * w, minY + 0.1702 * h), controlPoint2:CGPointMake(minX, minY + 0.17632 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.01742 * w, minY + 0.19968 * h), controlPoint1:CGPointMake(minX, minY + 0.18907 * h), controlPoint2:CGPointMake(minX + 0.00627 * w, minY + 0.19518 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.32574 * w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.21623 * w, minY + 0.28004 * h), controlPoint2:CGPointMake(minX + 0.32574 * w, minY + 0.38669 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.01742 * w, minY + 0.80032 * h), controlPoint1:CGPointMake(minX + 0.32574 * w, minY + 0.61332 * h), controlPoint2:CGPointMake(minX + 0.21623 * w, minY + 0.71996 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX, minY + 0.81731 * h), controlPoint1:CGPointMake(minX + 0.00628 * w, minY + 0.80482 * h), controlPoint2:CGPointMake(minX, minY + 0.81094 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.01742 * w, minY + 0.8343 * h), controlPoint1:CGPointMake(minX, minY + 0.82368 * h), controlPoint2:CGPointMake(minX + 0.00627 * w, minY + 0.8298 * h))
        soundPath2Path.addLineToPoint(CGPointMake(minX + 0.40994 * w, minY + 0.99296 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.49406 * w, minY + 0.99296 * h), controlPoint1:CGPointMake(minX + 0.43317 * w, minY + 1.00235 * h), controlPoint2:CGPointMake(minX + 0.47083 * w, minY + 1.00235 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.82033 * w, minY + 0.86108 * h), controlPoint2:CGPointMake(minX + w, minY + 0.68603 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.49406 * w, minY + 0.00705 * h), controlPoint1:CGPointMake(minX + w, minY + 0.314 * h), controlPoint2:CGPointMake(minX + 0.82031 * w, minY + 0.13893 * h))
        soundPath2Path.addCurveToPoint(CGPointMake(minX + 0.452 * w, minY), controlPoint1:CGPointMake(minX + 0.48291 * w, minY + 0.00254 * h), controlPoint2:CGPointMake(minX + 0.46779 * w, minY + 0.00001 * h))
        soundPath2Path.closePath()
        soundPath2Path.moveToPoint(CGPointMake(minX + 0.452 * w, minY))
        
        return soundPath2Path;
    }
    
    func speakerPathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let speakerPathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        speakerPathPath.moveToPoint(CGPointMake(minX + 0.97879 * w, minY + 0.00312 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + 0.9382 * w, minY + 0.00529 * h), controlPoint1:CGPointMake(minX + 0.96578 * w, minY + -0.00172 * h), controlPoint2:CGPointMake(minX + 0.9501 * w, minY + -0.00088 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX + 0.34841 * w, minY + 0.31126 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX + 0.03904 * w, minY + 0.31126 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.33952 * h), controlPoint1:CGPointMake(minX + 0.01748 * w, minY + 0.31126 * h), controlPoint2:CGPointMake(minX, minY + 0.32391 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX, minY + 0.66048 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + 0.03904 * w, minY + 0.68874 * h), controlPoint1:CGPointMake(minX, minY + 0.67609 * h), controlPoint2:CGPointMake(minX + 0.01748 * w, minY + 0.68874 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX + 0.3484 * w, minY + 0.68874 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX + 0.9382 * w, minY + 0.99471 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + 0.96095 * w, minY + h), controlPoint1:CGPointMake(minX + 0.94496 * w, minY + 0.99821 * h), controlPoint2:CGPointMake(minX + 0.95294 * w, minY + h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + 0.97878 * w, minY + 0.99688 * h), controlPoint1:CGPointMake(minX + 0.96704 * w, minY + h), controlPoint2:CGPointMake(minX + 0.97316 * w, minY + 0.99897 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.97175 * h), controlPoint1:CGPointMake(minX + 0.99181 * w, minY + 0.99204 * h), controlPoint2:CGPointMake(minX + w, minY + 0.98234 * h))
        speakerPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.02826 * h))
        speakerPathPath.addCurveToPoint(CGPointMake(minX + 0.97879 * w, minY + 0.00312 * h), controlPoint1:CGPointMake(minX + w, minY + 0.01766 * h), controlPoint2:CGPointMake(minX + 0.99181 * w, minY + 0.00796 * h))
        speakerPathPath.closePath()
        speakerPathPath.moveToPoint(CGPointMake(minX + 0.97879 * w, minY + 0.00312 * h))
        
        return speakerPathPath;
    }
    
    
}

