//
//  clockView.swift
//
//  Created by Jakkrits on 10/16/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class ClockView: UIView {
	
	var layers : Dictionary<String, AnyObject> = [:]
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var updateLayerValueForCompletedAnimation : Bool = false
	
	var clockFillColor : UIColor!
	
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
		self.clockFillColor = ThemeColor.TimerIcon
	}
	
	func setupLayers(){
		let clockPath : CAShapeLayer = CAShapeLayer()
		self.layer.addSublayer(clockPath)
		layers["clockPath"] = clockPath
		
		setupLayerFrames()
		resetLayerPropertiesForLayerIdentifiers(nil)
	}
	
	func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if layerIds == nil || layerIds.contains("clockPath"){
			let clockPath = layers["clockPath"] as! CAShapeLayer
			clockPath.fillColor = self.clockFillColor.CGColor
			clockPath.lineWidth = 0
		}
		
		CATransaction.commit()
	}
	
	func setupLayerFrames(){
		if let clockPath : CAShapeLayer = layers["clockPath"] as? CAShapeLayer{
			clockPath.frame = CGRectMake(0.15182 * clockPath.superlayer!.bounds.width, 0.05372 * clockPath.superlayer!.bounds.height, 0.69635 * clockPath.superlayer!.bounds.width, 0.89255 * clockPath.superlayer!.bounds.height)
			clockPath.path  = clockPathPathWithBounds(clockPath.bounds).CGPath;
		}
		
	}
	
	func addScalingUpAnimationAnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)?){
		if let _ = completionBlock{
			let completionAnim : CABasicAnimation = CABasicAnimation(keyPath:"completionAnim")
			completionAnim.duration = 0.673
			completionAnim.delegate = self
			completionAnim.setValue("scalingUpAnimation", forKey:"animId")
			completionAnim.setValue(false, forKey:"needEndAnim")
			layer.addAnimation(completionAnim, forKey:"scalingUpAnimation")
            if let anim = layer.animationForKey("scalingUpAnimation") {
                            completionBlocks[anim] = completionBlock
            }

		}
		
		let fillMode : String = kCAFillModeForwards
		
		////ClockPath animation
		
		_ = layers["clockPath"] as! CAShapeLayer
		
		let clockPathTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
		clockPathTransformAnim.values   = [NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 0)), 
			 NSValue(CATransform3D: CATransform3DIdentity)]
		clockPathTransformAnim.keyTimes = [0, 1]
		clockPathTransformAnim.duration = 0.673
		
		let clockPathScalingUpAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([clockPathTransformAnim], fillMode:fillMode)
		layers["clockPath"]?.addAnimation(clockPathScalingUpAnimationAnim, forKey:"clockPathScalingUpAnimationAnim")
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
		if identifier == "scalingUpAnimation"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["clockPath"] as! CALayer).animationForKey("clockPathScalingUpAnimationAnim"), theLayer:(layers["clockPath"] as! CALayer))
		}
	}
	
	func removeAnimationsForAnimationId(identifier: String){
		if identifier == "scalingUpAnimation"{
			(layers["clockPath"] as! CALayer).removeAnimationForKey("clockPathScalingUpAnimationAnim")
		}
	}
	
	//MARK: - Bezier Path
	
	func clockPathPathWithBounds(bound: CGRect) -> UIBezierPath{
		let clockPathPath = UIBezierPath()
		let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
		
		clockPathPath.moveToPoint(CGPointMake(minX, minY + 0.37025 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.47457 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.16609 * h), controlPoint2:CGPointMake(minX + 0.21288 * w, minY))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.93063 * w, minY + 0.26896 * h), controlPoint1:CGPointMake(minX + 0.6912 * w, minY), controlPoint2:CGPointMake(minX + 0.87393 * w, minY + 0.11394 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.91098 * w, minY + 0.30139 * h), controlPoint1:CGPointMake(minX + 0.92026 * w, minY + 0.27771 * h), controlPoint2:CGPointMake(minX + 0.91301 * w, minY + 0.28882 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.90579 * w, minY + 0.33369 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.897 * w, minY + 0.37029 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.8485 * w, minY + 0.37025 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.47457 * w, minY + 0.07849 * h), controlPoint1:CGPointMake(minX + 0.8485 * w, minY + 0.20937 * h), controlPoint2:CGPointMake(minX + 0.68073 * w, minY + 0.07849 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.10059 * w, minY + 0.37025 * h), controlPoint1:CGPointMake(minX + 0.26835 * w, minY + 0.07849 * h), controlPoint2:CGPointMake(minX + 0.10059 * w, minY + 0.20937 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.29193 * w, minY + 0.62458 * h), controlPoint1:CGPointMake(minX + 0.10059 * w, minY + 0.47937 * h), controlPoint2:CGPointMake(minX + 0.17792 * w, minY + 0.57453 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.2188 * w, minY + 0.68163 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX, minY + 0.37025 * h), controlPoint1:CGPointMake(minX + 0.08741 * w, minY + 0.6157 * h), controlPoint2:CGPointMake(minX, minY + 0.5009 * h))
		clockPathPath.closePath()
		clockPathPath.moveToPoint(CGPointMake(minX + 0.47457 * w, minY + 0.1377 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.42428 * w, minY + 0.17694 * h), controlPoint1:CGPointMake(minX + 0.44677 * w, minY + 0.1377 * h), controlPoint2:CGPointMake(minX + 0.42428 * w, minY + 0.15528 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.42428 * w, minY + 0.37025 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.47457 * w, minY + 0.40949 * h), controlPoint1:CGPointMake(minX + 0.42428 * w, minY + 0.39191 * h), controlPoint2:CGPointMake(minX + 0.44677 * w, minY + 0.40949 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.75915 * w, minY + 0.40949 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.80945 * w, minY + 0.37025 * h), controlPoint1:CGPointMake(minX + 0.78694 * w, minY + 0.40949 * h), controlPoint2:CGPointMake(minX + 0.80945 * w, minY + 0.39191 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.75915 * w, minY + 0.33099 * h), controlPoint1:CGPointMake(minX + 0.80945 * w, minY + 0.34857 * h), controlPoint2:CGPointMake(minX + 0.78694 * w, minY + 0.33099 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.52487 * w, minY + 0.33099 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.52487 * w, minY + 0.17694 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.47457 * w, minY + 0.1377 * h), controlPoint1:CGPointMake(minX + 0.52487 * w, minY + 0.15528 * h), controlPoint2:CGPointMake(minX + 0.50233 * w, minY + 0.1377 * h))
		clockPathPath.closePath()
		clockPathPath.moveToPoint(CGPointMake(minX + 0.99842 * w, minY + 0.31069 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.97453 * w, minY + 0.29158 * h), controlPoint1:CGPointMake(minX + 0.99807 * w, minY + 0.30043 * h), controlPoint2:CGPointMake(minX + 0.98764 * w, minY + 0.29211 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.9483 * w, minY + 0.30874 * h), controlPoint1:CGPointMake(minX + 0.96197 * w, minY + 0.29102 * h), controlPoint2:CGPointMake(minX + 0.94996 * w, minY + 0.29851 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.94293 * w, minY + 0.34221 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.93353 * w, minY + 0.38129 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.91818 * w, minY + 0.42409 * h), controlPoint1:CGPointMake(minX + 0.92965 * w, minY + 0.39485 * h), controlPoint2:CGPointMake(minX + 0.92564 * w, minY + 0.40886 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.9069 * w, minY + 0.44982 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.89092 * w, minY + 0.47724 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.86737 * w, minY + 0.5118 * h), controlPoint1:CGPointMake(minX + 0.88521 * w, minY + 0.48849 * h), controlPoint2:CGPointMake(minX + 0.87655 * w, minY + 0.49981 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.85358 * w, minY + 0.53027 * h), controlPoint1:CGPointMake(minX + 0.8627 * w, minY + 0.51787 * h), controlPoint2:CGPointMake(minX + 0.858 * w, minY + 0.524 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.83993 * w, minY + 0.5451 * h), controlPoint1:CGPointMake(minX + 0.84896 * w, minY + 0.53515 * h), controlPoint2:CGPointMake(minX + 0.84443 * w, minY + 0.5401 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.80195 * w, minY + 0.58266 * h), controlPoint1:CGPointMake(minX + 0.82809 * w, minY + 0.55811 * h), controlPoint2:CGPointMake(minX + 0.81693 * w, minY + 0.57041 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.75685 * w, minY + 0.61864 * h), controlPoint1:CGPointMake(minX + 0.78894 * w, minY + 0.59534 * h), controlPoint2:CGPointMake(minX + 0.77332 * w, minY + 0.60666 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.7424 * w, minY + 0.62924 * h), controlPoint1:CGPointMake(minX + 0.752 * w, minY + 0.62218 * h), controlPoint2:CGPointMake(minX + 0.74717 * w, minY + 0.62568 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.72651 * w, minY + 0.63882 * h), controlPoint1:CGPointMake(minX + 0.73705 * w, minY + 0.63242 * h), controlPoint2:CGPointMake(minX + 0.73175 * w, minY + 0.63563 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.67285 * w, minY + 0.66831 * h), controlPoint1:CGPointMake(minX + 0.70899 * w, minY + 0.64947 * h), controlPoint2:CGPointMake(minX + 0.6925 * w, minY + 0.6595 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.62365 * w, minY + 0.68963 * h), controlPoint1:CGPointMake(minX + 0.65769 * w, minY + 0.67655 * h), controlPoint2:CGPointMake(minX + 0.64037 * w, minY + 0.68322 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.60299 * w, minY + 0.69772 * h), controlPoint1:CGPointMake(minX + 0.61666 * w, minY + 0.69232 * h), controlPoint2:CGPointMake(minX + 0.60972 * w, minY + 0.69498 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.57797 * w, minY + 0.70525 * h), controlPoint1:CGPointMake(minX + 0.59446 * w, minY + 0.70011 * h), controlPoint2:CGPointMake(minX + 0.58616 * w, minY + 0.70269 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.53287 * w, minY + 0.71715 * h), controlPoint1:CGPointMake(minX + 0.56265 * w, minY + 0.71002 * h), controlPoint2:CGPointMake(minX + 0.54819 * w, minY + 0.71452 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.49962 * w, minY + 0.72435 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.46693 * w, minY + 0.7287 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.42148 * w, minY + 0.73279 * h), controlPoint1:CGPointMake(minX + 0.45029 * w, minY + 0.73149 * h), controlPoint2:CGPointMake(minX + 0.43566 * w, minY + 0.73213 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.39484 * w, minY + 0.73438 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.39107 * w, minY + 0.73431 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.39107 * w, minY + 0.64275 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.37554 * w, minY + 0.62461 * h), controlPoint1:CGPointMake(minX + 0.39107 * w, minY + 0.63483 * h), controlPoint2:CGPointMake(minX + 0.38495 * w, minY + 0.62766 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.34811 * w, minY + 0.62886 * h), controlPoint1:CGPointMake(minX + 0.36611 * w, minY + 0.62159 * h), controlPoint2:CGPointMake(minX + 0.35534 * w, minY + 0.62325 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.13172 * w, minY + 0.79769 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.12436 * w, minY + 0.81156 * h), controlPoint1:CGPointMake(minX + 0.12701 * w, minY + 0.80137 * h), controlPoint2:CGPointMake(minX + 0.12436 * w, minY + 0.80637 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.13172 * w, minY + 0.82544 * h), controlPoint1:CGPointMake(minX + 0.12436 * w, minY + 0.81676 * h), controlPoint2:CGPointMake(minX + 0.12701 * w, minY + 0.82175 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.34812 * w, minY + 0.99427 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.36591 * w, minY + h), controlPoint1:CGPointMake(minX + 0.35294 * w, minY + 0.99801 * h), controlPoint2:CGPointMake(minX + 0.35937 * w, minY + h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.37555 * w, minY + 0.99851 * h), controlPoint1:CGPointMake(minX + 0.36915 * w, minY + h), controlPoint2:CGPointMake(minX + 0.37243 * w, minY + 0.99951 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.39108 * w, minY + 0.98036 * h), controlPoint1:CGPointMake(minX + 0.38496 * w, minY + 0.99547 * h), controlPoint2:CGPointMake(minX + 0.39108 * w, minY + 0.9883 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.39108 * w, minY + 0.88468 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.43739 * w, minY + 0.87807 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.51102 * w, minY + 0.8629 * h), controlPoint1:CGPointMake(minX + 0.45881 * w, minY + 0.87461 * h), controlPoint2:CGPointMake(minX + 0.48548 * w, minY + 0.87028 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.54078 * w, minY + 0.8551 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.59014 * w, minY + 0.83882 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.64969 * w, minY + 0.81474 * h), controlPoint1:CGPointMake(minX + 0.61094 * w, minY + 0.83242 * h), controlPoint2:CGPointMake(minX + 0.63064 * w, minY + 0.82343 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.67446 * w, minY + 0.80367 * h), controlPoint1:CGPointMake(minX + 0.65783 * w, minY + 0.81102 * h), controlPoint2:CGPointMake(minX + 0.66606 * w, minY + 0.80727 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.67712 * w, minY + 0.80236 * h), controlPoint1:CGPointMake(minX + 0.67538 * w, minY + 0.80327 * h), controlPoint2:CGPointMake(minX + 0.67624 * w, minY + 0.80284 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.69706 * w, minY + 0.7914 * h), controlPoint1:CGPointMake(minX + 0.68368 * w, minY + 0.79868 * h), controlPoint2:CGPointMake(minX + 0.69034 * w, minY + 0.79504 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.75633 * w, minY + 0.75581 * h), controlPoint1:CGPointMake(minX + 0.71738 * w, minY + 0.78039 * h), controlPoint2:CGPointMake(minX + 0.73837 * w, minY + 0.76898 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.81662 * w, minY + 0.71059 * h), controlPoint1:CGPointMake(minX + 0.77851 * w, minY + 0.74203 * h), controlPoint2:CGPointMake(minX + 0.79789 * w, minY + 0.72605 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.83022 * w, minY + 0.69943 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.83193 * w, minY + 0.69791 * h), controlPoint1:CGPointMake(minX + 0.8308 * w, minY + 0.69894 * h), controlPoint2:CGPointMake(minX + 0.83137 * w, minY + 0.69844 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.84424 * w, minY + 0.68576 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.89145 * w, minY + 0.63479 * h), controlPoint1:CGPointMake(minX + 0.86099 * w, minY + 0.66933 * h), controlPoint2:CGPointMake(minX + 0.87836 * w, minY + 0.65228 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.92791 * w, minY + 0.58479 * h), controlPoint1:CGPointMake(minX + 0.90615 * w, minY + 0.61841 * h), controlPoint2:CGPointMake(minX + 0.91721 * w, minY + 0.60133 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.939 * w, minY + 0.5679 * h), controlPoint1:CGPointMake(minX + 0.93158 * w, minY + 0.57908 * h), controlPoint2:CGPointMake(minX + 0.93526 * w, minY + 0.57343 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.94034 * w, minY + 0.56557 * h), controlPoint1:CGPointMake(minX + 0.93949 * w, minY + 0.56713 * h), controlPoint2:CGPointMake(minX + 0.93997 * w, minY + 0.56636 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.95081 * w, minY + 0.54499 * h), controlPoint1:CGPointMake(minX + 0.94369 * w, minY + 0.55855 * h), controlPoint2:CGPointMake(minX + 0.94727 * w, minY + 0.55171 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.97122 * w, minY + 0.4996 * h), controlPoint1:CGPointMake(minX + 0.95862 * w, minY + 0.53009 * h), controlPoint2:CGPointMake(minX + 0.96668 * w, minY + 0.5147 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.98284 * w, minY + 0.46741 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.98943 * w, minY + 0.43909 * h))
		clockPathPath.addCurveToPoint(CGPointMake(minX + 0.99757 * w, minY + 0.38829 * h), controlPoint1:CGPointMake(minX + 0.9947 * w, minY + 0.42043 * h), controlPoint2:CGPointMake(minX + 0.99622 * w, minY + 0.40335 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + w, minY + 0.36268 * h))
		clockPathPath.addLineToPoint(CGPointMake(minX + 0.99842 * w, minY + 0.31069 * h))
		clockPathPath.closePath()
		clockPathPath.moveToPoint(CGPointMake(minX + 0.99842 * w, minY + 0.31069 * h))
		
		return clockPathPath;
	}
	
	
}
