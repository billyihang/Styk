//
//  CurrentTaskViewController.swift
//  Styk
//
//  Created by William Yang on 8/16/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

protocol CurrentTaskDelegate {
}

class CurrentTaskViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var completeTaskButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    
    
    //MARK: - Variables
    var delegate: CurrentTaskDelegate?
    var time: Date?
    var task: ToDoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI
            // Round Corners
        colorLabel.layer.cornerRadius = colorLabel .frame.size.width/2
            // Set color to project color
        if let color = task?.project?.color {
            colorLabel.backgroundColor = Color.toUIColor(color)
        } else {
            colorLabel.backgroundColor = UIColor(red:0.00, green:0.00, blue:1.00, alpha:1.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
