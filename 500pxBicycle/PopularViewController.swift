//
//  ViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class PopularViewController: UIViewController {

    var feature = FivePxConstants.ParameterValues.Feature.Popular
    var posts = [FivePxPost]()
    var nsfwMode = false
    let client = FivePxClient.sharedInstance()
    let realmClient = RealmClient.sharedInstance()
    var totalPages: Int?
    var totalItems: Int?
    var currentPage: Int = 1
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedCellLabel: UILabel!
    @IBOutlet weak var nsfwButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureDropDownMenu()
        configureRefreshControl()
        
        downloadPosts(1)
        self.tabBarItem.selectedImage = UIImage(named: "star_filled")!.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "star")!.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func showAlert(_ error: Error) {
        let localDesc = error.localizedDescription
        
        let alertController = UIAlertController(title: "Error", message: localDesc, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func downloadPosts(_ page: Int) {
        nsfwButton.isEnabled = false
        client.getPostsWithFeature(feature, page: page, allowNSFW: nsfwMode) { (success, error) in
            if success {
                self.totalPages = self.client.totalPages
                self.posts = self.client.fivePxPosts
                self.refreshControl?.endRefreshing()
                self.nsfwButton.isEnabled = true
                self.collectionView.reloadData()
            } else {
                if let error = error {
                    self.showAlert(error)
                    self.nsfwButton.isEnabled = true
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func configureDropDownMenu() {
        let items = ["Popular", "Highest Rated", "Upcoming", "Editor's Choice", "Fresh Today", "Fresh Yesterday", "Fresh Weekly"]
        let parameter = [FivePxConstants.ParameterValues.Feature.Popular,
                         FivePxConstants.ParameterValues.Feature.HighestRated,
                         FivePxConstants.ParameterValues.Feature.Upcoming,
                         FivePxConstants.ParameterValues.Feature.EditorsChoice,
                         FivePxConstants.ParameterValues.Feature.FreshToday,
                         FivePxConstants.ParameterValues.Feature.FreshYesterday,
                         FivePxConstants.ParameterValues.Feature.FreshWeek]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Popular", items: items as [AnyObject])
        
        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> () in
            self!.feature = parameter[indexPath]
            self!.totalPages = nil
            self!.downloadPosts(1)
        }
        
        self.navigationItem.titleView = menuView
    }
    
    @IBAction func nsfwButtonTapped(_ sender: UIBarButtonItem) {
        if nsfwMode {
            nsfwMode = false
            nsfwButton.image = UIImage(named: "restrict")
            nsfwButton.tintColor = UIColor.gray
            let randomPage = createRandomPage()
            downloadPosts(randomPage)
        } else {
            nsfwMode = true
            nsfwButton.image = UIImage(named: "restrict_filled")
            nsfwButton.tintColor = UIColor.red
            let randomPage = createRandomPage()
            downloadPosts(randomPage)
        }
    }
    
    func refreshForRefreshControl() {
        let randomPage = createRandomPage()
        downloadPosts(randomPage)
    }
    
    func configureRefreshControl() {
        if self.refreshControl == nil {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = UIColor.gray
            refreshControl.addTarget(self, action: #selector(refreshForRefreshControl), for: UIControlEvents.valueChanged)
            collectionView.addSubview(refreshControl)
            collectionView.alwaysBounceVertical = true
            self.refreshControl = refreshControl
        }
    }
    
    func createRandomPage() -> Int {
        var randomPage = 1
        if totalPages != nil {
            //TODO: Figure out how many pages deep 500px lets you search (like Flickr's 40 page limit), since this commented out implementation is buggy. Some pages load, some don't.
            //if let totalPages = totalPages {
            //randomPage = Int(arc4random_uniform(UInt32(totalPages))) + 1
            //}
            randomPage = Int(arc4random_uniform(UInt32(10))) + 1
        }
        
        //ensure the randomly generated page isn't equal to the page you already loaded
        while currentPage == randomPage {
            randomPage = Int(arc4random_uniform(UInt32(10))) + 1
        }
        
        currentPage = randomPage
        return randomPage
    }
}

extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! CollectionViewCell
        configurePhotoCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configurePhotoCell(_ cell: CollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.imageView.image = nil
        
        let postImageUrl = posts[(indexPath as NSIndexPath).item].thumbnailUrl
        let postImageID = posts[(indexPath as NSIndexPath).item].id
        let postImageTitle = posts[(indexPath as NSIndexPath).item].name
        
        guard let image = realmClient.getThumbnailImage(fromID: postImageID) else {
            //no image found in realm, go download it and set it to the imageview
            cell.loadingIndicator.startAnimating()
            client.loadImageToImageViewWithURL(postImageUrl, imageView: cell.imageView) { (success, error, data) in
                if success {
                    //create a realm object with the image data downloaded
                    if let data = data {
                        self.realmClient.saveThumbnailData(withId: postImageID, data: data as NSData, title: postImageTitle)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        detailVC.post = posts[(indexPath as NSIndexPath).item]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: FlowLayout Configuration

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 2) - (spacing / 2)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

