//
//  FirebaseHabitService.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseHabitService: HabitServiceProtocol {
    private let db = Firestore.firestore()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "unknown"
    }

    func fetchHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        db.collection("users").document(userId).collection("habits").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let habits = snapshot?.documents.compactMap { try? $0.data(as: Habit.self) } ?? []
                completion(.success(habits))
            }
        }
    }

    func addHabit(habit: Habit, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(userId).collection("habits").document(habit.id).setData(from: habit) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    NotificationService.shared.scheduleReminder(for: habit) 
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteHabit(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).collection("habits").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                NotificationService.shared.cancelReminder(for: id)
                completion(.success(()))
            }
        }
    }

    func markHabitCompleted(id: String, completion: @escaping (Result<Habit, Error>) -> Void) {
        let habitRef = db.collection("users").document(userId).collection("habits").document(id)
        habitRef.getDocument { document, error in
            guard let document = document, document.exists,
                  var habit = try? document.data(as: Habit.self) else {
                completion(.failure(error ?? NSError(domain: "", code: -1)))
                return
            }

            habit.completedDates.append(Date())
            do {
                try habitRef.setData(from: habit)
                completion(.success(habit))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func calculateStats(for habit: Habit) -> HabitStats {
        let total = habit.completedDates.count
        let streak = calculateStreak(dates: habit.completedDates)
        let daysSinceStart = Calendar.current.dateComponents([.day], from: habit.startDate, to: Date()).day ?? 1
        let rate = Double(total) / Double(daysSinceStart)
        return HabitStats(totalCompleted: total, streak: streak, completionRate: rate)
    }
    func updateHabit(habit: Habit, completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                try db.collection("users").document(userId).collection("habits").document(habit.id).setData(from: habit)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }

    private func calculateStreak(dates: [Date]) -> Int {
        let sorted = dates.sorted(by: >)
        var streak = 0
        var current = Date()

        for date in sorted {
            if Calendar.current.isDate(date, inSameDayAs: current) || Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: -streak, to: Date())!) {
                streak += 1
            } else {
                break
            }
        }

        return streak
    }
    func getHabitProgressData(id: String, completion: @escaping (Result<[HabitProgressData], Error>) -> Void) {
           db.collection("users").document(userId).collection("habits").document(id).getDocument { document, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let document = document,
                     let habit = try? document.data(as: Habit.self) else {
                   completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Habit not found"])))
                   return
               }
               
               let groupedData = Dictionary(grouping: habit.completedDates) { date in
                   Calendar.current.startOfDay(for: date)
               }
               
               let progressData = groupedData.map { date, dates in
                   HabitProgressData(date: date, count: dates.count)
               }.sorted { $0.date < $1.date }
               
               completion(.success(progressData))
           }
       }
}
