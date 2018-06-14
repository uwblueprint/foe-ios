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

class LoginViewController: UIViewController, UITextFieldDelegate {

    var frameView : UIView!
    var activeTextField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in [emailTextField, passwordTextField] {
            let textField = item as UITextField?
            textField!.delegate = self
        }
        
        renderUIButtons()
        setupKeyboardNotificationCenter()
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
        
        if (activeTextField == emailTextField) {
            passwordTextField.becomeFirstResponder()
        }
        
        return false
    }
    
    
    func setupKeyboardNotificationCenter() {
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardDidShow(notification:NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.bounds.height - keyboardSize.height
        let padding: CGFloat = 100
        let activeTextFieldY : CGFloat! = self.activeTextField?.frame.origin.y
        
        if ((self.view.frame.origin.y >= 0.0) && (activeTextFieldY > keyboardY - padding)) {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                print("animate")
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (activeTextFieldY! - (keyboardY - padding)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.frame.origin.y = 0;
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.frame.origin.y = 0;
        }, completion: nil)
    }
    
    // render button corners and shadow
    func renderUIButtons() {
        
        for item in [signInButton, facebookButton] {
            let button = item as UIButton?
            button!.layer.cornerRadius = button!.frame.height/2
            
            let shadowPath = UIBezierPath(rect: button!.bounds)
            button!.layer.masksToBounds = false
            button!.layer.shadowColor = UIColor.black.cgColor
            button!.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            button!.layer.shadowOpacity = 0.16
            button!.layer.shadowPath = shadowPath.cgPath
            button!.layer.shadowRadius = 6
            
        }
        
    }
    // TODO: validation of inputs: email has domain, password must be >= 8 chars

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailPrompt: UILabel!
    @IBOutlet weak var emailOutline: UIView!
    @IBOutlet weak var passwordPrompt: UILabel!
    @IBOutlet weak var passwordOutline: UIView!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        postLogin()
    }

    func showLoginError(msg: String) {
        let alert = CustomModal(title: "Error", caption: msg, dismissText: "Okay", image: nil, onDismiss: nil)
        alert.show(animated: true)
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
                self.showLoginError(msg: "A server problem was encountered, please try again.")
                print("Validation failure on signup")
                print(error)
            }
        }
    }
    
    func renderInputActiveState(label: UILabel, outline: UIView, isActive: Bool) {
        let color : UIColor = isActive ? UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0) : UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        
        UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            label.textColor = color
        }, completion: nil)
        
        UIView.transition(with: outline, duration: 0.2, options: .transitionCrossDissolve, animations: {
            outline.backgroundColor = color
        }, completion: nil)
    }
    
    @IBAction func emailEditingDidBegin(_ sender: Any) {
        renderInputActiveState(label: emailPrompt, outline: emailOutline, isActive: true)
    }
    
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        renderInputActiveState(label: emailPrompt, outline: emailOutline, isActive: false)
    }
    
    @IBAction func passwordEditingDidBegin(_ sender: Any) {
        renderInputActiveState(label: passwordPrompt, outline: passwordOutline, isActive: true)
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        renderInputActiveState(label: passwordPrompt, outline: passwordOutline, isActive: false)
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
                    self.showLoginError(msg: "A server problem was encountered, please try again.")
                    print("Validation failure on login")
                    // TODO: handle errors
                }
        }
    }

    func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }
}
