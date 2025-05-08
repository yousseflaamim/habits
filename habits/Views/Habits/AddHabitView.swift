//
//  AddHabitView.swift
//  habits
//
//  Created by gio on 4/30/25..
//


import SwiftUI
import ProgressHUD

struct AddHabitView: View {
    @ObservedObject var viewModel: AddHabitViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Habit Information")) {
                TextField("Title", text: $viewModel.title)
                TextField("Description", text: $viewModel.description)
                Picker("Frequency", selection: $viewModel.frequency) {
                    Text("Daily").tag(Habit.HabitFrequency.daily)
                    Text("Weekly").tag(Habit.HabitFrequency.weekly)
                    Text("Monthly").tag(Habit.HabitFrequency.monthly)
                }
            }

            // shosse time section
            Section(header: Text("Reminder Time")) {
                DatePicker("Select Reminder Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
            }

            Button("Add") {
                ProgressHUD.animate("Adding Habit...")
                viewModel.addHabit { success, message in
                    if success {
                        ProgressHUD.succeed(message, delay: 2.5)
                        dismiss()
                    } else {
                        ProgressHUD.failed(message)
                    }
                }
            }
        }
        .navigationTitle("New Habit")
    }
}
