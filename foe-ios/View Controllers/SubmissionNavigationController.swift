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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
