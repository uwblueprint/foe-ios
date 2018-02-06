//
//  DetailsFormViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-02-01.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class DetailsFormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: outlets
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var habitatPickerTextField: UITextField!
    
    var sighting: Sighting?
    var habitatPicker = UIPickerView()
    var habitatPickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navController = self.navigationController as! SubmissionNavigationController
        sighting = navController.getSighting()
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.plain, target: self, action: "submit")
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.title = "Step 3: Geotag"

        previewImage.image = sighting?.getImage()
        
        setupHabitatPicker()
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
    
    private func setupHabitatPicker() {
        habitatPickerData =  ["house_garden", "park", "swap", "public_garden", "lake", "lawn"]
        habitatPicker.delegate = self
        habitatPicker.dataSource = self
        habitatPickerTextField.inputView = habitatPicker
    }
    
    private func snakecaseToCapitalized(str: String) -> String {
        return str.components(separatedBy: "_")
            .map { return $0.lowercased().capitalized }
            .joined(separator: " ")
    }
}
