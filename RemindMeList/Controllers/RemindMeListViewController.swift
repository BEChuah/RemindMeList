//
//  ViewController.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 30/01/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit
import RealmSwift

class RemindMeListViewController: UITableViewController {
    // hold command click on itemArray click rename -
    var RemindMeItem: Results<Item>?
    let realm = try! Realm()
   
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
        return RemindMeItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = RemindMeItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Item Added"
            
        }
    
        return cell
    }
    
    
    
    // Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        if let item = RemindMeItem?[indexPath.row]{
            do{
            try realm.write {
               // realm.delete(item)
                item.done = !item.done
            }
            }catch{
                print("Error saving done, \(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    // Mark - Add New Item button IB outlet
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Remind Me Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happened once the user click the uialert button
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write{
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
                }catch{
                    print("Error saving new item, \(error)")
                }
            
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
         
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK -- Model Manipulation Methods
    
    
    func loadItems () {
        
        RemindMeItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}


// Mark - Extension - Search bar method

//extension RemindMeListViewController: UISearchBarDelegate {
    extension RemindMeListViewController: UISearchBarDelegate {
        func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        RemindMeItem = RemindMeItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        // Realm predicate cheatsheet
        
        func  searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
        
        
        
        

        

    

    

