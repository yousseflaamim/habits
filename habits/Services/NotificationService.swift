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
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget your '\(habit.title)' Today!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24, repeats: true)

        let request = UNNotificationRequest(identifier: habit.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification:", error.localizedDescription)
            }
        }
    }
}
