//
//  HourModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

var defaultHours = [
    HourModel(id: 0, time: "12 AM", task: defaultTasks.first!),
    HourModel(id: 1, time: "1 AM", task: defaultTasks.first!),
    HourModel(id: 2, time: "2 AM", task: defaultTasks.first!),
    HourModel(id: 3, time: "3 AM", task: defaultTasks.first!),
    HourModel(id: 4, time: "4 AM", task: defaultTasks.first!),
    HourModel(id: 5, time: "5 AM", task: defaultTasks.first!),
    HourModel(id: 6, time: "6 AM", task: defaultTasks.first!),
    HourModel(id: 7, time: "7 AM", task: defaultTasks.first!),
    HourModel(id: 8, time: "8 AM", task: defaultTasks.first!),
    HourModel(id: 9, time: "9 AM", task: defaultTasks.first!),
    HourModel(id: 10, time: "10 AM", task: defaultTasks.first!),
    HourModel(id: 11, time: "11 AM", task: defaultTasks.first!),
    HourModel(id: 12, time: "12 PM", task: defaultTasks.first!),
    HourModel(id: 13, time: "1 PM", task: defaultTasks.first!),
    HourModel(id: 14, time: "2 PM", task: defaultTasks.first!),
    HourModel(id: 15, time: "3 PM", task: defaultTasks.first!),
    HourModel(id: 16, time: "4 PM", task: defaultTasks.first!),
    HourModel(id: 17, time: "5 PM", task: defaultTasks.first!),
    HourModel(id: 18, time: "6 PM", task: defaultTasks.first!),
    HourModel(id: 19, time: "7 PM", task: defaultTasks.first!),
    HourModel(id: 20, time: "8 PM", task: defaultTasks.first!),
    HourModel(id: 21, time: "9 PM", task: defaultTasks.first!),
    HourModel(id: 22, time: "10 PM", task: defaultTasks.first!),
    HourModel(id: 23, time: "11 PM", task: defaultTasks.first!)
]

struct HourModel: Codable {
    var id: Int
    var time: String
    var task: TaskModel
}
