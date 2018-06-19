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

    var frameView : UIView!
    var activeTextField : UITextField?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    @IBOutlet weak var skyImage: UIImageView!
    
    @IBOutlet weak var emailTextView: LabeledOutlineTextView!
    @IBOutlet weak var passwordTextView: LabeledOutlineTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField = emailTextView.getTextField()
        passwordTextField = passwordTextView.getTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        renderUIButtons()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateSkyBackground()
    }
    
    func animateSkyBackground() {
        let bg_2 = UIImageView()
        bg_2.frame = CGRect(x:-self.view.bounds.width, y: 0, width: self.view.bounds.width*2, height: 175)
        bg_2.image = UIImage(named:"clouds-repeating")
        bg_2.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(bg_2)
        self.view.sendSubview(toBack: bg_2)
        UIView.animate(withDuration: 45.0, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.skyImage.frame.origin.x -= self.view.bounds.width
            bg_2.frame.origin.x -= self.view.bounds.width
            
        }, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardDidChange(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject> {
            let frame = userInfo[UIKeyboardFrameBeginUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            let keyboardHeight = keyboardRect!.height
            
            if (notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame) {
                
                self.view.frame.origin.y = -keyboardHeight
            }
            else {
                self.view.frame.origin.y = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    // render button corners and shadow
    func renderUIButtons() {
        
        for item in [signInButton] {
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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        postLogin()
    }

    func showLoginError(msg: String) {
        let alert = CustomModal(title: "Error", caption: msg, dismissText: "Okay", image: nil, onDismiss: nil)
        alert.show(animated: true)
    }
    
    @IBAction func signupTouchedUpInside(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    private func postLogin() {
        let parameters: Parameters = [
            "email": emailTextField!.text!,
            "password": passwordTextField!.text!
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
                case .failure(_):
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
