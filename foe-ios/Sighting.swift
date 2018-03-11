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
  private var weather: String?
  private var location: GMSPlace?
  private var species: String = "unidentified"
  
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
      return habitat!
  }

  func setHabitat(habitat: String) {
      self.habitat = habitat
  }
    
  func setWeather(weather: String) {
      self.weather = weather
    print("weather set to " + weather)
  }

  func setLocation(location: GMSPlace) {
      self.location = location
  }
}
