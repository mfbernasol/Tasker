//
//  ViewController.swift
//  Tasker
//
//  Created by Michael Bernasol on 8/7/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController  {
    
   var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
 
        
    
        
//
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
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
        
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
      
            
           let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
           self.itemArray.append(newItem)
            
            
           self.saveItems()
            
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
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

 
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = predicate
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
 
    
}

//MARK: - Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //database query
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
        }
    }
    
}

    


