//
//  PhotoDetailViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    let fivePxClient = FivePxClient.sharedInstance()
    let realmClient = RealmClient.sharedInstance()
    var post: FivePxPost?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let postImageUrl = post?.imageUrl, let postImageID = post?.id else {
            //no valid post passed into view controller... weird
            return
        }
        
        guard let image = realmClient.getImage(fromID: postImageID) else {
            //no image found in realm, go download it and set it to the imageview
            activityIndicator.startAnimating()
            fivePxClient.loadImageToImageViewWithURL(postImageUrl, imageView: imageView) { (success, error, data) in
                
                //create a realm object with the image data downloaded
                if let data = data {
                    self.realmClient.saveImageDataWithID(postImageID, data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
            return
        }
        
        //image retrieved from realm successfully, set imageview to it
        imageView.image = image
    }
}