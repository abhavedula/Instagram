//
//  ProfileClickViewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/23/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import ParseUI

class ProfileClickViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var caption: String?
    var author: String?
    var image: PFFile?
    var profPic: NSData?
    var user: PFUser?
    
    var instagramPosts: [PFObject] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profPicView: UIImageView!

    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let profPicImage = UIImage(data: profPic!)
        
        profPicView.image = profPicImage

         userLabel.text = " \(author!)"

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfilePhotoCell", forIndexPath: indexPath) as! ProfilePhotoCell
        
        let row = indexPath.row
        let post = instagramPosts[row]
        
        cell.captionLabel.text = post["caption"] as? String
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func query() {
        // construct PFQuery
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
