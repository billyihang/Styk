//
//  MasterTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/15/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

protocol ProjectSelectionDelegate: class {
    func projectSelected(_ project: Project, indexPath: IndexPath)
}

class MasterTableViewController: UITableViewController, taskTableViewControllerDelegate {

    //MARK: - Properties
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Project>!
    weak var delegate: ProjectSelectionDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - functions
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Navigation bar large title
        navigationController?.navigationBar.prefersLargeTitles = true

        // Navigation bar search and refresh
        // TODO: - implementation of search and refresh
        refreshControl = UIRefreshControl()
        navigationItem.searchController = searchController
        
        // Load Projects
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        tableView.reloadData()
    }
    
    // Get projects from global user
    func refresh() {
        let request = Project.fetchRequest() as NSFetchRequest<Project>
        let sort = NSSortDescriptor(keyPath: \Project.sort, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedRC.delegate = self
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (fetchedRC.fetchedObjects?.isEmpty)! {
            let projects = ProjectData.createProjects()
            for i in 0...1 {
                let projectGenerated: ProjectData = projects[i]
                let project = Project(entity: Project.entity(), insertInto: context)
                project.name = projectGenerated.name
                project.color = projectGenerated.color
                project.colorString = projectGenerated.colorString
                project.deletable = projectGenerated.deletable
                project.sort = Int16(i)
            }
            appDelegate.saveContext()
            refresh()
        }
    }
    
    func didAddNewTask() {
        // Update projects from global user
        refresh()
        tableView.reloadData()
        
    }
    
    // IBAction functions
    @IBAction func cancelFromNewProject(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveFromNewProject(_ segue: UIStoryboardSegue) {
        
        // Get AddProjectVC
        guard let addProjectViewController = segue.source as? AddProjectTableViewController,
            let project = addProjectViewController.project
            else {return}
        
        // Add new project to Core Data
        let newProject = Project(entity: Project.entity(), insertInto: context)
        newProject.name = project.name
        newProject.color = project.color
        newProject.deletable = project.deletable
        guard let count = fetchedRC.fetchedObjects?.count else {
         appDelegate.saveContext()
            return
        }
        let num: Int16 = Int16(count)
        newProject.sort = num
        appDelegate.saveContext()
        
    }
    
    @IBAction func saveFromDeleteProject(_ segue: UIStoryboardSegue) {
        
    }
}

// MARK: - FetchRC Delegate
extension MasterTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
    
}

// MARK: - Table view data source
extension MasterTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projs = fetchedRC.fetchedObjects else {
            return 0
        }
        return projs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProjectsTableViewCell
            else {
                print("Projects cells didn't load")
                fatalError()
        }
        let project = fetchedRC.object(at: indexPath)
        // Set cell UI
        cell.projectLabel.text = project.name
        cell.colorLabel.backgroundColor = project.color as? UIColor
        cell.colorLabel.layer.cornerRadius = cell.colorLabel.bounds.size.width/2
        cell.colorLabel.clipsToBounds = true

        cell.taskCountLabel.text = String((project.tasks?.count)!)
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Pass project on to TasksViewController
        let project = fetchedRC.object(at: indexPath)
        delegate?.projectSelected(project, indexPath: indexPath)
        
        // Random stuff, forgot what
        if let taskViewController = delegate as? TasksTableViewController,
            let detailViewNavigationController = taskViewController.navigationController {
            taskViewController.delegate = self
            splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
