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
        
        self.tabBarItem.selectedImage = UIImage(named: "past_filled")!.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "past")!.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        ids = realmClient.idsWithBigImages()
        titles = realmClient.titlesWithBigImages()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! HistoryTableViewCell
        cell.imageView?.image = nil
        cell.titleLabel?.text = titles[(indexPath as NSIndexPath).row]
        cell.imageView?.image = realmClient.getThumbnailImage(fromID: ids[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        detailVC.id = ids[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            realmClient.purgeImageFromRealm(withId: ids[(indexPath as NSIndexPath).row])
            ids.remove(at: (indexPath as NSIndexPath).row)
            titles.remove(at: (indexPath as NSIndexPath).row)
            tableView.reloadData()
        }
    }
    
}
