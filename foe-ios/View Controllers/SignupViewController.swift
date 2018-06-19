//
//  SignupViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextView: LabeledOutlineTextView!
    @IBOutlet weak var emailTextView: LabeledOutlineTextView!
    @IBOutlet weak var passwordTextView: LabeledOutlineTextView!
    @IBOutlet weak var reenteredPasswordTextView: LabeledOutlineTextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var tvs : [LabeledOutlineTextView] = []
    
    var activeTextField : UITextField?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        tvs += [nameTextView, emailTextView, passwordTextView, reenteredPasswordTextView]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTouchedUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
