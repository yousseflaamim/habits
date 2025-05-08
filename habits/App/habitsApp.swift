//
//  habitsApp.swift
//  habits
//
//  Created by gio on 4/30/25.
//

import UIKit
import SwiftUI
import Firebase
import UserNotifications

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

//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        UNUserNotificationCenter.current().delegate = self
//        NotificationService.shared.requestPermission()
//        return true
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        if let habitId = userInfo["habitId"] as? String {
//            UserDefaults.standard.set(habitId, forKey: "deepLinkHabitId")
//            NotificationCenter.default.post(name: NSNotification.Name("DeepLinkReceived"), object: nil)
//        }
//        completionHandler()
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .badge])
//    }
//}
