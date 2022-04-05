//
//  TaskModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

struct TaskModel: Codable {
    var uid: Int64
    var color: Int
    var description: String
    var display_order: Int
    var is_hidden: Bool
    var is_deleted: Bool
}
