//
//  UserTableViewController.swift
//  MovieTime
//
//  Created by Cambrian on 2022-07-27.
//

import UIKit
import CoreData

class UserTableViewController: UITableViewController {

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetch request for users list
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
          
        do {
            users = try managedContext.fetch(fetchRequest)
            users = users.sorted(by: { obj1, obj2 in
                obj1.id > obj2.id
            })
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    //MARK: - Add User Action
    //Push UserViewController
    @IBAction func addUserAction(_ sender: Any) {
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { return }
        obj.users = users
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell
        {
            let user = users[indexPath.row]

            cell.nameLabel.text = user.name
            
            return cell
        }
        
        return UITableViewCell()
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete user from core data
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(users[indexPath.row])
            appDelegate.saveContext()
            
            users.remove(at: indexPath.row)
            self.tableView.reloadData()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "MovieTableViewController") as? MovieTableViewController else { return }
        obj.user = users[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)
    }

}
