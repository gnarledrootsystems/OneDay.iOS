//
//  DayModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

var defaultHours = [
    HourModel(id: 0, time: "12 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 1, time: "1 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 2, time: "2 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 3, time: "3 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 4, time: "4 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 5, time: "5 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 6, time: "6 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 7, time: "7 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 8, time: "8 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 9, time: "9 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 10, time: "10 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 11, time: "11 AM", task: CustomHourTask.emptyTask),
    HourModel(id: 12, time: "12 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 13, time: "1 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 14, time: "2 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 15, time: "3 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 16, time: "4 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 17, time: "5 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 18, time: "6 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 19, time: "7 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 20, time: "8 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 21, time: "9 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 22, time: "10 PM", task: CustomHourTask.emptyTask),
    HourModel(id: 23, time: "11 PM", task: CustomHourTask.emptyTask)
]

struct DayModel: Codable {
    var date: String = ""
    var hours: [HourModel] = defaultHours
    
    static func editableHours(hours: String) -> [HourModel] {
        let jsonData = hours.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        let editableHours: [HourModel] = try! jsonDecoder.decode([HourModel].self, from: jsonData)
        
        return editableHours
    }
    
    static func hoursToJson(hours: [HourModel]) -> String {
        let jsonData = try! JSONEncoder().encode(hours)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    static func defaultHoursToJson() -> String {
        let jsonData = try! JSONEncoder().encode(defaultHours)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
}
