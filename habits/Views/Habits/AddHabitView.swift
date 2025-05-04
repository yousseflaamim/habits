//
//  AddHabitView.swift
//  habits
//
//  Created by gio on 4/30/25..
//


import SwiftUI

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

            Button("Add") {
            viewModel.addHabit()
            dismiss()
            }
        }
        .navigationTitle("New Habit")
    }
}
