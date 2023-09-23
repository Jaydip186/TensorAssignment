//
//  LoginViewController.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 22/09/23.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Variables
    let viewModel = LoginViewModel()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Button click action
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        self.showHud("Please wait..")
        viewModel.signIn(email: email, password: password) { [weak self] success, error in
            self?.hideHUD()
            if success {
                self?.openProfileScreen()
            } else {
                if self?.emailTextField.text?.isEmpty ?? true {
                    self?.showAlert(titleString: "", messageString: EmptyEmail)
                } else if !(self?.isValidEmail(self?.emailTextField.text ?? "") ?? true) {
                    self?.showAlert(titleString: "", messageString: InvalidEmail)
                } else if self?.passwordTextField.text?.isEmpty ?? true {
                    self?.showAlert(titleString: "", messageString: EmptyPassword)
                } else {
                    self?.showAlert(titleString: "", messageString: "\(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") ?? SignupViewController()
        self.pushVC(signupViewController)
    }
    
    @IBAction func showPasswordAction(_ sender: UIButton) {
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
    }
    
    
}

// MARK: - TextField Delegate
extension LoginViewController :UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
