//
//  BootcampTableViewCell.swift
//  Styk
//
//  Created by William Yang on 10/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

class BootcampTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    
    // MARK: - Variables
    var completed = false
    var delegate: BootcampTaskDetailViewDelegate?
    var indexPath: IndexPath!
    var task: BootcampTask? {
        didSet {
            self.completed = task!.completed
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func completeButtonPressed(_ sender: Any) {
        if completed == false {
            completed = true
            self.completionButton.setImage(UIImage(named: "checkmark"), for: .normal)
            delegate?.taskCompleted(indexPath: indexPath)
        }
    }
}
