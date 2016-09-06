//
//  HistoryTableViewController.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/6/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import UIKit

class HistoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ids = [Int]()
    var titles = [String]()
    let realmClient = RealmClient.sharedInstance()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "past_filled")!.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBarItem.image = UIImage(named: "past")!.imageWithRenderingMode(.AlwaysOriginal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
        ids = realmClient.idsWithBigImages()
        titles = realmClient.titlesWithBigImages()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")! 
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
        detailVC.id = ids[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
