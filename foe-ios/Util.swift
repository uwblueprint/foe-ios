//
//  Util.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-06-15.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

func snakecaseToCapitalized(_ str: String) -> String {
    let lowercased = str.components(separatedBy: "_")
        .map { return $0.lowercased() }
        .joined(separator: " ")
    return lowercased.prefix(1).capitalized + lowercased.dropFirst()
}

extension UIImage {
    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
