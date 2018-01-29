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
    var thoraxItems: [NosePickerItem]?
    
    func initializePickers() {
        let thoraxImageNames = [
            "ab_red_tail"
        ]
        
        thoraxItems = thoraxImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickers()
        let thoraxPicker = NosePicker(frame: CGRect(x: 0, y: 530, width: view.frame.width, height: 96), items: thoraxItems!)
        view.addSubview(thoraxPicker)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        previewImage.image = sighting?.getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var previewImage: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
