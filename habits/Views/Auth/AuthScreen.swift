//
//  AuthScreen.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

import SwiftUI

struct AuthScreen: View {
    @State private var isLogin = true
    @StateObject var authViewModel = AuthViewModel(authService: FirebaseAuthService())

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
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
            Button("is ok", role: .cancel) {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}
