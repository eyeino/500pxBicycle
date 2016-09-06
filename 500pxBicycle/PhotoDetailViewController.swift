//
//  PhotoDetailViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//
//  ScrollView methods adapted from Ray Wenderlich: https://www.raywenderlich.com/122139/uiscrollview-tutorial

import UIKit

class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let fivePxClient = FivePxClient.sharedInstance()
    let realmClient = RealmClient.sharedInstance()
    var post: FivePxPost?
    var id: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageViewImage()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    @IBAction override func delete(sender: AnyObject?) {
        guard let postId = post?.id else {
            if let integerId = id {
                realmClient.purgeImageFromRealm(withId: integerId)
                self.navigationController?.popViewControllerAnimated(true)
            }
            return
        }
        realmClient.purgeImageFromRealm(withId: postId)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func configureUI() {
        self.scrollView.delegate = self
        
        self.tabBarController?.tabBar.hidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: #selector(PhotoDetailViewController.delete(_:)))
    }
    
    func setImageViewImage() {
        guard let postImageUrl = post?.imageUrl, let postImageID = post?.id else {
            //no valid post passed into view controller... see if id integer was passed in instead
            if let id = id, image = realmClient.getBigImage(fromID: id) {
                imageView.image = image
            }
            return
        }
        
        guard let image = realmClient.getBigImage(fromID: postImageID) else {
            //no image found in realm, go download it and set it to the imageview
            activityIndicator.startAnimating()
            fivePxClient.loadImageToImageViewWithURL(postImageUrl, imageView: imageView) { (success, error, data) in
                if success {
                    //create a realm object with the image data downloaded
                    if let data = data {
                        self.realmClient.updateImageData(withId: postImageID, data: data)
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    if let error = error {
                        self.activityIndicator.stopAnimating()
                        self.showAlert(error)
                    }
                }
            }
            return
        }
        
        //image retrieved from realm successfully, set imageview to it
        imageView.image = image
    }
    
    func showAlert(error: NSError) {
        let localDesc = error.localizedDescription
        
        let alertController = UIAlertController(title: "Error", message: localDesc, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}