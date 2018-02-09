//
//  Sighting.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-01-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class Sighting {
    private var image: UIImage?
    private var habitat: String?
    private var location: GMSPlace?

    func getImage() -> UIImage {
        return image!
    }

    func setImage(image: UIImage) {
        self.image = image
    }

    func getHabitat() -> String {
        return habitat!
    }

    func setHabitat(habitat: String) {
        self.habitat = habitat
    }
    
    func setLocation(location: GMSPlace) {
        self.location = location
    }
}
