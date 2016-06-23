//
//  PhotoCell.swift
//  Instagram
//
//  Created by Abha Vedula on 6/21/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoCell: UITableViewCell {
    
   
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var profPicView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
