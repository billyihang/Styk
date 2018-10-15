//
//  SettingTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/15/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

class SettingTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    
    // MARK: - Functions
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<User>!
    
    var toolBar: UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar = UIToolbar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exitEditing))
        //self.view.addGestureRecognizer(tapGesture)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))
        toolBar?.setItems([doneBtn], animated: false)
        nameLabel.inputAccessoryView = toolBar
        toolBar?.sizeToFit()
    }

    @objc func doneBtnPressed() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
        refreshUI()
        tableView.tableFooterView = UIView(frame: .zero)
        let user = fetchedRC.fetchedObjects?.first
        if let color = user?.favoriteColor as? UIColor {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Functions
    func refresh() {
        let request = User.fetchRequest() as NSFetchRequest<User>
        let sort = NSSortDescriptor(keyPath: \User.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (fetchedRC.fetchedObjects?.isEmpty)! {
            let user = User(entity: User.entity(), insertInto: context)
            let green = Color.toHex("Green")
            let greenColor = Color.toUIColor(green)
            user.favoriteColor = greenColor
            user.favoriteColorName = "Green"
            appDelegate.saveContext()
            refresh()
        }
    }
    
    func refreshUI() {
        
        let user = fetchedRC.fetchedObjects?.first
        
        if let name = user?.name {
            nameLabel.text = name
        }
        
        if let color = user?.favoriteColor as? UIColor,
            let colorName = user?.favoriteColorName {
            colorLabel.text = colorName
            colorLabel.textColor = color
        }
    }
    
    @objc func exitEditing() {
        view.endEditing(true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func finishEditing(_ sender: Any) {
        if let user = fetchedRC.fetchedObjects?.first {
            user.name = nameLabel.text
            appDelegate.saveContext()
            refresh()
            refreshUI()
        }
    }
    
    @IBAction func unwindWithSelectedColor(segue: UIStoryboardSegue) {
        if let colorPickerVC = segue.source as? PickColorTableViewController {
            guard let chosenColorName = colorPickerVC.selectedColorName,
                let chosenColorHex = colorPickerVC.selectedColorHex,
                let user = fetchedRC.fetchedObjects?.first
                else { return }
            
            let color = Color.toUIColor(chosenColorHex)
            
            user.favoriteColor = color
            user.favoriteColorName = chosenColorName
            appDelegate.saveContext()
            refresh()
            refreshUI()
        }
    }
    
    

}
