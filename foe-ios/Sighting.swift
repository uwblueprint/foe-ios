//
//  Sighting.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-01-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

class Sighting {
  private var image: UIImage?
  
  func setImage(image: UIImage) {
    self.image = image
  }
  
  func getImage() -> UIImage {
    return image!
  }
}
