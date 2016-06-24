//
//  DetailViewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/22/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    
    var caption: String?
    var author: String?
    var image: PFFile?
    var time: NSDate?
    var profPic: NSData?
    var likes: String?
    

    @IBOutlet weak var profPicView: UIImageView!

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var likesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(time!)
        
        
        userLabel.text = author
        captionLabel.text = caption
        timeLabel.text = dateString
        likesLabel.text = "Likes: \(likes!)"
        
        image!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                if let imageData = imageData {
                    self.photoView.image = UIImage(data:imageData)
                    
                    
                }
            } else {
                print("Error: \(error)")
            }
        }
        
        let profPicImage = UIImage(data: profPic!)
        
        profPicView.image = profPicImage



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
