//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var snakeCase = "house_garden"

snakeCase.components(separatedBy: "_")
    .map { return $0.lowercased().capitalized }
    .joined(separator: " ")
