//
//  HabitDetailView.swift
//  habits
//
//  Created by gio on 5/3/25.
//


import SwiftUI
import ProgressHUD

struct HabitDetailView: View {
    @StateObject private var viewModel: HabitDetailViewModel

    init(habit: Habit) {
        _viewModel = StateObject(wrappedValue: HabitDetailViewModel(habit: habit, habitService: FirebaseHabitService()))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.habit.title)
                .font(.largeTitle)
                .bold()

            Text(viewModel.habit.description)
                .font(.subheadline)

            if let stats = viewModel.stats {
                VStack {
                    Text("Times completed: \(stats.totalCompleted)")
                    Text("Rate: \(String(format: "%.0f%%", stats.completionRate * 100))")
                    Text("Streak: \(stats.streak) day(s)")
                }
            }

            Button("Complete Today") {
                ProgressHUD.animate("Marking as Completed...")
                viewModel.markCompleted { success, message in
                    if success {
                        ProgressHUD.succeed("Completed!")
                    } else {
                        ProgressHUD.failed(message ?? "Something went wrong.")
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Habit Details")
        .onAppear {
            ProgressHUD.animate("Fetching Stats...", .circleStrokeSpin)
            viewModel.fetchStats {
                ProgressHUD.dismiss()
            }
        }
    }
}
