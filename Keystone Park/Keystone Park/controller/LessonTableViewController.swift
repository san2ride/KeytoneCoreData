//
//  LessonTableViewController.swift
//  Keystone Park
//
//  Created by Jason Sanchez on 9/10/18.
//  Copyright © 2018 Jason Sanchez. All rights reserved.
//

import UIKit

class LessonTableViewController: UITableViewController {
    
    var student = ["Ben", "John"]
    
    @IBAction func addStudentAction(_ sender: UIBarButtonItem) {
        present(alertController(actionType: "add"), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return student.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        cell.textLabel?.text = student[indexPath.row]
        
        return cell
    }
    
    // MARK: Private
    
    private func alertController(actionType: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Keystone Park Lesson", message: "Student Info", preferredStyle: .alert)
        
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Name"
            
        }
        
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Lesson Type: Ski | Snowboard"
        }
        
        let defaultAction = UIAlertAction(title: actionType.uppercased(), style: .default) { (action) in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    

}
