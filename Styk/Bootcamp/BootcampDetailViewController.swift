//
//  BootcampDetailViewController.swift
//  Styk
//
//  Created by William Yang on 10/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

protocol BootcampTaskDetailViewDelegate: class {
    func taskCompleted(indexPath: IndexPath)
    func restartBootcamp()
}

class BootcampDetailViewController: UIViewController {

    // MARL: - IBOutlets
    
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completeStack: UIStackView!
    @IBOutlet weak var restartBootcamp: UIButton!
    // MARK: - properties
    var bctask: BootcampTask?
    
    var completed = false
    var taskTitleString = "Title"
    var taskDescriptionString = "Description"
    var imageName = "checkmark"
    var isIntro = false
    var taskIndexPath: IndexPath = IndexPath()
    var delegate: BootcampTaskDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDescription.isScrollEnabled = false
        taskDescription.allowsEditingTextAttributes = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func completeButtonPressed(_ sender: Any) {
        if self.completed == false {
            self.completed = true
            completeButton.setImage(UIImage(named: "checkmark"), for: .normal)
            delegate?.taskCompleted(indexPath: taskIndexPath)
        }
    }

    @IBAction func restartBootcampButtonPressed(_ sender: Any) {
        delegate?.restartBootcamp()
    }
    
    // MARK: - Functions
    func refreshUI() {
        loadViewIfNeeded()
        if isIntro == false {
            taskImageView.image = UIImage(named: imageName)
            taskTitle.text = taskTitleString
            taskDescription.text = taskDescriptionString
            completeStack.isHidden = false
            restartBootcamp.isHidden = true
            if completed == false {
                completeButton.setImage(UIImage(named:"checkmarkUnfilled"), for: .normal)
            } else {
                completeButton.setImage(UIImage(named:"checkmark"), for: .normal)
            }
        } else {
            taskImageView.image = UIImage(named: imageName)
            taskTitle.text = taskTitleString
            taskDescription.text = taskDescriptionString
            completeStack.isHidden = true
            restartBootcamp.isHidden = false
        }
        
    }
    
}

extension BootcampDetailViewController: BootcampDelegate {
    
    func taskSelected(task: BootcampTask, indexPath: IndexPath) {
        completed = task.completed
        self.taskTitleString = task.name!
        self.taskDescriptionString = task.taskLongDescription!
        taskIndexPath = indexPath
        isIntro = false
        if let imageName = task.imageName {
            self.imageName = imageName
        }
        refreshUI()
    }
    
    func introSelected() {
        taskTitleString = "Welcome to the Productivity Bootcamp!"
        taskDescriptionString = "This bootcamp is designed to help you increase your productivity and achieve more with your time. Every day for a week, you will have one specific goal to accomplish for that day. "
        isIntro = true
        imageName = "Mountains"
        refreshUI()
    }
}
