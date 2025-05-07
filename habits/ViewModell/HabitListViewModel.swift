//
//  HabitListViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import Combine
import FirebaseAuth

class HabitListViewModel: ObservableObject {
        @Published var habits: [Habit] = []
        @Published var isLoading = false
        @Published var errorMessage: String?
        @Published var showEditView = false
        @Published var editingHabit: Habit?
        @Published var showProgressView = false
        @Published var selectedHabitForProgress: Habit?
        @Published var progressData: [HabitProgressData] = []

    private let habitService: HabitServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(habitService: HabitServiceProtocol) {
        self.habitService = habitService
        loadHabits()
    }

    func loadHabits() {
        guard Auth.auth().currentUser != nil else {
            
            self.habits = []
            self.isLoading = false
            return
        }

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
    func startEditing(habit: Habit) {
           editingHabit = habit
           showEditView = true
       }
       
       func updateHabit(habit: Habit) {
           habitService.updateHabit(habit: habit) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success():
                       self?.loadHabits() // إعادة تحميل القائمة بعد التعديل
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
    func loadProgressData(for habit: Habit) {
            selectedHabitForProgress = habit
            isLoading = true
            
            habitService.getHabitProgressData(id: habit.id) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        self?.progressData = data
                        self?.showProgressView = true
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
