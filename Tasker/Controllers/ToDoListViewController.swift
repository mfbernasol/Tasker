//
//  ViewController.swift
//  Tasker
//
//  Created by Michael Bernasol on 8/7/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
   var itemArray = [Item]()
    
   let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let newItem = Item()
        newItem.title = "Buy Food"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Walk Dog"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go run"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
//MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none //ternary operator
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//
//        }
        
        return cell
    }
    
    // MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
     
        }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
           let newItem = Item()
            newItem.title = textField.text!
            
           self.itemArray.append(newItem)
            
           self.defaults.set(self.itemArray,forKey: "TodoListArray")
            
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



    


