//
//  AddHabitViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation

class AddHabitViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var frequency: Habit.HabitFrequency = .daily
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    @Published var reminderTime: Date = Date()

    private let habitService: HabitServiceProtocol

    init(habitService: HabitServiceProtocol) {
        self.habitService = habitService
    }

    func addHabit(completion: @escaping (Bool, String) -> Void) {
        self.isLoading = true
        self.message = "Adding Habit..."

        let habit = Habit(
            id: UUID().uuidString,
            title: title,
            description: description,
            startDate: Date(),
            frequency: frequency,
            completedDates: [],
            reminderTime: reminderTime 
        )

        habitService.addHabit(habit: habit) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.title = ""
                    self.description = ""
                    self.frequency = .daily
                    self.reminderTime = Date()
                    completion(true, "Habit added successfully!")
                    
                case .failure(let error):
                    completion(false, "Failed to add habit: $error.localizedDescription)")
                }
            }
        }
    }
}
