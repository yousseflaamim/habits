//
//  MainTabView.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HabitListView(viewModel: HabitListViewModel(habitService: FirebaseHabitService()))
                .tabItem {
                    Label("Habits", systemImage: "list.bullet")
                }
            
            AddHabitView(viewModel: AddHabitViewModel(habitService: FirebaseHabitService()))
                .tabItem {
                    Label("Add custom", systemImage: "plus.circle")
                }
            
            Button(action: {
                authViewModel.logout()
            }) {
                Label("Sign Out", systemImage: "power")
            }
            .tabItem {
                Label("Sign Out", systemImage: "power")
            }
        }
    }
}

