//
//  Util.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-06-15.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation

func snakecaseToCapitalized(_ str: String) -> String {
    return str.components(separatedBy: "_")
        .map { return $0.lowercased().capitalized }
        .joined(separator: " ")
}
