//
//  TasksTableViewCell.swift
//  Styk
//
//  Created by William Yang on 8/17/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

protocol regularTaskCellDelegate {
    func didCompleteTask(_ task: Task)
}

class TasksTableViewCell: UITableViewCell {

    //MARK: - Properties
    var delegate: regularTaskCellDelegate?
    var indexRow: Int?
    var indexPath: IndexPath?
    var task: Task!
    var completed = false
    
    //MARK: IBOutlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    var datePicker: UIDatePicker?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if completed == false {
            completedButton.setImage(UIImage(named: "checkmarkUnfilled"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    //MARK: - actions
    @IBAction func completeButtonPressed(_ sender: Any) {
        completedButton.setImage(UIImage(named: "checkmark"), for: .normal)
        delegate?.didCompleteTask(task)
    }
    
}
