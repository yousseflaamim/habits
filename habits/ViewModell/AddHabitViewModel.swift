//
//  AddHabitViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import SPIndicator

class AddHabitViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var frequency: Habit.HabitFrequency = .daily

    private let habitService: HabitServiceProtocol

    init(habitService: HabitServiceProtocol) {
        self.habitService = habitService
    }

    func addHabit() {
        // Show loading indicator (Adding title and message)
        SPIndicator.present(title: "Adding Habit", message: "Please wait...", haptic: .success)
        
        let habit = Habit(
            id: UUID().uuidString,
            title: title,
            description: description,
            startDate: Date(),
            frequency: frequency,
            completedDates: []
        )

        habitService.addHabit(habit: habit) { result in
            // Dismiss the loading indicator
            //SPIndicator.dismiss()

            switch result {
            case .success:
                // Show success message
                SPIndicator.present(title: "Success", message: "Habit added successfully!", haptic: .success)
                print("Habit added successfully.")
            case .failure(let error):
                // Show error message
                SPIndicator.present(title: "Error", message: "Failed to add habit: \(error.localizedDescription)", haptic: .error)
                print("Failed to add habit:", error.localizedDescription)
            }
        }
    }
}
