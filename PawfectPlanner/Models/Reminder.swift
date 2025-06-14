//
//  Reminder.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import Foundation

struct Reminder: Identifiable {
    var id: String 
    var title: String
    var pet: String
    var event: String
    var isRepeat: Bool
    var frequency: String
    var time: Date
    var isCompleted: Bool
    var priority: String
}
