//
//  LoginAccount.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-26.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation

struct LoginError : Error {
    let msg: String
}

class LoginAccount {
    var email : String
    var password : String
    
    init(email: String, password: String) throws {
        if (email == "" || password == "") {
            throw LoginError(msg: "Please enter a valid email and password.")
        }
        self.email = email
        self.password = password
    }
}
