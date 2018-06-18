//
//  Util.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-06-15.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation

func snakecaseToCapitalized(_ str: String) -> String {
    let lowercased = str.components(separatedBy: "_")
        .map { return $0.lowercased() }
        .joined(separator: " ")
    return lowercased.prefix(1).capitalized + lowercased.dropFirst()
}
