//
//  HabitDetailViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//



import FirebaseFirestore

import Foundation

struct Habit: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var startDate: Date
    var frequency: HabitFrequency
    var completedDates: [Date]

    enum HabitFrequency: String, Codable {
        case daily, weekly, monthly
    }

    var isCompletedToday: Bool {
        Calendar.current.isDateInToday(completedDates.last ?? .distantPast)
    }
}

