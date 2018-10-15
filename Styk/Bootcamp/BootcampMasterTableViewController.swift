//
//  BootcampMasterTableViewController.swift
//  Styk
//
//  Created by William Yang on 10/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

protocol BootcampDelegate: class {
    func taskSelected(task: BootcampTask, indexPath: IndexPath)
    func introSelected()
}

class BootcampMasterTableViewController: UITableViewController {

    // MARK: - Properties
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<BootcampTask>!
    private var userFetchedRC: NSFetchedResultsController<User>!
    weak var delegate: BootcampDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        userRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        let request = BootcampTask.fetchRequest() as NSFetchRequest<BootcampTask>
        let sort = NSSortDescriptor(keyPath: \BootcampTask.order, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (fetchedRC.fetchedObjects?.isEmpty)! {
            let tasks = Bootcamp.createTasks()
            for i in 0...6 {
                let task = tasks[i]
                let bcTask = BootcampTask(entity: BootcampTask.entity(), insertInto: context)
                bcTask.name = task.name
                bcTask.taskLongDescription = task.taskLongDescription
                bcTask.taskShortDescription = task.taskShortDescription
                bcTask.completed = false
                bcTask.order = Int16(i)
                if let imageName = task.imageName {
                    bcTask.imageName = imageName
                }
            }
            appDelegate.saveContext()
            refresh()
            tableView.reloadData()
        }
    }
    
    func userRefresh() {
        let request = User.fetchRequest() as NSFetchRequest<User>
        let sort = NSSortDescriptor(keyPath: \User.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            userFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try userFetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    
}

// MARK: - BootcampDetailViewController Delegate
extension BootcampMasterTableViewController: BootcampTaskDetailViewDelegate {
    func taskCompleted(indexPath: IndexPath) {
        let task = fetchedRC.object(at: indexPath)
        task.completed = true
        appDelegate.saveContext()
        refresh()
        tableView.reloadData()
    }
    
    func restartBootcamp() {
        if let tasks = fetchedRC.fetchedObjects {
            for task in tasks {
                context.delete(task)
            }
            appDelegate.saveContext()
            refresh()
        }
    }
}

// MARK: - Table view data source
extension BootcampMasterTableViewController {
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "intro", for: indexPath)
            let user = userFetchedRC.fetchedObjects?.first
            var color = user?.favoriteColor as! UIColor
            color = color.withAlphaComponent(0.5)
            cell.backgroundColor = color
            return cell
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "bootcamp", for: indexPath) as? BootcampTableViewCell {
                let index = IndexPath(row: indexPath.row, section: 0)
                let task = fetchedRC.object(at: index)
                cell.cellTitle.text = task.name
                cell.taskDescription.text = task.taskShortDescription
                cell.completionButton.layer.cornerRadius =  cell.completionButton.frame.size.width/2
                if task.completed == true {
                    cell.completionButton.setImage(UIImage(named: "checkmark"), for: .normal)
                } else {
                    cell.completionButton.setImage(UIImage(named: "checkmarkUnfilled"), for: .normal)
                }
                cell.delegate = self
                cell.indexPath = index
                return cell
            } else {
                print("Bootcamp cell didn't load")
                fatalError()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let index = IndexPath(row: indexPath.row, section: 0)
            let task = fetchedRC.object(at: index)
            delegate?.taskSelected(task: task, indexPath: index)
            
            if let detailViewController = delegate as? BootcampDetailViewController,
                let detailViewNavigationController = detailViewController.navigationController {
                detailViewController.delegate = self
                splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
            }
            
        } else {
            delegate?.introSelected()
            if let detailViewController = delegate as? BootcampDetailViewController,
                let detailViewNavigationController = detailViewController.navigationController {
                detailViewController.delegate = self
                splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else {
            return 55
        }
    }
  
}


