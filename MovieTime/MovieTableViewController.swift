//
//  MovieTableViewController.swift
//  MovieTime
//
//  Created by Cambrian on 2022-07-27.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {
    
    var user: User!
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        //Fetch request for movies list
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest)
            movies = movies.sorted(by: { obj1, obj2 in
                obj1.value(forKey: "id") as? Int ?? 1 < obj2.value(forKey: "id") as? Int ?? 1
            })
            
            //Filter by user
            movies = movies.filter({ obj in
                obj.users?.id ?? 0 == user.id
            })
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Add Movie Action
    //Push MovieViewController
    @IBAction func addMovieAction(_ sender: Any) {
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController else { return }
        obj.user = user
        obj.movies = movies
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell
        {
            cell.movieLabel.text = movies[indexPath.row].name
            return cell
        }
        
        // Configure the cell...

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
            managedContext.delete(movies[indexPath.row])
            appDelegate.saveContext()
            
            movies.remove(at: indexPath.row)
            self.tableView.reloadData()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
