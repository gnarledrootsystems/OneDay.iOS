//
//  HourModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

struct HourModel: Codable {
    var id: Int
    var time: String
    var task: TaskModel
}
