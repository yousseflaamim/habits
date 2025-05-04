//
//  Date.swift
//  habits
//
//  Created by gio on 5/3/25.
//

import Foundation

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    func formatted(_ format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    static func today() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
}
