//
//  DayModel.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import Foundation

struct DayModel: Codable {
    let date: String
    let hours: [HourModel]
}
