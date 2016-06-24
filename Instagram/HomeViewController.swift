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


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var caption: String?
    var author: String?
    var image: PFFile?
    var time: NSDate?
    var profPic: NSData?
    var user: PFUser?
    
    var profileButtonRow: Int?
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
   
    var instagramPosts: [PFObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        query()
        
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.separatorColor = UIColor.clearColor()

       

    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
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
                self.instagramPosts = posts
            } else {
                // handle error
            }
            self.tableView.reloadData()
        }
    }
    

    
    @IBAction func profileButton(sender: AnyObject) {
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PhotoCell {
                    profileButtonRow = tableView.indexPathForCell(cell)?.row
                }
            }
        }
        

        self.performSegueWithIdentifier("profileSegue", sender: nil)
    }
    
    
    @IBAction func likeButton(sender: AnyObject) {
        
        var row: Int!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PhotoCell {
                    row = tableView.indexPathForCell(cell)?.row
                }
            }
        }
        
        let post = instagramPosts[row]
        let likes = post["likesCount"] as! Int
        let newLikes = likes + 1
        
        post["likesCount"] = newLikes
        
        post.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success == true {
            } else {
                print(error?.description)
            }
        }
        self.tableView.reloadData()
    }
    
    
    func loadMoreData() {
        
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        //query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.instagramPosts = posts
            } else {
                // handle error
            }
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        }
        //print(instagramPosts.count)
        
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        query()
        tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

       
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let row = indexPath.row
        
        let post = instagramPosts[row]
        
        cell.captionLabel.text = post["caption"] as? String
        
        
        let user = post["author"] as? PFUser
        let username: String = (user?.username)!
        
        
        cell.authorLabel.text = username
        
        cell.likesLabel.text = "Likes: \(String(post["likesCount"]!))"

        
        
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
        
        let poster = post["author"] as! PFUser
        
        let data = poster["profPic"] as! NSData
        
        let profPic = UIImage(data: data)
        
        cell.profPicView.image = profPic
        
        
        let fontSize = cell.authorLabel.font.pointSize;
        cell.authorLabel.font = UIFont(name: "Impact", size: fontSize)
                

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramPosts.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       if segue.identifier == "DetailSegue" {
        let indexPathDetail = tableView.indexPathForCell(sender as! PhotoCell)
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        
        let post = instagramPosts[indexPathDetail!.row]
        
        caption = post["caption"] as? String
        
        time = post.createdAt!
        
        let user = post["author"] as! PFUser
        let username: String = user.username!
        
        author = username
        
        image = post["media"] as? PFFile
        
        let poster = post["author"] as! PFUser
        
        let data = poster["profPic"] as! NSData
        
        
        profPic = data
        
        
        detailViewController.caption = self.caption
        detailViewController.author = self.author
        detailViewController.image = self.image
        detailViewController.time = self.time
        detailViewController.profPic = self.profPic
        

        } else if segue.identifier == "profileSegue" {
        let detailViewController = segue.destinationViewController as! ProfileClickViewController
        
            let post = instagramPosts[profileButtonRow!]
            image = post["media"] as? PFFile
            caption = post["caption"] as? String
            user = post["author"] as! PFUser
            let username: String = user!.username!
            author = username
            let poster = post["author"] as! PFUser
        
            let data = poster["profPic"] as! NSData
        
        
            profPic = data
        
        detailViewController.caption = self.caption
        detailViewController.author = self.author
        detailViewController.image = self.image
        detailViewController.profPic = self.profPic
        detailViewController.user = self.user


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
