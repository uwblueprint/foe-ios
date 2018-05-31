//
//  SightingDetailViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-30.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SightingDetailViewController: UIViewController {
    
    var sightingModel = Sighting()
    
    //MARK: Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    var statusBarShouldBeHidden = true
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func handleSightingCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidLoad() {
        print("view created")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        photoImageView.image = sightingModel.getImage()
        
        // set photo's top constraint = device screen top
        NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        let gradientView = UIView(frame: photoImageView.frame)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y:0.6)
        let blackColor = UIColor.black
        gradient.colors = [blackColor.withAlphaComponent(0.5).cgColor, blackColor.withAlphaComponent(0.2), blackColor.withAlphaComponent(0.0).cgColor]
        //        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
        photoImageView.addSubview(gradientView)
        photoImageView.bringSubview(toFront: gradientView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
