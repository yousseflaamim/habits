//
//  NotificationService.swift
//  habits
//
//  Created by gio on 4/3/25.
//


import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error:", error.localizedDescription)
            }
        }
    }

    func scheduleReminder(for habit: Habit) {
        guard let reminderTime = habit.reminderTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget your '\(habit.title)' Today!"
        content.sound = .default
        content.userInfo = ["habitId": habit.id]

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: reminderTime)
        let minute = calendar.component(.minute, from: reminderTime)

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: habit.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: $error.localizedDescription)")
            }
        }
    }

    func cancelReminder(for habitId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId])
    }
}
