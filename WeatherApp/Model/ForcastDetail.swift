//
//  ForcastDetail.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/21.
//

import Foundation

private let dateFormatter: DateFormatter = {
    print("📅📅📅 in ForcastDetail")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, h:mm a"
    return dateFormatter
}()

//儲存解碼後的數據,並使用在畫面上(FiveDaysTableViewCell)
struct DaysForcast: Codable {
    var daysIcon: String
    var daysSummary: String
    var daysHigh: Double
    var daysLow: Double
    var daysdaily: String
    var daysHumidity: Int
}

class ForcastDetail: WeatherLocation {
    
    struct ForcastResult: Codable {
        var city: City
        var list: [List]
        
        struct List: Codable {
            var dt: TimeInterval
            var main: MainForcast
            var weather: [WeatherForcast]
            var clouds: Clouds
            var dtTxt: String
            
            enum CodingKeys: String, CodingKey {
                case dt
                case main
                case weather
                case clouds
                case dtTxt = "dt_txt"
            }
            struct MainForcast: Codable {
                var temp: Double
                var feelsLike: Double
                var tempMin: Double
                var tempMax: Double
                var humidity: Int
                
                enum CodingKeys: String, CodingKey {
                    case temp
                    case feelsLike = "feels_like"
                    case tempMin = "temp_min"
                    case tempMax = "temp_max"
                    case humidity
                }
            }
            struct WeatherForcast: Codable {
                var main: String
                var description: String
                var icon: String
            }
            struct Clouds: Codable {
                var all: Int
            }
        }
    }

    struct City: Codable {
        var name: String
        var country: String
        var timezone: Int
    }
    
    var dailydays = 0.0
    var tempaHight = 0.0
    var tempLow = 0.0
    var daysSummary = ""
    var daysIcon = ""
    var daysForcastData: [DaysForcast] = []
    
    
    func getForcastData(completed: @escaping () -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&lang=zh_TW&appid=\(APIkeys.openWeatherKey)"
        print("🕸️🕸️使用五天預報的網址")
        guard let url = URL(string: urlStr) else { print("😡 ERROR五天預報網址錯誤 \(urlStr)"); return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌\(error)")
            } else if let data = data {
                do {
                    let deccrder = JSONDecoder()
                    let forcastResponse = try deccrder.decode(ForcastResult.self, from: data)
//                    self.daysIcon = forcastResponse.list[0].weather[0].icon
//                    self.summary = forcastResponse.list[0].weather[0].description
//                    self.dailydays = forcastResponse.list[0].dt
//                    self.tempaHight = Int(forcastResponse.list[0].main.tempMax.rounded())
//                    self.tempLow = Int(forcastResponse.list[0].main.tempMin.rounded())

                    for index in 0..<forcastResponse.list.count {
                        let daysIcon = self.fileNameForIcon(icon: forcastResponse.list[index].weather[0].icon)
                        let daysSummary = forcastResponse.list[index].weather[0].description
                        let tempaHight = forcastResponse.list[index].main.tempMax
                        let tempLow = forcastResponse.list[index].main.tempMin
                        let humidity = forcastResponse.list[index].main.humidity
                        let daysDate = Date(timeIntervalSince1970: forcastResponse.list[index].dt)
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: forcastResponse.city.timezone)
                        let daysdaily = dateFormatter.string(from: daysDate)
                        
                        let daysForcast = DaysForcast(daysIcon: daysIcon, daysSummary: daysSummary, daysHigh: tempaHight, daysLow: tempLow, daysdaily: daysdaily, daysHumidity: humidity)
                        self.daysForcastData.append(daysForcast)
                        //print("✅五天預報\(daysdaily), high\(tempaHight), low\(tempLow)")
                    }
                    
                } catch  {
                    print("❌\(error)")
                }
                completed()
            }
        }.resume()
    }
    //修改
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


