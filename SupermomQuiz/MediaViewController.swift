//
//  MediaViewController.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 8/2/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, UIScrollViewDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var localImagePath: String?
        {
        didSet {
            ColorLog.blue(localImagePath)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.hideActivityIndicator()
        var image = UIImage()
        
        if let img = localImagePath {
            image = UIImage(contentsOfFile: img)!
            imageView = UIImageView(image: image)
            imageView.frame = CGRect(origin: CGPointZero, size: image.size)
            scrollView.addSubview(imageView)
            scrollView.contentSize = image.size
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.delegate = self
        setupGestureRecognizer()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setZoomScale()
        
        let widthScale = scrollView.frame.size.width / scrollView.contentSize.width
        let heightScale = scrollView.frame.size.height / scrollView.contentSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = min(widthScale, heightScale)
        
        scrollView.frame = self.view.frame
        
        let verticalShift = (scrollView.frame.height - scrollView.contentSize.height) / 2.0
        scrollView.contentInset.top = verticalShift
        let horizontalShift = (scrollView.frame.width - scrollView.contentSize.width) / 2.0
        scrollView.contentInset.left = horizontalShift
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        localImagePath = nil
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func setZoomScale() {
        let widthScale = scrollView.frame.size.width / scrollView.contentSize.width
        let heightScale = scrollView.frame.size.height / scrollView.contentSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = min(widthScale, heightScale)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "zoomOnDoubleTapped:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func zoomOnDoubleTapped(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}
