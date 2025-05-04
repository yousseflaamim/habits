//
//  HabitDetailViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation


class HabitDetailViewModel: ObservableObject {
    @Published var habit: Habit
    @Published var stats: HabitStats?

    private let habitService: HabitServiceProtocol

    init(habit: Habit, habitService: HabitServiceProtocol) {
        self.habit = habit
        self.habitService = habitService
    }

    func markCompleted(completion: @escaping (Bool, String?) -> Void) {
        habitService.markHabitCompleted(id: habit.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedHabit):
                    self?.habit = updatedHabit
                    self?.fetchStats {
                        completion(true, nil)
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    func fetchStats(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            let stats = self.habitService.calculateStats(for: self.habit)
            DispatchQueue.main.async {
                self.stats = stats
                completion?()
            }
        }
    }
}
