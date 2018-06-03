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

    // TODO: update URL "https://foe-api.herokuapp.com/auth"
    private var API_URL: String = "http://0a77732f.ngrok.io"

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
        
        // TODO: update URL "https://foe-api.herokuapp.com/auth"
        Alamofire.request(
            "\(API_URL)/auth/sign_in",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
            ).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Successfully logged in")

                    if
                        let accessToken = response.response?.allHeaderFields["access-token"] as! String?,
                        let client = response.response?.allHeaderFields["client"] as! String?,
                        let uid = response.response?.allHeaderFields["uid"] as! String?
                    {
                        print("accessToken: \(accessToken)")
                        KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
                        KeychainWrapper.standard.set(client, forKey: "client")
                        KeychainWrapper.standard.set(uid, forKey: "uid")
                    }
                    
                    let retrieved: String = KeychainWrapper.standard.string(forKey: "accessToken")!
                    print("retrieved from keychain: \(retrieved)")

                    self.goToHome()
                case .failure(let error):
                    print("Validation failure on login")
                    // TODO: handle errors
                }
        }
    }

    private func goToHome() {
        performSegue(withIdentifier: "showHomeSegue", sender: nil)
    }
}
