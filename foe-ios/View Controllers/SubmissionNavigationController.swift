//
//  SubmissionNavigationController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-01-25.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SubmissionNavigationController: UINavigationController {

    var sighting = Sighting()
    public var barStyle : UIStatusBarStyle = .lightContent

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSighting() -> Sighting {
        return sighting
    }
    
    func setSighting(sighting: Sighting){
        self.sighting = sighting
    }
    
    func setStatusBartoDefault() {
        barStyle = .default
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setStatusBartoLight() {
        barStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
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
