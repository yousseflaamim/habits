//
//  Habit.swift
//  habits
//
//  Created by gio on 4/30/25.
//



import Foundation

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var description: String
    var startDate: Date
    var frequency: HabitFrequency
    var completedDates: [Date]
    var reminderTime: Date?

    enum HabitFrequency: String, Codable {
        case daily, weekly, monthly
    }
    
    // Make sure to compare all properties including Arrays and Dates

    static func ==(lhs: Habit, rhs: Habit) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.startDate == rhs.startDate &&
               lhs.frequency == rhs.frequency &&
               lhs.completedDates == rhs.completedDates &&
               lhs.reminderTime == rhs.reminderTime
    }
}
