//
//  HabitDetailView.swift
//  habits
//
//  Created by gio on 5/3/25.
//



import SwiftUI
import ProgressHUD

import SwiftUI
import ProgressHUD

import SwiftUI
import ProgressHUD

import SwiftUI
import ProgressHUD

import SwiftUI
import ProgressHUD

struct HabitDetailView: View {
    @StateObject private var viewModel: HabitDetailViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(habit: Habit) {
        let habitService = FirebaseHabitService()
        let viewModel = HabitDetailViewModel(habit: habit, habitService: habitService)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    // Habit title
                    Text(viewModel.habit.title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)

                    // Habit description
                    if !viewModel.habit.description.isEmpty {
                        Text(viewModel.habit.description)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }

                    // Completion stats
                    if let stats = viewModel.stats {
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                StatCard(title: "Completed", value: String(stats.totalCompleted))
                                StatCard(title: "Streak", value: "\(stats.streak) day(s)")
                            }
                            
                            ProgressView(value: stats.completionRate)
                                .tint(.accentColor)
                                .frame(height: 8)
                            
                            Text("Completion Rate: \(String(format: "%.0f%%", stats.completionRate * 100))")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white.cornerRadius(16))
                        .shadow(radius: 3)
                    }

                    // Action buttons
                    VStack(spacing: 16) {
                        Button(action: completeHabit) {
                            Text("✅ Complete Today")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        
                        Button(action: skipHabit) {
                            Text("❌ Skip for Today")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Habit Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            ProgressHUD.animate("Fetching Stats...", .circleStrokeSpin)
            viewModel.fetchStats {
                ProgressHUD.dismiss()
            }
        }
    }

    // MARK: - Actions

    private func completeHabit() {
        ProgressHUD.animate("Marking as Completed...")
        viewModel.markCompleted { success, message in
            if success {
                ProgressHUD.succeed("Completed!")
                // close aftr 3 s
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                ProgressHUD.failed(message ?? "Something went wrong.")
            }
        }
    }

    private func skipHabit() {
        print("User skipped the habit for today.")
        ProgressHUD.succeed("Skipped for today.", delay: 1.5)

        // close after 3s
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            presentationMode.wrappedValue.dismiss()
        }
    }


    // MARK: - UI Helpers

    private struct StatCard: View {
        var title: String
        var value: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .bold()
            }
            .frame(minWidth: 100)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}
