//
//  ViewController.swift
//  Tasker
//
//  Created by Michael Bernasol on 8/7/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController  {
    
   var todoItems: Results<Item>?
    
   let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

//   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
 
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    
        
//
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }

    
//MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none //ternary operator
        
        }else {
            cell.textLabel?.text = "No Items Added"
        }
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
     
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        

        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
     
        }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new items,\(error)")
                }
            }
        
            
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
//
//    func saveItems() {
//
//        do{
//            try context.save()
//        }catch {
//            print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }

 
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
 
    
}

//MARK: - Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //database query
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate: predicate)
        
        tableView.reloadData()

    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }



        }
    }

}

    


