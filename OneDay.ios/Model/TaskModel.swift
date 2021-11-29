//
//  TaskModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

var defaultTasks = [
    TaskModel(uid: 0, color: 0xFFFFFF, description: "", order: 0, is_hidden: false),
    TaskModel(uid: 1, color: 0x57838D, description: "sleep", order: 1, is_hidden: false),
    TaskModel(uid: 2, color: 0xF3BFB3, description: "work", order: 2, is_hidden: false),
    TaskModel(uid: 3, color: 0x50B4D8, description: "chores", order: 3, is_hidden: false),
    TaskModel(uid: 4, color: 0xCAB3C1, description: "study", order: 4, is_hidden: false),
    TaskModel(uid: 5, color: 0xA7D9C9, description: "leisure", order: 5, is_hidden: false),
    TaskModel(uid: 6, color: 0xD3C0F9, description: "other", order: 6, is_hidden: false)
]

struct TaskModel: Codable {
    var uid: Int
    var color: Int
    var description: String
    var order: Int
    var is_hidden: Bool
}
