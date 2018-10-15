//
//  EditProjectTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/25/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

/*
 protocol EditProjectDelegate {
 func deleteProject(_ project: Project, row: Int)
 }
 */

class EditProjectTableViewController: UITableViewController {
    
    // MARK: - Properties
    var project: Project! {
        didSet {
            self.name = project.name
            self.colorName = project.colorString!
        }
    }
    var name: String?
    lazy var colorHex: String = Color.toHex(self.colorName) // Hex
    var colorName: String = "Red" {
        didSet {
            let colorHex = Color.toHex(colorName)
            self.colorHex = colorHex
            
        }
    }
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Project>!
    
    //var delegate: EditProjectDelegate?
    var indexPath: IndexPath!
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = name {
            self.titleTextField.text = title
        }
        
        let colorHex = Color.toHex(colorName)
        self.colorHex = colorHex
        
        colorLabel.text = "    \(colorName)"
        
        colorLabel.textColor = Color.toUIColor(colorHex)
        
        if project?.deletable == false {
            deleteButton.isEnabled = false
        }
        refresh()
    }
    
    func refresh() {
        let request = Project.fetchRequest() as NSFetchRequest<Project>
        let sort = NSSortDescriptor(keyPath: \Project.sort, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickColor" {
            if let colorPickerVC = segue.destination as? PickColorTableViewController {
                colorPickerVC.selectedColorName = colorName
            }
        }
        if segue.identifier == "SaveProjectFromEdit" {
            let proj = fetchedRC.object(at: indexPath)
            if let title = titleTextField?.text,
                (titleTextField?.hasText)! {
                proj.name = title
            }
            proj.color = Color.toUIColor(colorHex)
            proj.colorString = colorName
            self.appDelegate.saveContext()
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let deleteProjectAlert = UIAlertController(title: "Delete Project?", message: "Are you sure you want to delete this project? This action is permanent", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete Project", style: .destructive) { (action: UIAlertAction) in
            let deletingproject = self.fetchedRC.object(at: self.indexPath)
            self.context.delete(deletingproject)
            self.appDelegate.saveContext()
            
            self.performSegue(withIdentifier: "deleteProject", sender: nil)
            /*
            guard let rootViewController = self.navigationController?.navigationController?.topViewController as? TasksTableViewController else {
                return
            }
            if rootViewController.splitViewController!.isCollapsed {
                let detailNavController = rootViewController.parent as! UINavigationController
                let masterNavController = detailNavController.parent as! UINavigationController
                masterNavController.popToRootViewController(animated: true)
            }
 */
        }
        deleteProjectAlert.addAction(deleteAction)
        deleteProjectAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(deleteProjectAlert, animated: true, completion: nil)
    }
    
    
    /* Color background function
     func changeColorLabelColor(_ hex: String) {
     self.colorLabel.backgroundColor = Color.toUIColor(hex)
     self.colorLabel.layer.backgroundColor = Color.toUIColor(hex).cgColor
     }
     */
    
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            titleTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - IBActions
    @IBAction func unwindWithSelectedColor(segue: UIStoryboardSegue) {
        if let colorPickerVC = segue.source as? PickColorTableViewController {
            guard let chosenColorName = colorPickerVC.selectedColorName,
                let chosenColorHex = colorPickerVC.selectedColorHex
                else { return }
            
            self.colorHex = chosenColorHex
            self.colorName = chosenColorName
            
            colorLabel.text = "    \(colorName)"
            colorLabel.textColor = Color.toUIColor(chosenColorHex)
        }
    }
    
}

