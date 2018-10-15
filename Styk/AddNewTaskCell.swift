
//
//  AddNewTaskCell.swift
//  Styk
//
//  Created by William Yang on 8/15/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

protocol AddTaskCellDelegate: class {
    func didAddNewTask(_ task: TaskData)
    func exitEditing()
}

class AddNewTaskCell: UITableViewCell {

    //MARK: - Properties
    weak var delegate: AddTaskCellDelegate?
    var project: Project?
    var date: Date?
    var startTime: Date?
    var endTime: Date?
    var startDate: Date?
    var endDate: Date?
    
    var datePicker: UIDatePicker?
    var startTimePicker: UIDatePicker?
    var endTimePicker: UIDatePicker?
    
    var datePickerToolbar: UIToolbar?
    var startTimeToolbar: UIToolbar?
    var endTimePickerToolbar: UIToolbar?
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePickerToolbar = UIToolbar()
        startTimeToolbar = UIToolbar()
        endTimePickerToolbar = UIToolbar()
        
        datePicker = UIDatePicker()
        startTimePicker = UIDatePicker()
        endTimePicker = UIDatePicker()
        dateTextField.inputView = datePicker
        startTimeTextField.inputView = startTimePicker
        endTimeTextField.inputView = endTimePicker
        dateTextField.inputAccessoryView = datePickerToolbar
        startTimeTextField.inputAccessoryView = startTimeToolbar
        endTimeTextField.inputAccessoryView = endTimePickerToolbar
        
        datePicker?.datePickerMode = .date
        startTimePicker?.datePickerMode = .time
        startTimePicker?.minuteInterval = 5
        endTimePicker?.datePickerMode = .time
        endTimePicker?.minuteInterval = 5
        
        // Done and nextbutton toolbar for datepicker
        datePickerToolbar?.sizeToFit()
        let dateDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneBtnPressed))
        let dateNextBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(dateNextBtnPressed))
        datePickerToolbar?.setItems([dateDoneBtn, dateNextBtn], animated: false)
        
        startTimeToolbar?.sizeToFit()
        let startDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(startTimeDoneBtnPressed))
        let startNextBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startTimeNextBtnPressed))
        startTimeToolbar?.setItems([startDoneBtn, startNextBtn], animated: false)
        
        endTimePickerToolbar?.sizeToFit()
        let endDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endTimeDoneBtnPressed))
        endTimePickerToolbar?.setItems([endDoneBtn], animated: false)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.inputView?.endEditing(true)
    }
    
    @objc func dateDoneBtnPressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        guard let date = datePicker?.date
            else {
                print("Date did not pick")
                return
        }
        self.dateTextField.text = formatter.string(from: date)
        self.date = date
        self.delegate?.exitEditing()
    }
    
    @objc func startTimeDoneBtnPressed() {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.short
        guard let date = startTimePicker?.date
            else {
                print("start time did not pick")
                return
        }
        self.startTimeTextField.text = formatter.string(from: date)
        self.startTime = date
        self.delegate?.exitEditing()
    }
    
    @objc func endTimeDoneBtnPressed() {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.short
        guard let date = endTimePicker?.date
            else {
                print("end time did not pick")
                return
        }
        self.endTimeTextField.text = formatter.string(from: date)
        self.endTime = date
        self.delegate?.exitEditing()
    }
    
    // Next button for date picker
    @objc func dateNextBtnPressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        guard let date = datePicker?.date
            else {
                print("Date did not pick")
                return
        }
        self.dateTextField.text = formatter.string(from: date)
        self.date = date
        self.startTimeTextField.becomeFirstResponder()
    }
    
    // Next button for start time picker
    @objc func startTimeNextBtnPressed() {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.short
        guard let date = startTimePicker?.date
            else {
                print("start time did not pick")
                return
        }
        self.startTimeTextField.text = formatter.string(from: date)
        self.startTime = date
        self.endTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        if titleTextField.hasText == true {
            guard let title = titleTextField.text,
            let project = self.project else {
                return
            }
            
            if let taskDate = self.date,
                let taskStartTime = self.startTime,
                let taskEndTime = self.endTime {
                
                let calendar = Calendar.current
                
                let startDateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: taskDate)
                let startTimeComponents = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: taskStartTime)
                var startComponents = DateComponents()
                startComponents.day = startDateComponents.day
                startComponents.month = startDateComponents.month
                startComponents.year = startDateComponents.year
                startComponents.minute = startTimeComponents.minute
                startComponents.hour = startTimeComponents.hour
                
                startDate = calendar.date(from: startComponents)
                
                let endDateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: taskDate)
                let endTimeComponents = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: taskEndTime)
                var endComponents = DateComponents()
                endComponents.day = endDateComponents.day
                endComponents.month = endDateComponents.month
                endComponents.year = endDateComponents.year
                endComponents.minute = endTimeComponents.minute
                endComponents.hour = endTimeComponents.hour
                
                endDate = calendar.date(from: endComponents)
                
                // TODO: - parse text to parts
                
                let task = TaskData(title: title, start: startDate!, end: endDate!, proj: project)
                self.delegate?.didAddNewTask(task)
            } else {
                let task = TaskData(title: title, proj: project)
                self.delegate?.didAddNewTask(task)
            }
            titleTextField.text = ""
            dateTextField.text = ""
            endTimeTextField.text = ""
            startTimeTextField.text = ""
        }
    }
}
