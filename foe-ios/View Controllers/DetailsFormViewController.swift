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

class DetailsFormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: outlets
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var binomialNameLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var habitatPickerTextField: UITextField!
    @IBOutlet weak var weatherPickerView: UIView!
    @IBOutlet weak var locationPickerView: UIView!

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

        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.plain, target: self, action: "submit")
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

        locationTextField.isUserInteractionEnabled = false
        locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAutoComplete)))

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    func openAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
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
        postToServer()
    }

    private func goToHome() {
        self.dismiss(animated:true)
    }

    private func setupHabitatPicker() {
        habitatPickerData =  ["back_yard", "balcony/container_garden", "community_garden", "city_park", "rural", "golf_course", "roadside", "woodland", "farmland", "school_grounds", "other"]
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

    private func postToServer() {
        let headers: HTTPHeaders = [
            "access-token": KeychainWrapper.standard.string(forKey: "accessToken")!,
            "token-type": "Bearer",
            "client": KeychainWrapper.standard.string(forKey: "client")!,
            "uid": KeychainWrapper.standard.string(forKey: "uid")!
        ]
        let parameters: Parameters = [
            "sighting": sighting!.toDict()
        ]
        
        Alamofire.request(
            "\(API_URL)/sightings",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            if
                let accessToken = response.response?.allHeaderFields["access-token"] as! String?,
                let client = response.response?.allHeaderFields["client"] as! String?,
                let uid = response.response?.allHeaderFields["uid"] as! String?
            {
                print("accessToken: \(accessToken)")
                KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
                KeychainWrapper.standard.set(client, forKey: "client")
                KeychainWrapper.standard.set(uid, forKey: "uid")
            }

            switch response.result {
            case .success:
                print("Successfully posted sighting")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                let alert = CustomModal(
                    title: "Buzz buzz!",
                    caption: "That's thank you in bee!",
                    dismissText: "Finish",
                    image: UIImage(named: "default-home-illustration")!,
                    onDismiss: self.goToHome
                )
                alert.show(animated: true)
            case .failure(let error):
                // TODO(dinah): discuss submission errors with john
                print("Validation failure on POST /sightings")
                print(error)
            }
        }
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
