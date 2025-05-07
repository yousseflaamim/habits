//
//  HabitProgressData.swift
//  habits
//
//  Created by gio on 5/8/25.
//

import Foundation

struct HabitProgressData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
