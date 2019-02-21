//
//  CategoryViewController.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 13/02/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var category: Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    loadCategory()
    
    }

    // MARK: - Table view data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Category added yet"
        
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
   //Mark Add New Item Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add a new category", style: .default) { (action) in
       
        let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        
        alert.addTextField { (field) in
            field.placeholder = " Create new category"
            textField = field
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        }
    
    // Mark Model Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
        func loadCategory() {
            
           category = realm.objects(Category.self)
       
    }
    
    
    
    //func loadCategory {request: NSFetchRequest<Category> = Category.fetchRequest())
    
    
}
    


    
