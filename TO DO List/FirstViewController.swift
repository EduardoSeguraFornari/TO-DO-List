//
//  FirstViewController.swift
//  TO DO List
//
//  Created by Eduardo Segura Fornari on 10/11/16.
//  Copyright © 2016 Fornari. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var task: Task = Task()

    @IBOutlet var tasksUITableView: UITableView!
    
    let moc = DataController().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returning to view
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        tasksUITableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCellEditingStyle.delete){
            if let task = taskMgr.tasks[indexPath.row] as Task?{
                deleteTask(task: task)
                taskMgr.tasks.remove(at: indexPath.row)
                tasksUITableView.reloadData()
            }
        }
    }

    //UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return taskMgr.tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].taskName
        cell.detailTextLabel?.text = taskMgr.tasks[indexPath.row].taskDescription
        return cell
    }
    
    func fetch() {
        let taskFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        do {
            
            let fetchedTask = try moc.fetch(taskFetch) as! [Task]
            taskMgr.tasks = fetchedTask
            
        } catch {
            fatalError("Failed to fetch task: \(error)")
        }
    }
    
    func deleteTask(task: Task) -> Bool {
        
        moc.delete(task)
        
        do {
            try moc.save()
            return true
        } catch {
            let saveError = error as NSError
            print(saveError)
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = taskMgr.tasks[indexPath.row] as Task?{
            self.task = task
        }
        performSegue(withIdentifier: "TaskSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController: TaskViewController = segue.destination as! TaskViewController;
        destinationViewController.task = task
        destinationViewController.moc = self.moc
    }
}

