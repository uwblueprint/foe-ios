//
//  ViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-12.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, UITabBarDelegate, FBSDKLoginButtonDelegate {

    //Define Outlets
    @IBOutlet weak var landingScrollView: UIScrollView!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.selectedItem = tabBar.items![0]
    }
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
        
        tabBar.delegate = self
        renderScrollView()
    }
    
    private func renderScrollView() {
        let links : [String] = ["Visit Friends of Earth", "Learn about the Bee Cause", "Donate to the campaign" ]
        let landingCardView = CardView(title: "Looks like a beautiful day to spot some bees!", caption: "", subtitle: "Welcome!")
        
        if #available(iOS 11.0, *) {
            landingScrollView.frame.origin = CGPoint(x: 0, y:view.safeAreaInsets.top)
        } else {
            // Fallback on earlier versions
            landingScrollView.frame.origin = CGPoint(x: 0, y:0)
        }
        
        landingCardView.frame.origin = CGPoint(x: 0, y: 0)
        
        landingScrollView.addSubview(landingCardView)
        
        let LLView = LinkListView(title: "Useful Links", links: links)
        
        LLView.frame.origin = CGPoint(x: 0, y: landingCardView.frame.height)
        
        landingScrollView.addSubview(LLView)
        
        landingScrollView.contentSize = CGSize(width: view.frame.width, height: landingCardView.frame.height + LLView.frame.height)
        
        landingScrollView.showsVerticalScrollIndicator = false
        landingScrollView.alwaysBounceVertical = false
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
        case "Submit":
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "submissionNavigationController")
            self.present(vc, animated: true)
        case "Learn":
            print("pressed learn");
        default:
            break
        }
        
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

