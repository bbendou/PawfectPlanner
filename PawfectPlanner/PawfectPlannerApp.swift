//
//  PawfectPlannerApp.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    // ✅ Request notification permission when the app launches
    NotificationManager.shared.requestPermission()
      
      // ✅ Request Calendar Permission on App Launch (iOS 17+ Supported)
      CalendarManager.shared.requestCalendarAccess { granted in
          if granted {
              print("✅ Calendar Access Granted")
          } else {
              print("❌ Calendar Access Denied")
          }
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
        ContentView()
      }
    }
  }
}

