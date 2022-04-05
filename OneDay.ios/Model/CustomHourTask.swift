//
//  CurrentDay.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-12-01.
//

import Foundation
import SQLite

class CustomHourTask {
    // Task Table Expressions
    static let hourTaskItemsTable = Table("HourTaskItem")
    
    static let ht_idColumn = Expression<Int64>("id")
    static let ht_colorColumn = Expression<Int>("color")
    static let ht_descriptionColumn = Expression<String>("description")
    static let ht_displayOrder = Expression<Int>("display_order")
    static let ht_isHidden = Expression<Bool>("is_hidden")
    static let ht_isDeleted = Expression<Bool>("is_deleted")
    
    static let emptyTask = TaskModel(uid: 0, color: 0xFFFFFF, description: "", display_order: 0, is_hidden: false, is_deleted: false)
    
    static let defaultTasks = [
        TaskModel(uid: 1, color: 0x57838D, description: "sleep", display_order: 1, is_hidden: false, is_deleted: false),
        TaskModel(uid: 2, color: 0xF3BFB3, description: "work", display_order: 2, is_hidden: false, is_deleted: false),
        TaskModel(uid: 3, color: 0x50B4D8, description: "chores", display_order: 3, is_hidden: false, is_deleted: false),
        TaskModel(uid: 4, color: 0xCAB3C1, description: "study", display_order: 4, is_hidden: false, is_deleted: false),
        TaskModel(uid: 5, color: 0xA7D9C9, description: "leisure", display_order: 5, is_hidden: false, is_deleted: false),
        TaskModel(uid: 6, color: 0xD3C0F9, description: "other", display_order: 6, is_hidden: false, is_deleted: false)
    ]
    
    static func dbTableInit() {
        createHourTaskItemTable()
        populateDefaultHourTaskItems()
    }
    
    static func populateDefaultHourTaskItems() {
        for task in self.defaultTasks {
            CustomHourTask.insertTask(task: task)
        }
        
        //let tasks: Array<TaskModel> = CustomHourTask.getAllUsableTasks()
    }
    
    static func dbConnect() -> Connection? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        do {
            return try Connection("\(path)/oneday-db.sqlite3")
        } catch let error {
            print("Connection error: \(error)")
        }
        
        return nil
    }
    
    static func getAllTasks() -> Array<TaskModel> {
        let db = dbConnect()
        
        var taskArray: Array<TaskModel> = []
        do {
            for (index, task) in try db!.prepare(hourTaskItemsTable).enumerated() {
                print(task)
                
                taskArray.append(
                    TaskModel(
                        uid: task[ht_idColumn],
                        color: task[ht_colorColumn],
                        description: task[ht_descriptionColumn],
                        display_order: task[ht_displayOrder],
                        is_hidden: task[ht_isHidden],
                        is_deleted: task[ht_isDeleted]
                    )
                )
                
                print(taskArray[index])
            }
        } catch {
            print (error)
        }
        
        return taskArray
    }
    
    static func getAllNonDeletedTasks() -> Array<TaskModel> {
        let db = dbConnect()
        
        var taskArray: Array<TaskModel> = []
        do {
            for (index, task) in try db!.prepare(hourTaskItemsTable).enumerated() {
                
                let taskModel: TaskModel = TaskModel(
                    uid: task[ht_idColumn],
                    color: task[ht_colorColumn],
                    description: task[ht_descriptionColumn],
                    display_order: task[ht_displayOrder],
                    is_hidden: task[ht_isHidden],
                    is_deleted: task[ht_isDeleted]
                )
                
                if (taskModel.is_deleted) {
                    continue
                }
                
                taskArray.append(taskModel)
            }
        } catch {
            print (error)
        }
        
        return taskArray
    }
    
    static func getAllUsableTasks() -> Array<TaskModel> {
        let db = dbConnect()
        
        var taskArray: Array<TaskModel> = []
        taskArray.append(self.emptyTask)
        do {
            for (index, task) in try db!.prepare(hourTaskItemsTable).enumerated() {
                print(task)
                
                let taskModel: TaskModel = TaskModel(
                    uid: task[ht_idColumn],
                    color: task[ht_colorColumn],
                    description: task[ht_descriptionColumn],
                    display_order: task[ht_displayOrder],
                    is_hidden: task[ht_isHidden],
                    is_deleted: task[ht_isDeleted]
                )
                
                if (taskModel.is_hidden || taskModel.is_deleted) {
                    continue
                }
                
                taskArray.append(taskModel)
                //print(index)
                //print(taskArray[index])
            }
        } catch {
            print (error)
        }
        
        return taskArray
    }
    
    static func upsertTask(task: TaskModel) {
        let db = dbConnect()
        
        do {
            let rowid = try db!.run(hourTaskItemsTable.upsert(
                ht_idColumn <- task.uid!,
                ht_colorColumn <- task.color,
                ht_descriptionColumn <- task.description,
                ht_displayOrder <- task.display_order,
                ht_isHidden <- task.is_hidden,
                ht_isDeleted <- task.is_deleted,
                onConflictOf: ht_idColumn))
            print("inserted id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }
    }
    
    static func insertTask(task: TaskModel) {
        let db = dbConnect()
        
        do {
            let rowid = try db!.run(hourTaskItemsTable.insert(
                ht_idColumn <- task.uid!,
                ht_colorColumn <- task.color,
                ht_descriptionColumn <- task.description,
                ht_displayOrder <- task.display_order,
                ht_isHidden <- task.is_hidden,
                ht_isDeleted <- task.is_deleted))
            print("inserted id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }
    }
    
    static func insertAutoIncrementTask(task: TaskModel) {
        let db = dbConnect()
        
        do {
            let rowid = try db!.run(hourTaskItemsTable.insert(
                ht_colorColumn <- task.color,
                ht_descriptionColumn <- task.description,
                ht_displayOrder <- task.display_order,
                ht_isHidden <- task.is_hidden,
                ht_isDeleted <- task.is_deleted))
            print("inserted id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }
    }
    

    
    static func createHourTaskItemTable() {
        do {
            let db = dbConnect()
            
            try db!.run(hourTaskItemsTable.create(ifNotExists: true) { t in
                t.column(ht_idColumn, primaryKey: true)
                t.column(ht_colorColumn)
                t.column(ht_descriptionColumn)
                t.column(ht_displayOrder)
                t.column(ht_isHidden)
                t.column(ht_isDeleted)
            })
        } catch let error {
            print("Error creating Tasks Table: \(error)")
        }
    }
}

