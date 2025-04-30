//
//  FirebaseManager.swift
//  habits
//
//  Created by gio on 4/30/25.
//
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager{
    static let shared = FirebaseManager()
    let auth :Auth
    let db : Firestore
    
    private init(){
        FirebaseApp.configure()
        auth = Auth.auth()
        db = Firestore.firestore()
    }
    
}
