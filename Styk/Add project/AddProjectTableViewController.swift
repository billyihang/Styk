//
//  AddProjectTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/20/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

class AddProjectTableViewController: UITableViewController {

    // MARK: - Properties
    var project: ProjectData?
    var name: String?
    lazy var color: String = Color.toHex(self.colorName) // Hex
    var colorName: String = "Red" {
        didSet {
            
                let colorHex = Color.toHex(colorName)
                self.color = colorHex
                
                colorLabel.text = "    \(colorName)"
                //colorLabel.backgroundColor = Color.toUIColor(colorHex)
                //changeColorLabelColor(colorHex)
                colorLabel.textColor = Color.toUIColor(colorHex)
            
        }
    }
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Project>!
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = name {
            self.titleTextField.text = title
        }
        
        colorLabel.text = "    \(colorName)"
        colorLabel.textColor = Color.toUIColor(color)
    
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
            if let colorPickerVC = segue.destination as? PickColorTableViewController{
                colorPickerVC.selectedColorName = colorName
            }
        }
        if segue.identifier == "SaveProjectToMasterVC" {
            guard let title = titleTextField.text
                else {return}
            
            let colorUI = Color.toUIColor(self.color)
            
            guard let projs = fetchedRC.fetchedObjects else {
                return
            }
            let count = Int16(projs.count)
            
            let proj = Project(entity: Project.entity(), insertInto: context)
            proj.color = colorUI
            proj.name = title
            proj.colorString = colorName
            proj.deletable = true
            proj.sort = count
            appDelegate.saveContext()
        }
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
            
            self.color = chosenColorHex
            self.colorName = chosenColorName
        }
    }

    }

