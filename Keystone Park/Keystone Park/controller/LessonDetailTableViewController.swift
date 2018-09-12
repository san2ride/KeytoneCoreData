//
//  LessonDetailTableViewController.swift
//  Keystone Park
//
//  Created by Jason Sanchez on 9/12/18.
//  Copyright © 2018 Jason Sanchez. All rights reserved.
//

import UIKit
import CoreData

class LessonDetailTableViewController: UITableViewController {

    var moc: NSManagedObjectContext? {
        didSet {
            if let moc = moc {
                lessonService = LessonService(moc: moc)
            }
        }
    }
    private var lessons = [Lesson]()
    private var lessonService: LessonService?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let availableLessons = lessonService?.getAvailableLessons() {
            lessons = availableLessons
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)

        cell.textLabel?.text = lessons[indexPath.row].type

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row fromthe data source
            lessonService?.deleteLesson(lesson: lessons[indexPath.row], deleteHandler: { [weak self] (success) in
                if success {
                    self?.lessons.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else {
                    let alertController = UIAlertController(title: "Delete Failed", message: "There are students currently register for this lesson", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            })
        }
        tableView.reloadData()
    }
}
