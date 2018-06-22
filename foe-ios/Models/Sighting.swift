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
  private var locationName: String?
  private var species: String = "unidentified"
  private var date: Date = Date.init()

    init() { }

    init(json: [String: Any], imageRenderedCallback: @escaping () -> Void) {
        guard
            let habitat = json["habitat"] as? String,
            let weather = json["weather"] as? String,
            let species = json["species"] as? String,
            let locationName = json["street_address"] as? String
        else { return }
        
        self.habitat = habitat
        self.weather = weather
        self.species = species
        self.date = stringToDate(json["date"] as! String)
        self.locationName = locationName
        
        downloadImage(link: json["image_url"] as! String, callback: imageRenderedCallback)
    }
    
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
    return self.habitat!
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
    if (self.locationName == nil) {
        self.locationName = (self.location == nil) ? "" : self.location!.name
    }

    return self.locationName!
  }

  func getDate() -> Date {
     return self.date
  }

    func toDict() -> Dictionary<String, Any> {
        let dict: [String: Any] = [
            "weather": weather!,
            "habitat": habitat!,
            "species": species,
            "date": formatDate(date: Date()),
            "latitude": location!.coordinate.latitude,
            "longitude": location!.coordinate.longitude,
            "street_address": location!.name,
            "image": [
                "file": getBase64EncodedImage()
            ]
        ]
        return dict
    }
    
    private func getBase64EncodedImage() -> String {
        if let updatedImage = self.image?.updateImageOrientionUpSide() {
            return "data:image/png;base64,\(UIImagePNGRepresentation(updatedImage)!.base64EncodedString())"
        } else {
            return "data:image/png;base64,\(UIImagePNGRepresentation(image!)!.base64EncodedString())"
        }
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: date)
    }
    
    private func stringToDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.date(from: str)!
    }
    
    func downloadImage(link: String, callback: @escaping () -> Void) {
        guard let url = URL(string: link) else { return }
        downloadImage(url: url, callback: callback)
    }
    
    func downloadImage(url: URL, callback: @escaping () -> Void) {
        // TODO(dinah): replace with default sample image
        self.image = UIImage(named: "bee-sample-image-1")
        
        // Adapted from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                callback()
            }
        }.resume()
    }
}
