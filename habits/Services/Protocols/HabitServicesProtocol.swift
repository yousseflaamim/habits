//
//  AddHabitViewModel.swift
//  habits
//
//  Created by gio on 4/3/25.
//


import Foundation

protocol HabitServiceProtocol {
    func fetchHabits(completion: @escaping (Result<[Habit], Error>) -> Void)
    func addHabit(habit: Habit, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteHabit(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func markHabitCompleted(id: String, completion: @escaping (Result<Habit, Error>) -> Void)
    func calculateStats(for habit: Habit) -> HabitStats
}
