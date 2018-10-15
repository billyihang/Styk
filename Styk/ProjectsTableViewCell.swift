//
//  ProjectsTableViewCell.swift
//  Styk
//
//  Created by William Yang on 8/17/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
