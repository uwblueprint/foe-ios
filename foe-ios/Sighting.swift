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
  private var partIdentifiers : [String]

  init() {
    self.partIdentifiers = [String]()
    self.partIdentifiers.append("face_black") // 0: face
    self.partIdentifiers.append("thorax_yyy") // 1: thorax
    self.partIdentifiers.append("ab_byb") // 2: abdomen
  }

  func setPartIdentifier(index: Int, val: String) {
    if (index >= 0 && index < 3 ){
      partIdentifiers[index] = val
    }
  }

  func getPartIdentifier (index: Int) -> String? {
    if (index >= 0 && index < 3 ){
      return partIdentifiers[index]
    }
    else {
        return nil
    }
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

  func setLocation(location: GMSPlace) {
      self.location = location
  }
}
