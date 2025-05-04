//
//  HabitDetailViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import SPIndicator

class HabitDetailViewModel: ObservableObject {
    @Published var habit: Habit
    @Published var stats: HabitStats?

    private let habitService: HabitServiceProtocol

    init(habit: Habit, habitService: HabitServiceProtocol) {
        self.habit = habit
        self.habitService = habitService
        fetchStats()
    }

    func markCompleted() {
        // Show loading indicator while marking the habit as completed
        SPIndicator.present(title: "Marking as Completed", message: "Please wait...", haptic: .success)

        habitService.markHabitCompleted(id: habit.id) { [weak self] result in
            DispatchQueue.main.async {
                // Dismiss the loading indicator
               // SPIndicator.dismiss()

                switch result {
                case .success(let updatedHabit):
                    self?.habit = updatedHabit
                    self?.fetchStats()
                    // Show success message
                    SPIndicator.present(title: "Habit Completed!", message: "Good job!", haptic: .success)
                case .failure(let error):
                    // Show error message if marking as completed fails
                    SPIndicator.present(title: "Error", message: "Failed to mark as completed: \(error.localizedDescription)", haptic: .error)
                    print("Error marking as completed:", error.localizedDescription)
                }
            }
        }
    }

    private func fetchStats() {
        // Show loading indicator while fetching stats
        SPIndicator.present(title: "Fetching Stats", message: "Please wait...", haptic: .success)

        stats = habitService.calculateStats(for: habit)

        // Dismiss loading indicator after fetching stats
        DispatchQueue.main.async {
           // SPIndicator.dismiss()
        }
    }
}
