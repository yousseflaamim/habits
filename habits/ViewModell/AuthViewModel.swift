//
//  AuthViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//
import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var user: AppUser?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        checkAuthStatus()
    }

    func login(email: String, password: String) {
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func register(email: String, password: String, displayName: String) {
        authService.register(email: email, password: password, displayName: displayName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        authService.logout()
        self.isAuthenticated = false
        self.user = nil
    }

    private func checkAuthStatus() {
        if let user = authService.currentUser() {
            self.user = user
            self.isAuthenticated = true
        }
    }
}
