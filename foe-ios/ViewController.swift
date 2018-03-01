//
//  ViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-12.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let loginButton = FBSDKLoginButton()
//        view.addSubview(loginButton)
//        //frame's are obselete, please use constraints instead because its 2016 after all
//        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
//
//        loginButton.delegate = self
//        // Do any additional setup after loading the view, typically from a nib.
//        let alert = CustomModal(title: "Which bee?", caption: "Tap the patterns below to determine which species your bee is.", image: UIImage(named: "picker-illustration")!)
        
        let landingCardView = CardView(title: "Looks like a beautiful day to spot some bees!", caption: "", subtitle: "Welcome!")
        
        if #available(iOS 11.0, *) {
            landingCardView.frame.origin = CGPoint(x: 0, y:view.safeAreaInsets.top)
        } else {
            // Fallback on earlier versions
            landingCardView.frame.origin = CGPoint(x: 0, y:0)
        }
        view.addSubview(landingCardView)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

