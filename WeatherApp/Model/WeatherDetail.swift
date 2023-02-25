//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/17.
//

import Foundation

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var weather: [Weather] //天氣Array
        var main: Main //主要資料
        var clouds: Clouds //雲量
        var dt: TimeInterval //現在時間
        var timezone: Int //時區
        var name: String //程式名稱
    }
    struct Weather: Codable {
        var main: String
        var description: String
        var icon: String //圖片代號
    }
    struct Main: Codable {
        var temp: Double
        var feelLike: Double
        var tempMin: Double
        var tempMax: Double
        var humidity: Int
        
        //利用CodingKey客製JSON對應的property
        enum CodingKeys: String, CodingKey {
            case temp
            case feelLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
    struct Clouds: Codable {
        var all: Int
    }
    
    // 將需要的數值先建立一個儲存位置
    var timezone = 0
    var currentTime = 0.0
    var tempature = 0.0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping () -> ()){
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&lang=zh_TW&appid=\(APIkeys.openWeatherKey)"
        print("🕸️ 使用近期天氣網址")
        guard let url = URL(string: urlStr) else {
            print("😡 ERROR天氣網址錯誤 \(urlStr)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Result.self, from: data)
                    self.timezone = result.timezone
                    self.currentTime = result.dt
                    self.tempature = result.main.temp //四捨五入取整數.round()
                    self.summary = result.weather[0].description //array中的第一個
                    self.dailyIcon = self.fileNameForIcon(icon: result.weather[0].icon)
                    
                    print("✅\(result)")
                } catch {
                    print("😡😡ERROR: \(error)")
                }
                completed()
            } 
        }.resume()
        
    }
    
    func fileNameForIcon(icon: String) -> String{
        var newFileName = ""
        switch icon {
        case "01d", "01n":
            newFileName = "sun"
        case "02d","02n" :
            newFileName = "cloudSun"
        case "03d","03n" :
            newFileName = "cloud"
        case "04d","04n" :
            newFileName = "brokenClouds"
        case "09d","09n" :
            newFileName = "showerRain"
        case "10d","10n" :
            newFileName = "rain"
        case "11d","11n" :
            newFileName = "storm"
        case "13d","13n" :
            newFileName = "snow"
        case "50d","50n" :
            newFileName = "rain"
        default:
            newFileName = ""
        }
        return newFileName
    }
}
