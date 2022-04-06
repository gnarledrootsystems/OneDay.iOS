//
//  CustomTaskViewController.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2022-04-01.
//

import Foundation
import UIKit

class CustomTaskViewController: UITableViewController {
    
    var taskList: Array<TaskModel> = []
    // Tag 1000 == Color Square View
    // Tag 2000 == Label View
    // Tag 3000 == Visible Switch
    // Tag 4000 == Delete Button

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return self.taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItem", for: indexPath)
        
        let colorSquare = cell.viewWithTag(1000) as! UILabel
        let descriptionLabel = cell.viewWithTag(2000) as! UILabel
        let visibilityLabel = cell.viewWithTag(3000) as! UILabel
        
        
        
        let task: TaskModel = taskList[indexPath.row]
        
        colorSquare.text = task.description
        colorSquare.backgroundColor = UIColor(rgb: task.color)
        
        if (task.is_hidden) {
            cell.accessoryType = .none
            visibilityLabel.text = "Hidden"
        } else {
            cell.accessoryType = .checkmark
            visibilityLabel.text = "Visible"
        }
        
        descriptionLabel.text = task.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let visibilityLabel = cell.viewWithTag(3000) as! UILabel
            var task = self.taskList[indexPath.row]
            
            print("A. This is the console output: \(task as AnyObject)")
            
            
            if task.is_hidden {
                cell.accessoryType = .checkmark
                task.is_hidden = false
                self.taskList[indexPath.row].is_hidden = false
                visibilityLabel.text = "Visible"
            } else {
                cell.accessoryType = .none
                task.is_hidden = true
                self.taskList[indexPath.row].is_hidden = true
                visibilityLabel.text = "Hidden"
            }
            
            CustomHourTask.upsertTask(task: task)
            
            print("B. This is the console output: \(task as AnyObject)")
        }
     
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
        self.taskList = CustomHourTask.getAllNonDeletedTasks()
        self.tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView?.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var task = self.taskList[indexPath.row]

        task.is_deleted = true
        self.taskList[indexPath.row].is_deleted = true
        
        CustomHourTask.upsertTask(task: task)
        
        self.taskList.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let displayVC = segue.destination as! CreateCustomTaskViewController
        
        displayVC.customTaskViewController = self
        
    }
}
