//
//  habitsApp.swift
//  habits
//
//  Created by gio on 4/30/25.
//

import SwiftUI
import Firebase

@main
struct habitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        
        ProgressHUDConfig.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthScreen()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
