//
//  AppUser.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import Foundation

struct AppUser: Identifiable, Codable {
    let id: String
    let email: String
    var displayName: String
    let joinedDate: Date
    
    
}
