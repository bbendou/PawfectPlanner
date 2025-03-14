////
////  ReminderService.swift
////  PawfectPlanner
////
////  Created by Bushra Bendou on 01/03/2025.
////
//
//import FirebaseFirestore
//
///// Handles Firestore operations for pet reminders.
//struct ReminderService {
//    
//    private let db = Firestore.firestore()
//
//    /// Adds a reminder for a pet owner.
//    /// - Parameters:
//    ///   - userID: The ID of the user.
//    ///   - title: The reminder title.
//    ///   - dateTime: The reminder time (ISO8601 format).
//    ///   - completion: A closure returning an error if the operation fails.
//    func addReminder(userID: String, title: String, dateTime: String, completion: @escaping (Error?) -> Void) {
//        let reminderData: [String: Any] = [
//            "userID": userID,
//            "title": title,
//            "dateTime": dateTime
//        ]
//        
//        db.collection("reminders").addDocument(data: reminderData) { error in
//            completion(error)
//        }
//    }
//}
