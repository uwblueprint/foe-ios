//
//  DetailsFormViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-02-01.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import GooglePlaces

class DetailsFormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: outlets
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var binomialNameLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var habitatPickerTextField: UITextField!
    @IBOutlet weak var weatherPickerView: UIView!
    
    var sighting: Sighting?
    var weatherPicker: NosePicker?
    var habitatPicker = UIPickerView()
    var habitatPickerData: [String] = [String]()
    
    var speciesCommonNameMapping = [
        "bombus_impatiens": "Common eastern bumble bee",
        "bombus_tenarius": "Tri-coloured bumble bee",
        "bombus_rufocinctus": "Red-belted bumble bee",
        "bombus_bimaculatus": "Two-spotted bumble bee",
        "bombus_borealis": "Northern amber bumble bee",
        "bombus_vagans": "Half-black bumble bee",
        "bombus_affinis": "Rusty-patched bumble bee",
        "bombus_griseocollis": "Brown-belted bumble bee",
        "bombus_citrinus": "Lemon cuckoo bumble bee",
        "bombus_perplexus": "Confusing bumble bee",
        "bombus_pensylvanicus": "American bumble bee",
        "bombus_sylvicola": "Forest bumble bee",
        "bombus_sandersoni": "Sanderson bumble bee",
        "bombus_nevadensis": "Nevada bumble bee",
        "bombus_auricomus": "Black and gold bumble bee",
        "bombus_terricola": "Yellow-banded bumble bee",
        "bombus_fervidus": "Yellow bumble bee",
        "bombus_flavifrons": "Yellow head bumble bee",
        "bombus_occidentalis": "Common western bumble bee",
        "bombus_melanopygus": "Black tail bumble bee",
        "bombus_bifarius": "Two-form bumble bee",
        "bombus_huntii": "Hunt bumble bee",
        "bombus_vosnesenski": "Vosnesensky bumble bee",
        "bombus_cryptarum": "Cryptic bumble bee",
        "bombus_mixtus": "Fuzzy-horned bumble bee",
        "bombus_centralis": "Central bumble bee",
        "bombus_bohemicus": "Gypsy cuckoo bumble bee",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailsFormViewController.submit))
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.title = "Step 3: Geotag"

        previewImage.image = sighting?.getImage()
        
        if (sighting?.getSpecies() == "unidentified") {
            commonNameLabel.text = "Unidentified"
            binomialNameLabel.text = "N/A"
        } else {
            commonNameLabel.text = speciesCommonNameMapping["bombus_" + (sighting?.getSpecies())!]
            binomialNameLabel.text = "Bombus " + (sighting?.getSpecies())!
        }
        
        setupHabitatPicker()
        setupWeatherPicker()
    }

    @IBAction func locationPickerClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return habitatPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return snakecaseToCapitalized(str: habitatPickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        habitatPickerTextField.text = snakecaseToCapitalized(str: habitatPickerData[row])
        sighting?.setHabitat(habitat: habitatPickerData[row])
    }
    
    func setSightingWeather(weather: String) {
        sighting?.setWeather(weather: weather)
    }
    
    func submit() {
        // TODO: post to server
        let alert = CustomModal(title: "Buzz buzz!", caption: "That's thank you in bee!", dismissText: "Finish", image: UIImage(named: "default-home-illustration")!, onDismiss: goToHome)
        alert.show(animated: true)
    }
    
    func goToHome() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "homeViewController")
        self.present(vc, animated: false)
    }
    
    private func setupHabitatPicker() {
        habitatPickerData =  ["house_garden", "park", "swap", "public_garden", "lake", "lawn"]
        habitatPicker.delegate = self
        habitatPicker.dataSource = self
        habitatPickerTextField.inputView = habitatPicker
    }
    
    private func setupWeatherPicker() {
        let weatherImageNames = [
            "sunny",
            "partly-sunny",
            "overcast",
            "rainy"
        ]
        
        var weatherItems = weatherImageNames.map { NosePickerItem(image: UIImage(named: $0)!, identifier: $0) }
        weatherPicker = NosePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 96), items: weatherItems, updateCallback: self.setSightingWeather)
        
        weatherPickerView.addSubview(weatherPicker!)
    }

    private func snakecaseToCapitalized(str: String) -> String {
        return str.components(separatedBy: "_")
            .map { return $0.lowercased().capitalized }
            .joined(separator: " ")
    }
}

extension DetailsFormViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationTextField.text = place.name
        sighting?.setLocation(location: place)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
