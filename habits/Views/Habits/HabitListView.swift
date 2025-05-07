//
//  HabitListView.swift
//  habits
//
//  Created by gio on 5/3/25.
//

import SwiftUI
import ProgressHUD
import Charts

struct HabitListView: View {
    @ObservedObject var viewModel: HabitListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)

                List {
                    Section {
                        ForEach(viewModel.habits) { habit in
                            HabitRowView(habit: habit)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteHabit(id: habit.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        viewModel.startEditing(habit: habit)
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                                .onTapGesture {
                                    viewModel.loadProgressData(for: habit)
                                }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("My Habits")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            viewModel.loadHabits()
//                        } label: {
//                            Image(systemName: "chart.bar.fill")
//                        }
//                    }
//                }
         }
            .sheet(isPresented: $viewModel.showProgressView) {
                if let habit = viewModel.selectedHabitForProgress {
                    HabitProgressView(habit: habit, progressData: viewModel.progressData)
                }
            }
            .sheet(isPresented: $viewModel.showEditView) {
                if let habit = viewModel.editingHabit {
                    EditHabitView(habit: habit) { updatedHabit in
                        viewModel.updateHabit(habit: updatedHabit)
                    }
                }
            }
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

struct HabitProgressView: View {
    let habit: Habit
    let progressData: [HabitProgressData]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with subtle background
                    VStack(spacing: 8) {
                        Text(habit.title)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if !habit.description.isEmpty {
                            Text(habit.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    
                    // Elegant chart section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Progress Trend")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.blue)
                        }
                        
                        Chart {
                            ForEach(progressData) { data in
                                BarMark(
                                    x: .value("Date", data.date, unit: .day),
                                    y: .value("Count", data.count)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(6)
                                .shadow(radius: 2)
                            }
                        }
                        .frame(height: 220)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                AxisGridLine()
                                    .foregroundStyle(Color.gray.opacity(0.2))
                                AxisValueLabel(
                                    format: .dateTime.day().month(.abbreviated),
                                    centered: true
                                )
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisGridLine()
                                    .foregroundStyle(Color.gray.opacity(0.2))
                                AxisValueLabel()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    
                    // Minimalist history list
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("History")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "list.bullet")
                                .foregroundColor(.blue)
                        }
                        
                        ForEach(progressData) { data in
                            HStack {
                                Text(data.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("\(data.count)")
                                    .font(.body.monospacedDigit())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue)
                                            .shadow(radius: 1)
                                    )
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.top)
            }
            .navigationTitle("Habit Progress")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}


struct HabitRowView: View {
    let habit: Habit
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        HStack(spacing: 12) {
            // معلومات العادة
            VStack(alignment: .leading, spacing: 6) {
                Text(habit.title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Progress bar and percentage
            ZStack(alignment: .trailing) {
                // bck colore and raduis
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 80, height: 6)
                    .foregroundColor(Color(.systemGray5))
                
                // Animat progress bar
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: CGFloat(animatedProgress) * 80, height: 6)
                    .foregroundColor(progressColor)
                    .shadow(color: progressColor.opacity(0.3), radius: 3, x: 0, y: 2)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedProgress)
                
                // circle %
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(4)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(progressColor)
                            .shadow(color: progressColor.opacity(0.3), radius: 3, x: 0, y: 2)
                    )
                    .offset(x: 18)
            }
            .frame(width: 100, height: 36)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animatedProgress = calculateProgress()
                }
            }
        }
    }
    
    private var progressColor: Color {
        let progress = calculateProgress()
        switch progress {
        case 0..<0.4: return Color(red: 1.0, green: 0.4, blue: 0.4) // lightred
        case 0.4..<0.8: return Color(red: 1.0, green: 0.6, blue: 0.2) // orange
        default: return Color(red: 0.3, green: 0.8, blue: 0.5) // green
        }
    }
    
    private func calculateProgress() -> Double {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: habit.startDate, to: Date()).day ?? 1
        let totalDays = max(daysSinceStart, 1)
        let completionRate = Double(habit.completedDates.count) / Double(totalDays)
        return min(completionRate, 1.0)
    }
}
