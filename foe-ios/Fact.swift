//
//  Fact.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-15.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class Fact {
    
    //MARK: Properties
    var title : String
    var copy : String
    var image : UIImage?
    
    init?(title: String, image: UIImage?, copy: String) {
        
        // The name must not be empty
        guard !title.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard !copy.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.title = title
        self.image = image
        self.copy = copy
        
    }
}
