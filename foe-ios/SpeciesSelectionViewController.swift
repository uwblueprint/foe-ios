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
    var easternItems: [NosePickerItem]?
    var westernItems: [NosePickerItem]?
    
    var partsPicker : NosePicker?
    var activePartIndex : Int = 0
    var partsButtons = [UIButton]()
    var pickers = [[NosePickerItem]]()
    
    func initializePickers() {
        let easternImageNames = [
            "affinis",
            "auricomus",
            "bimaculatus",
            "borealis",
            "citrinus",
            "fervidus",
            "flavifrons",
            "griseocollis",
            "impatiens",
            "nevadensis",
            "pensylvanicus",
            "perplexus",
            "rufocinctus",
            "sandersoni",
            "sylvicola",
            "ternarius",
            "terricola",
            "vagans"
        ]
        
        let westernImageNames = [
            "bifarius",
            "borealis",
            "centralis",
            "cryptarum",
            "flavifrons",
            "griseocollis",
            "huntii",
            "impatiens",
            "melanopygus",
            "mixtus",
            "nevadensis",
            "occidentalis",
            "perplexus",
            "rufocinctus",
            "ternarius",
            "terricola",
            "vosnesenski"
        ]

        easternItems = easternImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        westernItems = westernImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        
        pickers.append(easternItems!)
        pickers.append(westernItems!)
    }

    private func setSightingSpecies(id: String) {
        sighting?.setSpecies(species: id)
    }
    
    override func viewDidLayoutSubviews() {
        partsPicker = NosePicker(frame: CGRect(x: 0, y: partsLabelsRow.frame.maxY , width: view.frame.width, height: 96), items: easternItems!, updateCallback: self.setSightingSpecies)
        
        view.addSubview(partsPicker!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickers()
        
        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        //add buttons and set initial state to face
        self.partsButtons.append(easternButton)
        self.partsButtons.append(westernButton)
        
        updateButtons()
        
        let alert = CustomModal(title: "Which bee?", caption: "Select the species below that best matches your photo!", dismissText: "Got it", image: UIImage(named: "picker-illustration")!)
        
        alert.show(animated: true)
    }
    
    func updateButtons() {
        for i in 0..<self.partsButtons.count {
            if i == self.activePartIndex {
                self.partsButtons[i].setTitleColor(UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0), for: UIControlState.normal)
            } else {
                self.partsButtons[i].setTitleColor(UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0), for: UIControlState.normal)
            }
        }
        
        partsPicker?.loadNewButtons(newItems: pickers[self.activePartIndex])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Step 2: Identify".uppercased()
        //set nav controller to light mode
        
        let navController = self.navigationController as! SubmissionNavigationController
        navController.navigationBar.barTintColor = UIColor.white
        navController.navigationBar.tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!, NSForegroundColorAttributeName : UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0) ]
        
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
    @IBOutlet weak var partsLabelsRow: UIStackView!
    @IBOutlet weak var easternButton: UIButton!
    @IBOutlet weak var westernButton: UIButton!
    
    @IBAction func easternButtonClicked(_ sender: Any) {
        self.activePartIndex = 0
        updateButtons()
    }
    
    @IBAction func westernButtonClicked(_ sender: Any) {
        self.activePartIndex = 1
        updateButtons()
    }
    
    // MARK: - Actions
    
    func goToNextScreen() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsFormViewController") as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
