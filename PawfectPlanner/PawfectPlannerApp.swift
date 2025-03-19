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
    FirebaseApp.configure()  // ✅ Initialize Firebase

    // ✅ Request notification permission
    NotificationManager.shared.requestPermission()
      
    // ✅ Request Calendar Permission
    CalendarManager.shared.requestCalendarAccess { granted in
        print(granted ? "✅ Calendar Access Granted" : "❌ Calendar Access Denied")
    }

    return true
  }
}

@main
struct PawfectPlannerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
          WelcomeView()
      }
    }
  }
}

