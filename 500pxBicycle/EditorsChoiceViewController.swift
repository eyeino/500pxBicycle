//
//  EditorsChoiceViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/6/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import UIKit

class EditorsChoiceViewController: UIViewController {
    
    var feature = FivePxConstants.ParameterValues.Feature.EditorsChoice
    var posts = [FivePxPost]()
    let client = FivePxClient.sharedInstance()
    let realmClient = RealmClient.sharedInstance()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadPosts()
        self.tabBarItem.selectedImage = UIImage(named: "pen_filled")!.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBarItem.image = UIImage(named: "pen")!.imageWithRenderingMode(.AlwaysOriginal)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func showAlert(error: NSError) {
        let localDesc = error.localizedDescription
        
        let alertController = UIAlertController(title: "Error", message: localDesc, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func downloadPosts() {
        client.getPostsWithFeature(feature) { (success, error) in
            if success {
                self.posts = self.client.fivePxPosts
                self.collectionView.reloadData()
            } else {
                if let error = error {
                    self.showAlert(error)
                }
            }
        }
    }
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
        downloadPosts()
    }
}

extension EditorsChoiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewCell
        configurePhotoCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configurePhotoCell(cell: CollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let postImageUrl = posts[indexPath.item].thumbnailUrl
        let postImageID = posts[indexPath.item].id
        let postImageTitle = posts[indexPath.item].name
        
        guard let image = realmClient.getThumbnailImage(fromID: postImageID) else {
            //no image found in realm, go download it and set it to the imageview
            cell.loadingIndicator.startAnimating()
            client.loadImageToImageViewWithURL(postImageUrl, imageView: cell.imageView) { (success, error, data) in
                if success {
                    //create a realm object with the image data downloaded
                    if let data = data {
                        self.realmClient.saveThumbnailData(withId: postImageID, data: data, title: postImageTitle)
                        cell.loadingIndicator.stopAnimating()
                    }
                } else {
                    cell.loadingIndicator.stopAnimating()
                }
            }
            return
        }
        
        //image retrieved from realm successfully, set imageview to it
        cell.imageView.image = image
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
        detailVC.post = posts[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: FlowLayout Configuration

extension EditorsChoiceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 2) - (spacing / 2)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
