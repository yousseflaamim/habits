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

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    func register(email: String, password: String, displayName: String, completion: @escaping (Bool, String) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }

                if let user = result?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            completion(false, error.localizedDescription)
                            return
                        }
                        completion(true, "Account created successfully!")
                    }
                } else {
                    completion(false, "Unknown error occurred.")
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
