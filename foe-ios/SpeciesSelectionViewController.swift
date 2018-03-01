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
    var abdomenItems: [NosePickerItem]?
    var faceItems: [NosePickerItem]?
    
    var partsPicker : NosePicker?
    var activePartIndex : Int = 0
    var partsButtons = [UIButton]()
    var pickers = [[NosePickerItem]]()
    
    func initializePickers() {
        let abdomenImageNames = [
            "ab_byb",
            "ab_yry",
            "ab_yyy",
            "ab_yb",
            "ab_yby",
            "ab_red_tail",
            "ab_white_tail",
            "ab_y_stripe"
        ]
        
        let thoraxImageNames = [
            "thorax_yyy",
            "thorax_ybb",
            "thorax_yby",
            "thorax_bdot",
            "thorax_whsh"
        ]
        
        let faceImageNames = [
            "face_black",
            "face_yellow"
        ]
        
        faceItems = faceImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        thoraxItems = thoraxImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        abdomenItems = abdomenImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        
        pickers.append(faceItems!)
        pickers.append(thoraxItems!)
        pickers.append(abdomenItems!)
    }

    private func setPartWithIdentifier(id: String) {
        sighting?.setPartIdentifier(index: activePartIndex, val: id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickers()
        
        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        //add buttons and set initial state to face
        self.partsButtons.append(faceButton)
        self.partsButtons.append(thoraxButton)
        self.partsButtons.append(abdomenButton)
        
        partsPicker = NosePicker(frame: CGRect(x: 0, y: partsLabelsRow.frame.maxY, width: view.frame.width, height: 96), items: faceItems!, updateCallback: self.setPartWithIdentifier)
        
        view.addSubview(partsPicker!)
        
        updateButtons()
        
        let alert = CustomModal(title: "Which bee?", caption: "Tap the patterns below to determine which species your bee is.", image: UIImage(named: "picker-illustration")!)
        
        alert.show(animated: true)
    }
    
    func updateButtons() {
        for i in 0..<self.partsButtons.count {
            if i == self.activePartIndex {
                self.partsButtons[i].setTitleColor(UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0), for: UIControlState.normal)
            }
            else {
                self.partsButtons[i].setTitleColor(UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0), for: UIControlState.normal)
            }
        }
        
        partsPicker?.loadNewButtons(newItems: pickers[self.activePartIndex], activeId: sighting!.getPartIdentifier(index: activePartIndex)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set nav controller to light mode
        let navController = self.navigationController as! SubmissionNavigationController
        navController.navigationBar.barTintColor = UIColor.white
        navController.navigationBar.tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        navController.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!, NSForegroundColorAttributeName : UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0) ]
        self.navigationItem.title = "Step 2: Identify".uppercased()
        
        previewImage.image = sighting?.getImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var partsLabelsRow: UIStackView!
    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var thoraxButton: UIButton!
    @IBOutlet weak var abdomenButton: UIButton!
    
    @IBAction func faceButtonTouched(_ sender: Any) {
        self.activePartIndex = 0
        updateButtons()
    }
    
    @IBAction func thoraxButtonTouched(_ sender: Any) {
        self.activePartIndex = 1
        updateButtons()
    }
    
    @IBAction func abdomenButtonTouched(_ sender: Any) {
        self.activePartIndex = 2
        updateButtons()
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
