//
//  UIViewController+Extension.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func showAlert(titleString:String , messageString:String) {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func openProfileScreen() {
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") ?? ProfileViewController()
        self.pushVC(profileViewController)
    }
    func showHud(_ message: String) {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = message
            hud.isUserInteractionEnabled = false
        }

        func hideHUD() {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
}
