//
//  ViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var posts = [FivePxPost]()
    let client = FivePxClient.sharedInstance()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client.getPostsWithFeature(FivePxConstants.ParameterValues.Feature.Popular) { (success, error) in
            if success {
                self.posts = self.client.fivePxPosts
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewCell
        configurePhotoCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configurePhotoCell(cell: CollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.loadingIndicator.startAnimating()
        client.loadImageToImageViewWithURL(posts[indexPath.item].imageUrl, imageView: cell.imageView, completionHandlerForLoadImageView: { (success, error) in
                cell.loadingIndicator.stopAnimating()
        })
    }
}

//MARK: FlowLayout Configuration

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 2) - (spacing / 2)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

