//
//  FirebaseManager.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Combine
import FirebaseFunctions

class FirebaseManager {
    // MARK: - Singleton Instance
    static let shared = FirebaseManager()
    
    // MARK: - Firebase Services
    let auth: Auth
    let db: Firestore
    let storage: Storage
    let functions: Functions
    
    // MARK: - Publishers
    @Published var currentUser: User?
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    private init() {
        // Configure Firebase if not already configured
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Initialize services
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
        self.functions = Functions.functions()
        
        // Configure Firestore
        configureFirestore()
        
        // Set up auth state listener
        setupAuthListener()
    }
    
    // MARK: - Configuration
    private func configureFirestore() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
    }
    
    private func setupAuthListener() {
        authStateHandler = auth.addStateDidChangeListener { [weak self] (_, user) in
            self?.currentUser = user
        }
    }
    
    // MARK: - Helper Methods
    func currentUserId() -> String? {
        auth.currentUser?.uid
    }
    
    func currentUserToken() async throws -> String {
        guard let user = auth.currentUser else {
            throw NSError(domain: "FirebaseError", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        return try await user.getIDToken()
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Cleanup
    deinit {
        if let handler = authStateHandler {
            auth.removeStateDidChangeListener(handler)
        }
    }
}

// MARK: - Extensions
extension FirebaseManager {
    // Firestore reference helpers
    func userDocument(userId: String) -> DocumentReference {
        db.collection("users").document(userId)
    }
    
    func habitsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("habits")
    }
    
    // Storage reference helpers
    func profileImageReference(userId: String) -> StorageReference {
        storage.reference().child("profile_images/\(userId).jpg")
    }
}
