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
            "bombus_affinis",
            "bombus_auricomus",
            "bombus_bimaculatus",
            "bombus_borealis",
            "bombus_citrinus",
            "bombus_fervidus",
            "bombus_flavifrons",
            "bombus_griseocollis",
            "bombus_impatiens",
            "bombus_nevadensis",
            "bombus_pensylvanicus",
            "bombus_perplexus",
            "bombus_rufocinctus",
            "bombus_sandersoni",
            "bombus_sylvicola",
            "bombus_ternarius",
            "bombus_terricola",
            "bombus_vagans"
        ]
        
        let westernImageNames = [
            "bombus_bifarius",
            "bombus_borealis",
            "bombus_centralis",
            "bombus_cryptarum",
            "bombus_flavifrons",
            "bombus_griseocollis",
            "bombus_huntii",
            "bombus_impatiens",
            "bombus_melanopygus",
            "bombus_mixtus",
            "bombus_nevadensis",
            "bombus_occidentalis",
            "bombus_perplexus",
            "bombus_rufocinctus",
            "bombus_ternarius",
            "bombus_terricola",
            "bombus_vosnesenski"
        ]

        easternItems = easternImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        westernItems = westernImageNames.map{ NosePickerItem( image: UIImage(named: $0)!, identifier: $0 ) }
        
        pickers.append(easternItems!)
        pickers.append(westernItems!)
    }
    
    func renderImageGradient() {
        if (previewImage.layer.sublayers != nil) {
            return
        }
        let gradientView = UIView(frame: previewImage.frame)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y:0.7)
        let blackColor = UIColor.black
        gradient.colors = [blackColor.withAlphaComponent(0.4).cgColor, blackColor.withAlphaComponent(0.2), blackColor.withAlphaComponent(0.0).cgColor]
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
        previewImage.addSubview(gradientView)
        previewImage.bringSubview(toFront: gradientView)
    }
    
    private func setSightingSpecies(id: String) {
        sighting?.setSpecies(species: id)
        speciesLabel.layer.opacity = 1
        speciesLabel.text = nil
        
        //add icon
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "info-icon")
        attachment.bounds = CGRect(x: 8, y: -3, width: 18 , height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)
        let speciesString = NSMutableAttributedString(string: SpeciesMap.getCommonName(sighting!.getSpecies()))
        speciesString.append(attachmentString)
        speciesLabel.attributedText = speciesString
    }
    
    override func viewDidLayoutSubviews() {
        renderImageGradient()
        if (partsPicker == nil) {
            partsPicker = NosePicker(frame: CGRect(x: 0, y: previewImage.frame.maxY, width: view.frame.width, height: 96), items: easternItems!, updateCallback: self.setSightingSpecies)
            
            view.addSubview(partsPicker!)
            updateButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickers()
        
        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        
        //add buttons and set initial state to face
        self.partsButtons.append(easternButton)
        self.partsButtons.append(westernButton)
        
        let alert = CustomModal(title: "Which bee?", caption: "Select the species below that best matches your photo!", dismissText: "Got it", image: UIImage(named: "picker-illustration")!)
        
        speciesLabel.layer.opacity = 0.75
        
        alert.show(animated: true)
        
        speciesLabel.isUserInteractionEnabled = true
        speciesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSpeciesModal)))
    }
    
    func showSpeciesModal() {
        if (sighting?.getSpecies() == "unidentified") {
            return
        }
        
        let alert = CustomModal(species: sighting!.getSpecies())
        
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
        //set nav controller to light mode
        let navController = self.navigationController as! SubmissionNavigationController
        navController.navigationBar.barTintColor = UIColor.white
        navController.navigationBar.tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 14)!, NSForegroundColorAttributeName : UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0) ]
        
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
    
    @IBOutlet var speciesLabel: UILabel!
    
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
