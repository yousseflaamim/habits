//
//  HabitListView.swift
//  habits
//
//  Created by gio on 5/3/25.
//


import SwiftUI
import ProgressHUD

struct HabitListView: View {
    @ObservedObject var viewModel: HabitListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.habits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
                        VStack(alignment: .leading) {
                            Text(habit.title).font(.headline)
                            Text(habit.description).font(.subheadline)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.deleteHabit(id: viewModel.habits[index].id)
                    }
                }
            }
            .navigationTitle("My Habits")
            .onAppear {
                ProgressHUD.animate("Loading habits...", .circleStrokeSpin)
                viewModel.loadHabits()
            }
            .onDisappear {
               ProgressHUD.dismiss()
                        }
            .onChange(of: viewModel.isLoading) { isLoading in
                if !isLoading {
                    ProgressHUD.dismiss()
                }
            }
            .onChange(of: viewModel.errorMessage) { message in
                if let msg = message {
                    ProgressHUD.failed(msg)
                }
            }
        }
    }
}

