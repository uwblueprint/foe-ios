//
//  NosePickerItem.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-29.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

class NosePickerItem {
    private var image: UIImage
    private var identifier: String
    
    init(image: UIImage, identifier: String) {
        self.image = image
        self.identifier = identifier
    }
    
    func getImage() -> UIImage {
        return self.image
    }
    
    func getIdentifier() -> String {
        return self.identifier
    }
    
}
