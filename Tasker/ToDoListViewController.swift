//
//  ViewController.swift
//  Tasker
//
//  Created by Michael Bernasol on 8/7/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
   var itemArray = ["Buy food","Go to gym","Walk dog"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
//MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        
        tableView.deselectRow(at: indexPath, animated: true)
     
        }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
           self.itemArray.append(textField.text!)
           self.tableView.reloadData()
       
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text)
            textField = alertTextField
            
            print("alertTextField.text")
          
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}



    


