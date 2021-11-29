//
//  DayDao.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation
import SQLite

class oneDayDB {
    var db: Connection? = nil
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/oneday-db.sqlite3")
        } catch let error {
            print("Connection error: \(error)")
        }
        
    }
    
    func createDayTable() {
        do {
            let days = Table("days")
            let date = Expression<String>("date")
            let hours = Expression<String>("hours")
            
            try db!.run(days.create(ifNotExists: true) { t in
                t.column(date, primaryKey: true)
                t.column(hours)
            })
        } catch let error {
            print("Error creating Days Table: \(error)")
        }
    }
}
