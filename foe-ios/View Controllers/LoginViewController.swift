//
//  LoginViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-05-29.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
    }

    // TODO: validation of inputs: email has domain, password must be >= 8 chars

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginButtonClicked(_ sender: Any) {
        postLogin()
    }

    @IBAction func signupButtonClicked(_ sender: Any) {
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        Alamofire.request(
            "\(API_URL)/auth",
             method: .post,
             parameters: parameters,
             encoding: JSONEncoding.default
        ).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Successfully signed up")
                let alert = CustomModal(title: "Welcome!", caption: "Sign-up complete--a confirmation was sent to your email.", dismissText: "Done", image: UIImage(named: "default-home-illustration")!, onDismiss: self.postLogin)
                alert.show(animated: true)
            case .failure(let error):
                print("Validation failure on signup")
                print(error)
            }
        }
    }
    
    private func postLogin() {
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]

        Alamofire.request(
            "\(API_URL)/auth/sign_in",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
            ).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Successfully logged in")
                    ServerGateway.rotateTokens(response)
                    self.goToHome()
                case .failure(let error):
                    print("Validation failure on login")
                    // TODO: handle errors
                }
        }
    }

    func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }
}
