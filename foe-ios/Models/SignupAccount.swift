//
//  SignupAccount.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-20.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation

struct SignupError : Error {
    let msg: String
    let views: [LabeledOutlineTextView]
}

class SignupAccount {
    var nameView : LabeledOutlineTextView
    var emailView: LabeledOutlineTextView
    var passwordView : LabeledOutlineTextView
    var reenterPasswordView : LabeledOutlineTextView
    
    var name : String
    var email : String
    var password : String
    var reenteredPassword : String
    
    init(nameView: LabeledOutlineTextView, emailView: LabeledOutlineTextView, passwordView: LabeledOutlineTextView, reenterPasswordView: LabeledOutlineTextView) throws {
        self.nameView = nameView
        self.emailView = emailView
        self.passwordView = passwordView
        self.reenterPasswordView = reenterPasswordView
        
        self.name = nameView.getTextField().text!
        self.email = emailView.getTextField().text!
        self.password = passwordView.getTextField().text!
        self.reenteredPassword = reenterPasswordView.getTextField().text!
        
        //Validate account signup information on client-side
        if (name == "" || email == "" || password == "" || reenteredPassword == "") {
            //Test: Empty fields
            var fields : [LabeledOutlineTextView] = []
            
            for item in [nameView, emailView, passwordView, reenterPasswordView] {
                let view = item as LabeledOutlineTextView?
                
                if (view!.getTextField().text == "") {
                    fields.append(view!)
                }
            }
            throw SignupError(msg: "Please enter the missing fields", views: fields)
        }
        else if (!isValidEmail()) {
            //Test: Email is valid regex pattern
            throw SignupError(msg: "Please enter a valid email address", views: [emailView])
        }
        else if (password != reenteredPassword) {
            //Test: Passwords match
            throw SignupError(msg: "Your passwords do not match.", views: [passwordView, reenterPasswordView])
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
