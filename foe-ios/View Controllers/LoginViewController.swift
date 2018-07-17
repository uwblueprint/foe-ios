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
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var av : UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var skyImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet var loginTopOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextView: LabeledOutlineTextView!
    @IBOutlet weak var passwordTextView: LabeledOutlineTextView!
    
    @IBOutlet var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        av.hidesWhenStopped = true
        
        emailTextField = emailTextView.getTextField()
        passwordTextField = passwordTextView.getTextField()
        renderUIButtons()
        
        self.hideKeyboardWhenTappedAround()
        
        if (isIPhone4) {
            logoImageView.removeFromSuperview()
        }
        else if (isIPhoneSE) {
            loginTopOffsetConstraint.constant = 24
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateSkyBackground()
    }
    
    func animateSkyBackground() {
        let bg_2 = UIImageView()
        bg_2.frame = CGRect(x:-self.view.bounds.width, y: 0, width: self.view.bounds.width*2, height: 175)
        bg_2.image = UIImage(named:"clouds-repeating")
        bg_2.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(bg_2)
        self.view.sendSubview(toBack: bg_2)
        UIView.animate(withDuration: 45.0, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.skyImage.frame.origin.x -= self.view.bounds.width
            bg_2.frame.origin.x -= self.view.bounds.width
            
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardDidChange(notification: Notification) {
        var activeTextView : LabeledOutlineTextView?
        
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject> {
            let frame = userInfo[UIKeyboardFrameBeginUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            let keyboardHeight = keyboardRect!.height
            
            if (notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame) {
                
                let padding : CGFloat = 60
                
                //get active field
                for item in [emailTextView, passwordTextView] {
                    let view = item as LabeledOutlineTextView?
                    if (view!.isActive!) {
                        activeTextView = item
                        break
                    }
                }
                
                //test whether field.y overlaps keyboard; if so, shift view up by offset
                if (activeTextView!.frame.maxY + padding >= self.view.frame.height - keyboardHeight) {
                    let offset = activeTextView!.frame.maxY + padding - (self.view.frame.height - keyboardHeight)
                    self.view.frame.origin.y = -offset
                }
            }
            else {
                self.view.frame.origin.y = 0
                activeTextView = nil
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
    
    func setError(msg: String) {
        errorLabel.text = msg
        emailTextView.displayAsError()
        passwordTextView.displayAsError()
    }
    
    func resetError() {
        errorLabel.text = ""
        emailTextView.displayAsDefault()
        passwordTextView.displayAsDefault()
    }
    
    private func postLogin() {
        let lblMsg = signInButton.titleLabel!.text
        signInButton.startLoading(activityIndicator: av)
        self.resetError()
        
        do {
            let account = try LoginAccount(email: emailTextField!.text!, password: passwordTextField!.text!)
            
            let parameters: Parameters = [
                "email": account.email,
                "password": account.password
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
                        self.signInButton.stopLoading(activityIndicator: self.av, msg: lblMsg!)
                        self.goToHome()
                    case .failure(_):
                        self.setError(msg: "Invalid email and/or password.")
                        print("Validation failure on login")
                        // TODO: handle errors
                        self.signInButton.stopLoading(activityIndicator: self.av, msg: lblMsg!)
                    }
            }
        } catch let e as LoginError {
            self.setError(msg: e.msg)
            self.signInButton.stopLoading(activityIndicator: self.av, msg: lblMsg!)
        } catch {}
    }

    func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIButton {
    
    private func centerActivityIndicatorInButton(av: UIActivityIndicatorView ) {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: av, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: av, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    func startLoading(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.titleLabel?.text = ""
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton(av: activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading(activityIndicator: UIActivityIndicatorView, msg: String) {
        activityIndicator.stopAnimating()
        self.titleLabel?.isHidden = false
        self.titleLabel?.text = msg
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
