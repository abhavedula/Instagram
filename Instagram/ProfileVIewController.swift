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

class ProfileVIewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userField: UILabel!
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var profPicView: UIImageView!
    
    var instagramPosts: [PFObject] = []
    
    var chosenImage: UIImage?

    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
         picker.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        query()
        
        userField.text = " \((PFUser.currentUser()?.username)!)"
        
        let data = PFUser.currentUser()!["profPic"] as! NSData
        
        let pic = UIImage(data: data)
        
        profPicView.image = pic
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
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
    
    func loadMoreData() {
        
       query()
        
        // Update flag
        self.isMoreDataLoading = false
        
        // Stop the loading indicator
        self.loadingMoreView!.stopAnimating()
        
        // ... Use the new data to update the data source ...
        
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
       
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
    
    
    @IBAction func uploadProfPic(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
        
        
    }
    ///////////////////
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profPicView.contentMode = .ScaleAspectFit
        profPicView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
        let user = PFUser.currentUser()
        
        let imageData = chosenImage!.lowestQualityJPEGNSData
        
        user!["profPic"] = imageData
        
        user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success == true {
                print("saved")
            } else {
                print((error?.description)!)
                print("nooooo")
            }
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
