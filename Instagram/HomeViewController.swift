//
//  HomeViewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/20/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var instagramPosts: [PFObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        query()

        
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        query()
        tableView.reloadData()
        
        refreshControl.endRefreshing()
        
            }
    
    func query() {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            
            if let posts = posts {
                // do something with the data fetched
                self.instagramPosts = posts
                
                //print(self.instagramPosts)
                
            } else {
                print(error?.localizedDescription)
                
            }
            self.tableView.reloadData()
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        self.performSegueWithIdentifier("SignOutSegue", sender: nil)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let row = indexPath.row
        let post = instagramPosts[row]
        
        cell.captionLabel.text = post["caption"] as? String
        
        
        
        let user = post["author"] as! PFUser
        let username: String = user.username!
        
        cell.authorLabel.text = username
        
        let pic = post["media"] as? PFFile
        
        pic!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                if let imageData = imageData {
                    cell.photoView.image = UIImage(data:imageData)
                    
                }
            } else {
                print("Error: \(error)")
            }
        }
        
        let fontSize = cell.authorLabel.font.pointSize;
        cell.authorLabel.font = UIFont(name: "Impact", size: fontSize)
        

        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramPosts.count
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
