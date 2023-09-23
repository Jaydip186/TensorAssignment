//
//  SignupViewController.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 22/09/23.
//

import UIKit
import MBProgressHUD

class SignupViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var profileButton: UIButton!
    
    // Variables
    var viewModel = SignupViewModel()
    var userProfileImage : UIImage?
    let imagePicker = UIImagePickerController()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupUI()
        // Do any additional setup after loading the view.
    }

    // MARK: - Button click action
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTextField.text?.isEmpty ?? true {
            self.showAlert(titleString: "", messageString: EmptyEmail)
        } else if !(self.isValidEmail(emailTextField.text ?? "")) {
            self.showAlert(titleString: "", messageString: InvalidEmail)
        } else if passwordTextField.text?.isEmpty ?? true {
            self.showAlert(titleString: "", messageString: EmptyPassword)
        } else if confirmPasswordTextField.text?.isEmpty ?? true {
            self.showAlert(titleString: "", messageString: EmptyConfirmPassword)
        } else if passwordTextField.text ?? "" != confirmPasswordTextField.text ?? "" {
            self.showAlert(titleString: "", messageString: PasswordMissmatch)
        } else if usernameTextField.text?.isEmpty ?? true {
            self.showAlert(titleString: "", messageString: EmptyUsername)
        }     else {
            viewModel.email = emailTextField.text ?? ""
            viewModel.password = passwordTextField.text ?? ""
            viewModel.displayName = usernameTextField.text ?? ""
            viewModel.biography = bioTextField.text ?? ""
            viewModel.profilePicture = userProfileImage
            
            showHud("Please wait..")
            viewModel.signup { success, error in
                self.hideHUD()
                if success {
                    self.openProfileScreen()
                } else if let error = error {
                    print("Signup error: \(error.localizedDescription)")
                    self.showAlert(titleString: "Error", messageString: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func profileImageChangeAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Select Image from", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func showPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func showConfirmPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    // MARK: - functions
    func setupUI() {
        self.view.layoutIfNeeded()
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        confirmPasswordTextField.addBottomBorder()
        bioTextField.addBottomBorder()
        usernameTextField.addBottomBorder()
    }
    
    // Function to open the image picker for the gallery
    func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Function to open the image picker for the camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Camera is not available on this device, display an error message
            self.showAlert(titleString: "", messageString: "Sorry, this device has no camera.")
        }
    }

}

extension SignupViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignupViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                userProfileImage = pickedImage
                profileButton.setImage(pickedImage, for: .normal)
            }
            dismiss(animated: true, completion: nil)
        }

        // Delegate method called when the user cancels the image picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}
