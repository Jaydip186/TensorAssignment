//
//  LoginViewModel.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation

import FirebaseAuth

class LoginViewModel {
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            completion(error == nil, error)
        }
    }
}
