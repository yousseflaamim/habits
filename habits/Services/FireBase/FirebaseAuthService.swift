//
//  FirebaseAuthService.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import FirebaseAuth

class FirebaseAuthService: AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let appUser = AppUser(
                    id: user.uid,
                    email: user.email ?? "",
                    displayName: user.displayName ?? "",
                    joinedDate: user.metadata.creationDate ?? Date()
                )
                completion(.success(appUser))
            }
        }
    }

    func register(email: String, password: String, displayName: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { _ in
                    let appUser = AppUser(
                        id: user.uid,
                        email: user.email ?? "",
                        displayName: displayName,
                        joinedDate: Date() // Use current date for registration time
                    )
                    completion(.success(appUser))
                }
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
    }

    func currentUser() -> AppUser? {
        guard let user = Auth.auth().currentUser else { return nil }
        return AppUser(
            id: user.uid,
            email: user.email ?? "",
            displayName: user.displayName ?? "",
            joinedDate: user.metadata.creationDate ?? Date() 
        )
    }
}
