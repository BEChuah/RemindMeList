//
//  CategoryViewController.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 13/02/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var category: Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    loadCategory()
     
        tableView.separatorStyle = .none
    }

    
    
    // MARK: - Table view data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // tap into super class for category at indexPath as swipe cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // then do these
        if let categori = category?[indexPath.row] {
            
            cell.textLabel?.text = categori.name
                //?? "No Category Added Yet"
            guard let categoryColour = UIColor(hexString: categori.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
       
    
        return cell
        
    }
    
    
    
    // Mark TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RemindMeListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
   
    
    //MARK: - Model Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }

    
        func loadCategory() {
            
           category = realm.objects(Category.self)
            tableView.reloadData()
    }
    
    //MARK: Delete Data From Swipe

    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.category? [indexPath.row] {
        do {
            try self.realm.write{
                self.realm.delete(categoryForDeletion)
            }
        }catch{
            print("Error deleting category \(error)")
        }
 
    }
     
}
//MARK: Add New Item Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add a new category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)    }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            field.placeholder = " Create new category"
            textField = field
        }
        
      
        present(alert, animated: true, completion: nil)
        
    }
       
}
