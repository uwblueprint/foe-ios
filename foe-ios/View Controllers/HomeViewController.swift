//
//  ViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-12.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITabBarDelegate {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //Define Outlets
    @IBOutlet weak var landingScrollView: UIScrollView!
    
//    override func viewWillAppear(_ animated: Bool) {
//        tabBar.selectedItem = tabBar.items![0]
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view, typically from a nib.
//        let alert = CustomModal(title: "Which bee?", caption: "Tap the patterns below to determine which species your bee is.", image: UIImage(named: "picker-illustration")!)
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        renderScrollView()
    }
    
    private func renderScrollView() {
        let links : [String:String] = [
            "Visit Friends of Earth":"http://foecanada.org/",
            "Learn about the Bee Cause": "http://foecanada.org/en/issues/the-bee-cause/",
            "Donate to the campaign":"https://foecanada.org/en/donate/",
            "About Blueprint":"https://uwblueprint.org/" ]
        
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
        landingScrollView.bounces = false
    }
    
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.title! {
//        case "Submit":
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "submissionNavigationController")
//            self.present(vc, animated: true)
//        case "Learn":
//            print("pressed learn");
//        default:
//            break
//        }
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

