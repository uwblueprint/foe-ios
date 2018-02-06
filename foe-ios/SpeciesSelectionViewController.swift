//
//  SpeciesSelectionViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-01-25.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SpeciesSelectionViewController: UIViewController {

    var sighting: Sighting?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: "goToNextScreen")
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.rightBarButtonItem = nextButton
        self.navigationItem.title = "Step 2: Identify"

        previewImage.image = sighting?.getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var previewImage: UIImageView!
    
    // MARK: - Actions
    
    func goToNextScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsFormViewController") as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
