//
//  MyPhotoCell.swift
//  Instagram
//
//  Created by Abha Vedula on 6/21/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit

class MyPhotoCell: UITableViewCell {
    
    

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
