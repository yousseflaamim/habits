//
//  HabitListViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import Combine

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let habitService: HabitServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(habitService: HabitServiceProtocol) {
        self.habitService = habitService
        loadHabits()
    }
    
    func loadHabits() {
        isLoading = true
        habitService.fetchHabits { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let habits):
                    self?.habits = habits
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteHabit(id: String) {
        habitService.deleteHabit(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.habits.removeAll { $0.id == id }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refresh() {
        loadHabits()
    }
}
