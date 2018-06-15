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
  private var habitat: String = ""
  private var weather: String?
  private var location: GMSPlace?
  private var species: String = "unidentified"
  private var date: Date = Date.init()

  func setSpecies(species: String) {
    self.species = species
  }

  func getSpecies() -> String {
    return species
  }

  func setImage(image: UIImage) {
    self.image = image
  }

  func getImage() -> UIImage {
    return image!
  }

  func getHabitat() -> String {
    return habitat
  }

  func setHabitat(habitat: String) {
    self.habitat = habitat
  }

  func setWeather(weather: String) {
    self.weather = weather
  }

  func getWeather() -> String {
    return self.weather!
  }

  func setLocation(location: GMSPlace) {
    self.location = location
  }

  func getLocationName() -> String {
    return (self.location != nil) ? self.location!.name : ""
  }

  func getDate() -> Date {
     return self.date
  }

    func toDict() -> Dictionary<String, Any> {
        let dict: [String: Any] = [
            "weather": weather!,
            "habitat": habitat!,
            "species": species == "unidentified" ? species : "bombus_\(species)",
            "date": formatDate(date: Date()),
            "latitude": location!.coordinate.latitude,
            "longitude": location!.coordinate.longitude,
            "image": [
                "file": "data:image/png;base64,\(UIImagePNGRepresentation(image!)!.base64EncodedString())"
            ]
        ]
        return dict
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: date)
    }
}
