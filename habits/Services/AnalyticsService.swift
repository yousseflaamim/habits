//
//  AnalyticsService.swift
//  habits
//
//  Created by gio on 5/3/25.
//


import Foundation

class AnalyticsService {
    static let shared = AnalyticsService()

    func logEvent(_ name: String, parameters: [String: Any] = [:]) {
        print("Logged event:", name, parameters)
        // Placeholder for Firebase Analytics or another analytics provider
    }
}
