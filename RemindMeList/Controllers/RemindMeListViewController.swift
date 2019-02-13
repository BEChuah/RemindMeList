//
//  ViewController.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 30/01/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit
import CoreData

class RemindMeListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item] ()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    //let defaults = UserDefaults.standard
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Optional(file:///Users/bengeechuah/Library/Developer/CoreSimulator/Devices/BE603A7D-9F07-4741-B5D7-069F724C0AB5/data/Containers/Data/Application/9C60F719-6A9C-43BA-904C-579EC7C74315/Documents/Item.plist)
        // To show hidden file on Finder use short cut ["Comand" + "Shift" + "." ]
        // Use short cut [ "Command" + " up arrow" or " down arrow " to move up and down file directory
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //[file:///Users/bengeechuah/Library/Developer/CoreSimulator/Devices/BE603A7D-9F07-4741-B5D7-069F724C0AB5/data/Containers/Data/Application/CA3E816C-8323-47B4-8FCC-EAAFA884F865/Documents/]
        
        
        
       }

//MARK Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
    
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    
    
    // Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    // Mark - Add New Item button IB outlet
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Remind Me Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happened once the user click the uialert button
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
           self.saveItems()
    
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
         
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK -- Model Manipulation Methods
    
    func saveItems(){
   
        do{
            try context.save()
        }catch{
            print("Erro saving context \(error)")
        }
        
        //self.defaults.set(self.itemArray, forKey: "RemindMeListArray")
        
        self.tableView.reloadData()
        
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
    //let request : NSFetchRequest<Item> = Item.fetchRequest()
    do {
        itemArray = try context.fetch(request)
    }catch{
        print("Error fetching data request from context \(error)")
    }
        tableView.reloadData()
  }
}

// Mark - Extension - Search bar method

extension RemindMeListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }      // https//academy.realm.io/posts/nspredicate_cheatsheet/
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
