//
//  ColorTableViewCell.swift
//  Styk
//
//  Created by William Yang on 10/13/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorLabel.layer.cornerRadius = colorLabel.bounds.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
