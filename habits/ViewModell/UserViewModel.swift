//
//  UserViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation

class UserViewModel: ObservableObject {
    @Published var user: AppUser?

    init(user: AppUser?) {
        self.user = user
    }

    func updateDisplayName(_ name: String) {
        // Update display name logic, if needed
        user?.displayName = name
    }
}
