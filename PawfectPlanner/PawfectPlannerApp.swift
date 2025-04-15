//
//  PawfectPlannerApp.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()  // Initialize Firebase

    NotificationManager.shared.requestPermission()

    CalendarManager.shared.requestCalendarAccess { granted in
        print(granted ? "✅ Calendar Access Granted" : "❌ Calendar Access Denied")
    }

    return true
  }
}

@main
struct PawfectPlannerApp: App {
    @StateObject private var fontSettings = FontSettings()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(fontSettings)
        }
    }
}

