//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by jekaterina.livcane on 09/09/2020.
//  Copyright © 2020 jekaterina.livcane. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    
    var groseries = [Grocery]()
    
    // var gros = [String]()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()
        
        print("FileManager", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        pickNewGrocery()
    }
    
    
    func pickNewGrocery(){
        let alertController = UIAlertController(title: "Grocery Item!", message: "What do you want to buy?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            
            //    self.gros.append(textField!.text!)
            //   self.tableView.reloadData()
            
            
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.managedObjectContext!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            grocery.setValue(textField?.text, forKey: "item")
            
            do{
                try self.managedObjectContext?.save()
            }catch{
                fatalError("Error to store grocery item")
            }
            
            self.loadData()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func loadData(){
        
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            groseries = result!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Grocery items")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groseries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        
        //   cell.textLabel?.text = gros[indexPath.row]
        let grocery = groseries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        cell.selectionStyle = .none
        cell.accessoryType = grocery.completed ? .checkmark : .none
        
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(groseries[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        do{
            try self.managedObjectContext?.save()
        }catch{
            fatalError("Error in deleting item")
        }
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        groseries[indexPath.row].completed = !groseries[indexPath.row].completed
    
    do{
        try self.managedObjectContext?.save()
    }catch{
        fatalError("Error in deleting item")
    }
    loadData()
    
}
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        UIView.animate(withDuration: 0.99) {
            cell.transform = CGAffineTransform.identity
        }
    }
}
