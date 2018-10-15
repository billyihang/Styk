//
//  PickColorTableViewController.swift
//  Styk
//
//  Created by William Yang on 8/21/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit

class PickColorTableViewController: UITableViewController {

    // MARK: - Properties
    var colors: [String] = ["Red", "Maroon", "Yellow", "Orange", "Olive", "Lime", "Green", "Aqua", "Teal", "Blue", "Navy", "Magenta", "Purple"]
    
    var selectedColorName: String? {
        didSet {
            if let selectedColor = selectedColorName {
                let index = colors.index(of: selectedColor)
                selectedColorIndex = index
                let selectedHex = Color.toHex(selectedColor)
                selectedColorHex = selectedHex
            }
        }
    }
    
    var selectedColorHex: String?
    
    var selectedColorIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveSelectedColor",
        let cell = sender as? UITableViewCell,
        let indexPath = tableView.indexPath(for: cell)
        else { return }
        
        self.selectedColorName = colors[indexPath.row]
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Color", for: indexPath) as? ColorTableViewCell {
            let colorName = colors[indexPath.row]
            let colorHex = Color.toHex(colorName)
            let color = Color.toUIColor(colorHex)
            
            if indexPath.row == selectedColorIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            cell.nameLabel?.text = colorName
            cell.colorLabel.backgroundColor = color
            cell.colorLabel.layer.cornerRadius = cell.colorLabel.bounds.size.width/2
            cell.colorLabel.clipsToBounds = true
            
            // cell.textLabel?.textAlignment = .center
            // white color text        cell.textLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            return cell
        } else {
            print("Could not load cell")
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = selectedColorIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedColorName = colors[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
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
