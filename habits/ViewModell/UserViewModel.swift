//
//  UserViewModel.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation
import SwiftUI
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    
    init(user: AppUser?, authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.user = user
        self.authService = authService
    }
    
    func updateDisplayName(_ name: String) {
        isLoading = true
        errorMessage = nil
        
        authService.updateDisplayName(name) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    self?.user?.displayName = name
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateProfileImage(_ image: UIImage) {
        isLoading = true
        errorMessage = nil
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Failed to process image"
            isLoading = false
            return
        }
        
        authService.uploadProfileImage(imageData) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let url):
                    self?.user?.profileImageUrl = url
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
