//
//  SettingsTabView.swift
//  habits
//
//  Created by gio on 5/4/25.
//


import SwiftUI
import ProgressHUD

struct SettingsTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        ProgressHUD.animate("Signing out...", .circleStrokeSpin)
                        authViewModel.logout()
                        ProgressHUD.dismiss()
                    }) {
                        Label("Sign Out", systemImage: "power")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
