//
//  EditHabitView.swift
//  habits
//
//  Created by gio on 5/7/25.
//


import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var description: String
    @State private var reminderTime: Date
    let habit: Habit
    let onSave: (Habit) -> Void

    init(habit: Habit, onSave: @escaping (Habit) -> Void) {
        self.habit = habit
        self.onSave = onSave
        _title = State(initialValue: habit.title)
        _description = State(initialValue: habit.description)
        _reminderTime = State(initialValue: habit.reminderTime ?? Date())
    }


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Description")) {
                    TextField("Enter description", text: $description)
                }

                Section(header: Text("Reminder Time")) {
                    DatePicker("Select Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Edit Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updatedHabit = habit
                        updatedHabit.title = title
                        updatedHabit.description = description
                        updatedHabit.reminderTime = reminderTime
                        onSave(updatedHabit)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
