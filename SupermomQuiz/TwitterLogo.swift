//
//  TwitterLogo.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 11/3/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class TwitterLogo: UIView {
	
	var layers : Dictionary<String, AnyObject> = [:]
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var updateLayerValueForCompletedAnimation : Bool = false
	
	var twitterColor : UIColor!
	
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
		self.twitterColor = ThemeColor.TwitterBlue
	}
	
	func setupLayers(){
		let twitterPath : CAShapeLayer = CAShapeLayer()
		self.layer.addSublayer(twitterPath)
		layers["twitterPath"] = twitterPath
		
		setupLayerFrames()
		resetLayerPropertiesForLayerIdentifiers(nil)
	}
	
	func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if layerIds == nil || layerIds.contains("twitterPath") {
			let twitterPath = layers["twitterPath"] as! CAShapeLayer
			twitterPath.fillColor = self.twitterColor.CGColor
			twitterPath.lineWidth = 0
		}
		
		CATransaction.commit()
	}
	
	func setupLayerFrames(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let twitterPath : CAShapeLayer = layers["twitterPath"] as? CAShapeLayer{
			twitterPath.frame = CGRectMake(0.03251 * twitterPath.superlayer!.bounds.width, 0.12027 * twitterPath.superlayer!.bounds.height, 0.93497 * twitterPath.superlayer!.bounds.width, 0.75946 * twitterPath.superlayer!.bounds.height)
			twitterPath.path  = twitterPathPathWithBounds((layers["twitterPath"] as! CAShapeLayer).bounds).CGPath;
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
	
	func twitterPathPathWithBounds(bound: CGRect) -> UIBezierPath{
		let twitterPathPath = UIBezierPath()
		let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
		
		twitterPathPath.moveToPoint(CGPointMake(minX + w, minY + 0.11832 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.88221 * w, minY + 0.15809 * h), controlPoint1:CGPointMake(minX + 0.96319 * w, minY + 0.13839 * h), controlPoint2:CGPointMake(minX + 0.9237 * w, minY + 0.15201 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.97238 * w, minY + 0.01846 * h), controlPoint1:CGPointMake(minX + 0.92458 * w, minY + 0.12685 * h), controlPoint2:CGPointMake(minX + 0.95701 * w, minY + 0.07731 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.84203 * w, minY + 0.07978 * h), controlPoint1:CGPointMake(minX + 0.93264 * w, minY + 0.04739 * h), controlPoint2:CGPointMake(minX + 0.88877 * w, minY + 0.06839 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.69231 * w, minY), controlPoint1:CGPointMake(minX + 0.8046 * w, minY + 0.03062 * h), controlPoint2:CGPointMake(minX + 0.75136 * w, minY))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.48716 * w, minY + 0.25248 * h), controlPoint1:CGPointMake(minX + 0.57901 * w, minY), controlPoint2:CGPointMake(minX + 0.48716 * w, minY + 0.11309 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.49247 * w, minY + 0.31002 * h), controlPoint1:CGPointMake(minX + 0.48716 * w, minY + 0.27225 * h), controlPoint2:CGPointMake(minX + 0.48897 * w, minY + 0.29156 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.06967 * w, minY + 0.04616 * h), controlPoint1:CGPointMake(minX + 0.322 * w, minY + 0.29948 * h), controlPoint2:CGPointMake(minX + 0.17084 * w, minY + 0.19894 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.04193 * w, minY + 0.17309 * h), controlPoint1:CGPointMake(minX + 0.05199 * w, minY + 0.08339 * h), controlPoint2:CGPointMake(minX + 0.04193 * w, minY + 0.12678 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.13316 * w, minY + 0.38326 * h), controlPoint1:CGPointMake(minX + 0.04193 * w, minY + 0.26071 * h), controlPoint2:CGPointMake(minX + 0.07817 * w, minY + 0.33803 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.04024 * w, minY + 0.35156 * h), controlPoint1:CGPointMake(minX + 0.09954 * w, minY + 0.38187 * h), controlPoint2:CGPointMake(minX + 0.06792 * w, minY + 0.37049 * h))
		twitterPathPath.addLineToPoint(CGPointMake(minX + 0.04024 * w, minY + 0.35472 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.20477 * w, minY + 0.60235 * h), controlPoint1:CGPointMake(minX + 0.04024 * w, minY + 0.47703 * h), controlPoint2:CGPointMake(minX + 0.11098 * w, minY + 0.57912 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.15072 * w, minY + 0.6112 * h), controlPoint1:CGPointMake(minX + 0.18759 * w, minY + 0.60805 * h), controlPoint2:CGPointMake(minX + 0.16947 * w, minY + 0.6112 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.1121 * w, minY + 0.60651 * h), controlPoint1:CGPointMake(minX + 0.13747 * w, minY + 0.6112 * h), controlPoint2:CGPointMake(minX + 0.12466 * w, minY + 0.60958 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.30369 * w, minY + 0.78191 * h), controlPoint1:CGPointMake(minX + 0.13822 * w, minY + 0.7069 * h), controlPoint2:CGPointMake(minX + 0.21396 * w, minY + 0.7799 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.04893 * w, minY + 0.88984 * h), controlPoint1:CGPointMake(minX + 0.23352 * w, minY + 0.8496 * h), controlPoint2:CGPointMake(minX + 0.14503 * w, minY + 0.88984 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.88638 * h), controlPoint1:CGPointMake(minX + 0.03237 * w, minY + 0.88984 * h), controlPoint2:CGPointMake(minX + 0.01606 * w, minY + 0.88861 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.31444 * w, minY + h), controlPoint1:CGPointMake(minX + 0.0908 * w, minY + 0.95815 * h), controlPoint2:CGPointMake(minX + 0.19859 * w, minY + h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + 0.89808 * w, minY + 0.28148 * h), controlPoint1:CGPointMake(minX + 0.69181 * w, minY + h), controlPoint2:CGPointMake(minX + 0.89808 * w, minY + 0.6152 * h))
		twitterPathPath.addLineToPoint(CGPointMake(minX + 0.8974 * w, minY + 0.24879 * h))
		twitterPathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.11832 * h), controlPoint1:CGPointMake(minX + 0.9377 * w, minY + 0.2134 * h), controlPoint2:CGPointMake(minX + 0.97257 * w, minY + 0.16894 * h))
		twitterPathPath.closePath()
		twitterPathPath.moveToPoint(CGPointMake(minX + w, minY + 0.11832 * h))
		
		return twitterPathPath;
	}
	
	
}
