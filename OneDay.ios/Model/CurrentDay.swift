//
//  CurrentDay.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-12-01.
//

import Foundation
import SQLite

class CurrentDay {
    // Day Table Expressions
    static let daysTable = Table("days")
    static let dateColumn = Expression<String>("date")
    static let hoursColumn = Expression<String>("hours")
    
    
    static func dbTableInit() {
        createDayTable()
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
    
    static func insertAndRetrieveDay(date: String) -> DayModel {
        let db = dbConnect()
        
        var foundDayModel: DayModel = DayModel()
        
        do {
            let daysTable = Table("days")
            
            for day in try db!.prepare(daysTable.filter(dateColumn == date)) {
                if (day[hoursColumn].isEmpty) {
                    foundDayModel = DayModel(date: day[dateColumn])
                } else {
                    foundDayModel = DayModel(date: day[dateColumn], hours: DayModel.editableHours(hours: day[hoursColumn]))
                }
            }
            
            if (foundDayModel.date == "" || foundDayModel.hours.isEmpty) {
                foundDayModel.date = date
                
                let upsert = daysTable.upsert(
                    dateColumn <- foundDayModel.date,
                    hoursColumn <- DayModel.hoursToJson(hours: foundDayModel.hours),
                    onConflictOf: dateColumn)
                let _ = try db!.run(upsert)
            }
        } catch let error {
            print("Some error: \(error)")
        }
        
        return foundDayModel
    }
    
    static func updateDB(day: DayModel) {
        let db = dbConnect()
        
        do {
            let daysTable = Table("days")
            let upsert = daysTable.upsert(dateColumn <- day.date, hoursColumn <- DayModel.hoursToJson(hours: day.hours), onConflictOf: dateColumn)
            let _ = try db!.run(upsert)
        } catch let error {
            print("Some error: \(error)")
        }
    }
    
    static func createDayTable() {
        do {
            let db = dbConnect()
            
            try db!.run(daysTable.create(ifNotExists: true) { t in
                t.column(dateColumn, primaryKey: true)
                t.column(hoursColumn)
            })
        } catch let error {
            print("Error creating Days Table: \(error)")
        }
    }
}

