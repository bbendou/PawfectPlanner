//
//  NotificationManager.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 12/03/2025.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("✅ Notifications allowed!")
            } else {
                print("❌ Notifications denied!")
            }
        }
    }

    func scheduleNotification(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "🐾 Reminder: \(reminder.title)"
        content.body = "Time for \(reminder.event.lowercased()) for \(reminder.pet)!"
        content.sound = UNNotificationSound.default

        var trigger: UNCalendarNotificationTrigger?

        switch reminder.frequency {
        case "Once":
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        case "Daily":
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        case "Weekly":
            let weekday = Calendar.current.component(.weekday, from: reminder.time)
            var triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            triggerDate.weekday = weekday
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        case "Monthly":
            let day = Calendar.current.component(.day, from: reminder.time)
            var triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            triggerDate.day = day
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        case "Yearly":
            let month = Calendar.current.component(.month, from: reminder.time)
            let day = Calendar.current.component(.day, from: reminder.time)
            var triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            triggerDate.month = month
            triggerDate.day = day
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        default:
            print("Unknown frequency")
            return
        }

        let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for \(reminder.time)")
            }
        }
    }


    func removeNotification(reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
        print("🗑 Notification removed for \(reminder.title)")
    }
}
