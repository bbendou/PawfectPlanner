////
////  AuthService.swift
////  PawfectPlanner
////
////  Created by Bushra Bendou on 01/03/2025.
////
//
//import FirebaseAuth
//
///// Handles user authentication for PawfectPlanner.
//struct AuthService {
//    
//    /// Signs in a user with email and password.
//    /// - Parameters:
//    ///   - email: The user's email address.
//    ///   - password: The user's password.
//    ///   - completion: A closure returning an error if the sign-in fails.
//    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { _, error in
//            completion(error)
//        }
//    }
//
//    /// Registers a new user with email and password.
//    /// - Parameters:
//    ///   - email: The user's email address.
//    ///   - password: The user's password.
//    ///   - completion: A closure returning an error if the registration fails.
//    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { _, error in
//            completion(error)
//        }
//    }
//    
//    /// Signs out the current user.
//    /// - Throws: An error if sign-out fails.
//    func signOut() throws {
//        try Auth.auth().signOut()
//    }
//}
