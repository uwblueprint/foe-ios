//
//  DetailsFormViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-02-01.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import SwiftKeychainWrapper

class DetailsFormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: outlets
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var binomialNameLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var habitatPickerTextField: UITextField!
    @IBOutlet weak var weatherPickerView: UIView!
    @IBOutlet weak var locationPickerView: UIView!
    @IBOutlet weak var habitatPickerArrow: UIImageView!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var speciesView: UIView!
    @IBOutlet weak var speciesViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var speciesViewTopDefaultConstraint: NSLayoutConstraint!
    
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
        
//        sighting = Sighting()
//        sighting!.setImage(image: UIImage(named:"bee-sample-image-0")!)
//        sighting!.setSpecies(species: "bombus_cryptarum")
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.plain, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.title = "Step 3: Geotag"

        previewImage.image = sighting?.getImage()

        if (sighting?.getSpecies() == "unidentified") {
            commonNameLabel.text = "Unidentified"
            binomialNameLabel.text = "N/A"
        } else {
            commonNameLabel.text = SpeciesMap.getCommonName(sighting!.getSpecies())
            binomialNameLabel.text = SpeciesMap.getDisplayBinomialName(sighting!.getSpecies())
        }

        setupHabitatPicker()
        setupWeatherPicker()

        locationTextField.isUserInteractionEnabled = false
        locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAutoComplete)))

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    func openAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        UINavigationBar.appearance().tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func locationPickerClicked(_ sender: Any) {
        openAutoComplete()
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
        return snakecaseToCapitalized(habitatPickerData[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        habitatPickerTextField.text = snakecaseToCapitalized(habitatPickerData[row])
        sighting?.setHabitat(habitat: habitatPickerData[row])
    }

    func setSightingWeather(weather: String) {
        sighting?.setWeather(weather: weather)
    }

    func submit() {
        if (locationTextField.text == "" || sighting?.getHabitat() == "" || sighting?.getWeather() == "") {
            createErrorView()
            return
        }
        else {
            removeErrorView()
            postToServer()
        }
        
    }

    private func goToHome() {
        self.dismiss(animated:true)
    }

    private func setupHabitatPicker() {
        habitatPickerData =  ["back_yard", "balcony/container_garden", "community_garden", "city_park", "rural", "golf_course", "roadside", "woodland", "farmland", "school_grounds", "other"]
        habitatPicker.backgroundColor = UIColor.white
        habitatPicker.delegate = self
        habitatPicker.dataSource = self
        habitatPickerTextField.inputView = habitatPicker
        habitatPickerTextField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doneButtonPressed))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Heavy", size: 16)!], for: UIControlState.normal)
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Book", size: 16)!], for: UIControlState.normal)
        toolBar.isUserInteractionEnabled = true
        habitatPickerTextField.inputAccessoryView = toolBar
        
        habitatPickerArrow.isUserInteractionEnabled = true
        habitatPickerArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openHabitatPicker)))
    }
    
    func openHabitatPicker() {
        habitatPickerTextField.becomeFirstResponder()
    }
    
    func doneButtonPressed() {
        habitatPickerTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        habitatPickerArrow.transform = CGAffineTransform(scaleX: 1, y: -1)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        habitatPickerArrow.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func createErrorView() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.view.removeConstraint(self.speciesViewTopDefaultConstraint)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func removeErrorView() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.speciesViewTopDefaultConstraint.priority = 1000
            self.view.addConstraint(self.speciesViewTopDefaultConstraint)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    private func setupWeatherPicker() {
        let weatherImageNames = [
            "sunny",
            "partly_cloudy",
            "cloudy",
            "rain"
        ]

        var weatherItems = weatherImageNames.map { NosePickerItem(image: UIImage(named: $0)!, identifier: $0) }
        weatherPicker = NosePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 96), items: weatherItems, updateCallback: self.setSightingWeather)

        weatherPickerView.addSubview(weatherPicker!)
    }
    
    func displaySpinner() -> UIView {
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.66)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }

    private func postToServer() {
        let sv = displaySpinner()
        let parameters: Parameters = [
            "sighting": sighting!.toDict()
        ]
        
        ServerGateway.authenticatedRequest(
            url: "/sightings",
            method: .post,
            parameters: parameters,
            success: { _ in
                let alert = CustomModal(
                    title: "Buzz buzz!",
                    caption: "That's thank you in bee!",
                    dismissText: "Finish",
                    image: UIImage(named: "default-home-illustration")!,
                    onDismiss: self.goToHome
                )
                self.removeSpinner(spinner: sv)
                alert.show(animated: true)
            },
            failure: { _ in
                self.removeSpinner(spinner: sv)
        }
        )
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
