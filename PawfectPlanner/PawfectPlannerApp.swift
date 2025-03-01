//
//  PawfectPlannerApp.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//
import SwiftUI
import Firebase

@main
struct PawfectPlannerApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

