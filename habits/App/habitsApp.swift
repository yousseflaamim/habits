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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate : NSObject , UIApplicationDelegate{
    func application (_application: UIApplication, didFinishLaunchingWithOptions launchOption : [UIApplication.LaunchOptionsKey: Any]?)-> Bool {
        FirebaseApp.configure()
        return true
    }
}
