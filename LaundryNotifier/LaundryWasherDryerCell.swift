//
//  LaundryWasherDryerCell.swift
//  Purdue
//
//  Created by George Lo on 11/20/15.
//  Copyright © 2015 Purdue iOS Dev Club. All rights reserved.
//

import UIKit

class LaundryWasherDryerCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.statusLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 5
    }
    
}
