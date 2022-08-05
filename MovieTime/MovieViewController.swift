//
//  MovieViewController.swift
//  MovieTime
//
//  Created by Cambrian on 2022-07-27.
//

import UIKit
import CoreData
import Foundation

class MovieViewController: UIViewController {

    @IBOutlet weak var movieNameTextField: UITextField!
    
    var movies: [Movie] = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let name = movieNameTextField.text
        {
            save(name: name)
        }
    }

    //MARK: - Save Movie Method
    //Parameter: - name
    //Save New Movie to Core Data
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        
        let movie = Movie(entity: entity, insertInto: managedContext)
        
        movie.name = name
        
        var id: Int = 1
        
        if let userId = movies.last?.id
        {
            id = Int(userId + 1)
        }
        
        movie.id = Int32(id)
        movie.users = user
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
