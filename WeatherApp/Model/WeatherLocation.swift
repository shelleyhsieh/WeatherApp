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
    
    // 建立啟動方法
    init(name: String, latitude: Double, longitude: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
