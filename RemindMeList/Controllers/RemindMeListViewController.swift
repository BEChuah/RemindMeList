//
//  ViewController.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 30/01/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit

class RemindMeListViewController: UITableViewController {
    
    
    var itemArray = [Item] ()

    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Optional(file:///Users/bengeechuah/Library/Developer/CoreSimulator/Devices/BE603A7D-9F07-4741-B5D7-069F724C0AB5/data/Containers/Data/Application/9C60F719-6A9C-43BA-904C-579EC7C74315/Documents/Item.plist)
        // To show hidden file on Finder use short cut ["Comand" + "Shift" + "." ]
        // Use short cut [ "Command" + " up arrow" or " down arrow " to move up and down file directory
        
        loadItems()
        
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
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        //self.defaults.set(self.itemArray, forKey: "RemindMeListArray")
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
           
            let decoder = PropertyListDecoder()
            
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            
            }catch{
            
                print("Error decoding item array, \(error)")
            }
            
        }
    }
}

