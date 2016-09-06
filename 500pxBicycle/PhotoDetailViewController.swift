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
    var id: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: #selector(PhotoDetailViewController.delete(_:)))
        
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
                
                //create a realm object with the image data downloaded
                if let data = data {
                    self.realmClient.updateImageData(withId: postImageID, data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
            return
        }
        
        //image retrieved from realm successfully, set imageview to it
        imageView.image = image
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
}