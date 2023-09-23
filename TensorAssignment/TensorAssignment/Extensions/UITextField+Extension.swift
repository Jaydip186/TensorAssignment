//
//  UITextField+Extension.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation
import UIKit

extension UITextField {
    //You can change border color and border thickness by pass parameter otherwise bydefault it take black as border color and thickness is 1 pixel
    func addBottomBorder(borderColor: UIColor = UIColor.black, borderSize:Double = 1.0){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - borderSize, width: self.frame.size.width, height: borderSize)
        bottomLine.backgroundColor = borderColor.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
