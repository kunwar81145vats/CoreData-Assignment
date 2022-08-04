//
//  UserViewController.swift
//  MovieTime
//
//  Created by Cambrian on 2022-07-27.
//

import UIKit
import CoreData

class UserViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    var users: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        save(name: userNameTextField.text ?? "")
    }

    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(name, forKeyPath: "name")
        
        var id: Int = 1
        
        if let userId = users.last?.value(forKey: "id") as? Int
        {
            id = userId + 1
        }
        
        user.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
