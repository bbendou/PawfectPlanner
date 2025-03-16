//
//  CalendarManager.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 12/03/2025.
//
import EventKit

class CalendarManager {
    static let shared = CalendarManager()
    let eventStore = EKEventStore()

    // ✅ Request Full Access to Calendar (iOS 17+ Supported)
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }

    func addReminderToCalendar(title: String, frequency: String, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        requestCalendarAccess { granted in
            guard granted else {
                print("❌ Access to calendar denied")
                completion(false, nil)
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = title
            event.startDate = date
            event.endDate = date.addingTimeInterval(3600) // Default 1-hour duration
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            // ✅ Ensure "Once" Reminders Have No Recurrence
            if frequency != "Once" {
                switch frequency {
                case "Daily":
                    event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)]
                case "Weekly":
                    event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)]
                case "Monthly":
                    event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)]
                case "Yearly":
                    event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)]
                default:
                    break
                }
            } else {
                event.recurrenceRules = nil // 🛑 Prevents unwanted recurrence
            }

            do {
                try self.eventStore.save(event, span: .thisEvent)
                print("✅ Event added to calendar: \(title) with frequency: \(frequency)")
                completion(true, nil)
            } catch {
                print("❌ Error saving event: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }

    }
