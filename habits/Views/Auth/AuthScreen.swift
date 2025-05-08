//
//  AuthScreen.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

struct AuthScreen: View {
    @State private var isLogin = true
    @StateObject var authViewModel = AuthViewModel(authService: FirebaseAuthService())
    @State private var selectedHabit: Habit?
    @State private var deepLinkHabitId: String?
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                NavigationView {
                    MainTabView()
                        .environmentObject(authViewModel)
                        .onAppear {
                            handleDeepLink()
                        }
                        .sheet(item: $selectedHabit) { habit in
                            HabitDetailView(habit: habit)
                                .environmentObject(authViewModel)
                        }
                }
            } else {
                ZStack {
                    if isLogin {
                        LoginView(authViewModel: authViewModel, switchToRegister: {
                            withAnimation {
                                isLogin = false
                            }
                        })
                    } else {
                        RegisterView(authViewModel: authViewModel, switchToLogin: {
                            withAnimation {
                                isLogin = true
                            }
                        })
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            }
        }
        .alert("Error", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DeepLinkReceived"))) { _ in
            handleDeepLink()
        }
    }
    
    private func handleDeepLink() {
        guard let habitId = UserDefaults.standard.string(forKey: "deepLinkHabitId") else { return }
        UserDefaults.standard.removeObject(forKey: "deepLinkHabitId")
        
        let habitService = FirebaseHabitService()
        habitService.fetchHabits { result in
            switch result {
            case .success(let habits):
                if let habit = habits.first(where: { $0.id == habitId }) {
                    DispatchQueue.main.async {
                        self.selectedHabit = habit
                    }
                }
            case .failure(let error):
                print("Failed to fetch habits for deep link: \(error.localizedDescription)")
            }
        }
    }
}
