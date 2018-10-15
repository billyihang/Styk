//
//  TasksTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/15/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

protocol taskTableViewControllerDelegate: class {
    func didAddNewTask()
}

class TasksTableViewController: UITableViewController {
    
    
    //MARK: - Variables
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Task>!
    var project: Project!
    var projectIndexPath: IndexPath! // Index of project for editing project
    weak var delegate: taskTableViewControllerDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Navigation bar search and refresh
        // TODO: - implementation of search and refresh
        refreshControl = UIRefreshControl()
        //searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        self.tableView.separatorStyle = .none
        // Exit editing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exitEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = project.name
        refresh()
        tableView.reloadData()
    }

    func refresh() {
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.predicate = NSPredicate(format: "project = %@", project)
        let sort = NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)
        let name = NSSortDescriptor(keyPath: \Task.name, ascending: true)
        request.sortDescriptors = [sort, name]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedRC.delegate = self
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProject" {
            if let EditProjectVC = segue.destination.children.first as? EditProjectTableViewController,
                let project = project {
                EditProjectVC.project = project
                EditProjectVC.name = project.name
                EditProjectVC.colorName = project.colorString!
                EditProjectVC.indexPath = self.projectIndexPath
            }
        }
    }
    
    @IBAction func cancelFromEditProject(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveFromEditProject(_ segue: UIStoryboardSegue) {
        
        // Get AddProjectVC
            //guard let editProjectViewController = segue.source as? EditProjectTableViewController,
            //    let project = editProjectViewController.project
            //    else {return}
        
        refresh()
        tableView.reloadData()
        // Update TaskVC
            // projectSelected(project, indexPath: projectIndexPath)
        
        // Notify MasterVC
        delegate?.didAddNewTask()
    }
}

extension TasksTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        let realIndex = IndexPath(row: cellIndex.row, section: 1)
        
        switch type {
        case .insert:
            tableView.insertRows(at: [realIndex], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [realIndex], with: .automatic)
        default:
            break
        }
    }
}

extension TasksTableViewController: ProjectSelectionDelegate, AddTaskCellDelegate, regularTaskCellDelegate {
    
    // MARK: - delegate properties
    func projectSelected(_ project: Project, indexPath: IndexPath) {
        self.project = project
        // Set cells
        projectIndexPath = indexPath
        
        loadViewIfNeeded()
        tableView.reloadData()
        
        // Set title
        self.navigationItem.title = project.name
    }
    
    // Add new cell delegate function
    func didAddNewTask(_ task: TaskData) {
        
        // update core data
        let newTask = Task(entity: Task.entity(), insertInto: context)
        newTask.name = task.name
        newTask.startDate = task.startDate as NSDate?
        newTask.dueDate = task.endDate as NSDate?
        newTask.completed = false
        newTask.project = project
        appDelegate.saveContext()
        
        // let the project VC know
            //delegate?.didAddNewTask()
            //let count = tableView.numberOfRows(inSection: 1)
            //self.tableView.insertRows(at: [IndexPath(row: count, section: 1)], with: .automatic)
            //print(tableView.numberOfRows(inSection: 1))
    }
    
    func didCompleteTask(_ task: Task) {
        // Remove task from core data
        context.delete(task)
        appDelegate.saveContext()

    }
    
    
    @objc func exitEditing() {
        view.endEditing(true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let tasks = fetchedRC.fetchedObjects else {
                return 0
            }
            return tasks.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            // Task cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TasksTableViewCell
            {
                let index = IndexPath(row: indexPath.row, section: 0)
                
                guard let tasks = fetchedRC.fetchedObjects,
                    tasks.isEmpty == false
                    else {
                        return cell
                }
                
                let task = tasks[indexPath.row]
                
                cell.task = task
                cell.taskLabel.text = task.name
                cell.delegate = self
                
                cell.completedButton.setImage(UIImage(named: "checkmarkUnfilled"), for: .normal)
                
                if let dueDate = task.dueDate {
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "EEEE MMM dd HH:mm"
                    
                    // Set date of task
                    let dateString = formatter.string(from: dueDate as Date)
                    cell.timeLabel.text = dateString
                    cell.datePicker = UIDatePicker()
                    
                    // Set delegate and row
                    
                    cell.indexRow = indexPath.row
                    cell.indexPath = index
                    
                    return cell
                } else {
                    cell.timeLabel.text = ""
                    return cell
                }
            } else {
                print("Task cell didn't load")
                fatalError()
            }
        } else {
            // Add cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Add", for: indexPath) as? AddNewTaskCell {
                
                // Set cell delegate and project
                cell.delegate = self
                cell.project = self.project
                
                // Set cell textFields
                
                /*
                cell.datePickerToolbar = UIToolbar()
                cell.startTimeToolbar = UIToolbar()
                cell.endTimePickerToolbar = UIToolbar()
                
                cell.datePicker = UIDatePicker()
                cell.startTimePicker = UIDatePicker()
                cell.endTimePicker = UIDatePicker()
                cell.dateTextField.inputView = cell.datePicker
                cell.startTimeTextField.inputView = cell.startTimePicker
                cell.endTimeTextField.inputView = cell.endTimePicker
                cell.dateTextField.inputAccessoryView = cell.datePickerToolbar
                cell.startTimeTextField.inputAccessoryView = cell.startTimeToolbar
                cell.endTimeTextField.inputAccessoryView = cell.endTimePickerToolbar
                
                cell.datePicker?.datePickerMode = .date
                cell.startTimePicker?.datePickerMode = .time
                cell.endTimePicker?.datePickerMode = .time
                
                // Toolbar done button
                cell.datePickerToolbar?.sizeToFit()
                let dateDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(cell.dateDoneBtnPressed))
                cell.datePickerToolbar?.setItems([dateDoneBtn], animated: false)
                
                cell.startTimeToolbar?.sizeToFit()
                let startDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(cell.startTimeDoneBtnPressed))
                cell.startTimeToolbar?.setItems([startDoneBtn], animated: false)
                
                cell.endTimePickerToolbar?.sizeToFit()
                let endDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(cell.endTimeDoneBtnPressed))
                cell.endTimePickerToolbar?.setItems([endDoneBtn], animated: false)
                */
                
                // Round button and other setup
                cell.addTaskButton.layer.cornerRadius =  cell.addTaskButton.frame.size.width/2
                
                return cell
            } else {
                print ("Add cell didn't load")
                fatalError()
            }
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete" )
        { (action: UITableViewRowAction, indexPath: IndexPath) in
            // Remove task from core data
            let index = IndexPath(row: indexPath.row, section: 0)
            let task = self.fetchedRC.object(at: index)
            self.context.delete(task)
            self.appDelegate.saveContext()
            // Remove from table view
                //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // Update projects tableVC
                //self.delegate?.didAddNewTask()
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        } else {
            return 55
        }
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
// Search function
extension TasksTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, let tasks = self.tasks, !text.isEmpty {
            self.filtered = tasks.filter({ (task) -> Bool in
                return task.title.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [Task]()
        }
        self.tableView.reloadData()
    }
}
*/
