//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/15.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitide: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitide
    }
    
}
