//
//  CurrentTaskViewController.swift
//  Styk
//
//  Created by William Yang on 8/16/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

protocol CurrentTaskDelegate: class {
    func completedTask(task: Task)
    func noTask()
}

class CurrentTaskViewController: UIViewController, CurrentTaskViewDelegate {
    

    //MARK: - IBOutlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var completeTaskButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    
    //MARK: - Variables
    weak var delegate: CurrentTaskDelegate?
    var startTime: Date?
    var endTime: Date?
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI
            // Round Corners
        colorButton.layer.cornerRadius = colorButton.frame.size.width/2
        view.layer.cornerRadius = 30
        
        if let task = task {
            // Set color to project color
            if let color = task.project?.color {
                colorButton.backgroundColor = color as? UIColor
            } else {
                colorButton.backgroundColor = UIColor(red:0.00, green:0.00, blue:1.00, alpha:1.0)
            }
            
            // Set task and title
            self.task = task
            taskLabel.text = task.name
            
            // Setup times
            guard let start = task.startDate
                else {
                    print ("CurrentTastC no start date")
                    return
            }
            guard let end = task.dueDate
                else {
                    print ("CurrentTastC no end date")
                    return
            }
            
            startTime = start as Date
            endTime = end as Date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd HH:mm"
            let startString = formatter.string(from: start as Date)
            formatter.dateFormat = "HH:mm"
            let endString = formatter.string(from: end as Date)
            
            dateTimeLabel.text = "\(startString) to \(endString)"
        } else {
            self.delegate?.noTask()
        }
    }

    func updateTask(_ task: Task) {

        if let color = task.project?.color {
            colorButton.backgroundColor = color as? UIColor
        } else {
            colorButton.backgroundColor = UIColor(red:0.00, green:0.00, blue:1.00, alpha:1.0)
        }
        
        // Set title
        self.task = task
        taskLabel.text = task.name
        
        // Setup times
        guard let start = task.startDate
            else {
                print ("CurrentTastC no start date")
                return
        }
        guard let end = task.dueDate
            else {
                print ("CurrentTastC no end date")
                return
        }
        
        startTime = start as Date
        endTime = end as Date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm"
        let startString = formatter.string(from: start as Date)
        formatter.dateFormat = "HH:mm"
        let endString = formatter.string(from: end as Date)
        
        dateTimeLabel.text = "\(startString) to \(endString)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func completedTask(_ sender: Any) {
        
        self.completeTaskButton.setImage(UIImage(named: "checkmark"), for: .normal)
        delegate?.completedTask(task: task!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
