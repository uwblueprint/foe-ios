//
//  SignupViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Alamofire
import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var confirmationView: emptyHistoryView!
    // MARK: - Outlets
    @IBOutlet weak var nameTextView: LabeledOutlineTextView!
    @IBOutlet weak var emailTextView: LabeledOutlineTextView!
    @IBOutlet weak var passwordTextView: LabeledOutlineTextView!
    @IBOutlet weak var reenteredPasswordTextView: LabeledOutlineTextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupViewLeadingConstraint: NSLayoutConstraint!
    
    var tvs : [LabeledOutlineTextView] = []
    
    var activeTextField : UITextField?
    
    func setupConfirmationView(account: SignupAccount) {
        confirmationView.setVerticalOffset(y: -124)
        
        if let firstName = account.name.components(separatedBy: " ").first {
            confirmationView.titleLabel.text = "Almost there, \(firstName)!"
        }
        
        confirmationView.descriptionLabel.text = "We’ve sent an email to \(account.email) with a confirmation link to complete your signup."
        
        confirmationView.descriptionLabel.numberOfLines = 0
        confirmationView.descriptionLabel.sizeToFit()
    }
    
    func renderUI() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blur.frame = closeButton.bounds
        blur.layer.cornerRadius = 20
        blur.clipsToBounds = true
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        closeButton.insertSubview(blur, at: 0)
        closeButton.bringSubview(toFront: closeButton.imageView!)
        
        signupButton.layer.cornerRadius = signupButton.frame.height/2
        
        let shadowPath = UIBezierPath(rect: signupButton.bounds)
        signupButton.layer.masksToBounds = false
        signupButton.layer.shadowColor = UIColor.black.cgColor
        signupButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        signupButton.layer.shadowOpacity = 0.16
        signupButton.layer.shadowPath = shadowPath.cgPath
        signupButton.layer.shadowRadius = 6
    }
    
    @objc func keyboardDidChange(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject> {
            let frame = userInfo[UIKeyboardFrameBeginUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            let keyboardHeight = keyboardRect!.height
            
            if (notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame) {
                
                var activeTextView : LabeledOutlineTextView?
                let padding : CGFloat = 60
                
                //get active field
                for item in tvs {
                    if (item.isActive!) {
                        activeTextView = item
                        break
                    }
                }
                
                let superViewY = activeTextView?.superview!.frame.minY
                
                //test whether field.y overlaps keyboard; if so, shift view up by offset
                if ( superViewY! + activeTextView!.frame.maxY + padding >= self.view.frame.height - keyboardHeight) {
                    print("\(activeTextView!.label!.text!) overlaps")
                    let offset = superViewY! + activeTextView!.frame.maxY + padding - (self.view.frame.height - keyboardHeight)
                    self.view.frame.origin.y = -offset
                }
                
            }
            else {
                self.view.frame.origin.y = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        tvs += [nameTextView, emailTextView, passwordTextView, reenteredPasswordTextView]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setError(msg: String, errorViews: [LabeledOutlineTextView]) {
        errorLabel.text = msg
        for item in errorViews {
            let view = item as LabeledOutlineTextView
            view.displayAsError()
        }
    }
    
    func resetErrors() {
        errorLabel.text = ""
        for item in [nameTextView, emailTextView, passwordTextView, reenteredPasswordTextView] {
            let view = item as LabeledOutlineTextView?
            view!.displayAsDefault()
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        resetErrors()
        
        do {
            let account = try SignupAccount(nameView: nameTextView, emailView: emailTextView, passwordView: passwordTextView, reenterPasswordView: reenteredPasswordTextView)
            
            postSignupToServer(account: account)
            
        } catch let e as SignupError {
            setError(msg: e.msg, errorViews: e.views)
        } catch {}

        
    }
    
    @IBAction func closeButtonTouchedUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnToLoginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resendEmailPressed(_ sender: Any) {
    }
    
    func postSignupToServer(account: SignupAccount) {
        let av = UIActivityIndicatorView()
        signupButton.startLoading(activityIndicator: av)
        
        let parameters: Parameters = [
            "name": account.name,
            "email": account.email,
            "password": account.password
        ]
        
        Alamofire.request(
            "\(API_URL)/auth",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
            ).validate().responseJSON { response in
                switch response.result {
                case .success:
                    self.signupButton.stopLoading(activityIndicator: av)
                    self.setupConfirmationView(account: account)
                    
                    UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                        self.signupViewLeadingConstraint.constant = -self.view.bounds.width
                        self.view.layoutIfNeeded()
                        
                    }, completion: nil)
                    
                    
                case .failure(let error):
                    self.signupButton.stopLoading(activityIndicator: av)
                    print("Validation failure on signup")
                    print(error)
                }
        }
    }
    
}
