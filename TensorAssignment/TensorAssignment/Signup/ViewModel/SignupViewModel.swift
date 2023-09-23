//
//  SignupViewModel.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignupViewModel {
    var email = ""
    var password = ""
    var displayName = ""
    var biography = ""
    var profilePicture: UIImage?

    func signup(completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
            } else if let user = authResult?.user {
                // User successfully signed up, now update user profile
                self.updateUserProfile(for: user, completion: completion)
            }
        }
    }

    private func updateUserProfile(for user: User, completion: @escaping (Bool, Error?) -> Void) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName

        changeRequest.commitChanges { error in
            if let error = error {
                completion(false, error)
            } else {
                // User profile updated successfully, now save other user data
                self.saveUserData(for: user, completion: completion)
            }
        }
    }

    private func saveUserData(for user: User, completion: @escaping (Bool, Error?) -> Void) {
        // Upload profile picture to Firebase Storage if profilePicture is not nil
        if let profilePicture = profilePicture {
            // Upload the image and obtain its download URL
            guard let imageData = profilePicture.jpegData(compressionQuality: 0.5) else {
                completion(false, nil)
                return
            }

            let storageRef = Storage.storage().reference().child("profile_pictures").child(user.uid)
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(false, error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            completion(false, error)
                        } else if let downloadURL = url {
                            // Save user data (including downloadURL) to Firebase Realtime Database
                            let userData = [
                                "displayName": self.displayName,
                                "biography": self.biography,
                                "profilePictureURL": downloadURL.absoluteString
                            ]
                            let dbRef = Database.database().reference().child("users").child(user.uid)
                            dbRef.setValue(userData) { error, _ in
                                completion(error == nil, error)
                            }
                        }
                    }
                }
            }
        } else {
            // Save user data (without profile picture) to Firebase Realtime Database
            let userData = [
                "displayName": self.displayName,
                "biography": self.biography
            ]
            let dbRef = Database.database().reference().child("users").child(user.uid)
            dbRef.setValue(userData) { error, _ in
                completion(error == nil, error)
            }
        }
    }
}
