//
//  ProfileVIewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/21/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileVIewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userField: UILabel!
    
    var instagramPosts: [PFObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        query()
        
        userField.text = " \((PFUser.currentUser()?.username)!)"


        // Do any additional setup after loading the view.
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

    
    func query() {
        // construct PFQuery
        let user = PFUser.currentUser()

        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: user!)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyPhotoCell", forIndexPath: indexPath) as! MyPhotoCell
        
        let row = indexPath.row
        let post = instagramPosts[row]
        
        cell.captionLabel.text = post["caption"] as? String
        
        
        
        let user = post["author"] as! PFUser
        let username: String = user.username!
        
        
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
