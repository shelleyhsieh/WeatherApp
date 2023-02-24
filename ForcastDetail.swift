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
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

//儲存解碼後的數據,並使用在畫面上
struct DaysForcast: Codable {
    var daysIcon: String
    var daysSummary: String
    var daysHigh: Int
    var daysLow: Int
    var daysdaily: String
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
    var tempaHight = 0
    var tempLow = 0
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
                        let daysIcon = forcastResponse.list[index].weather[0].icon
                        let daysSummary = forcastResponse.list[index].weather[0].description
                        let tempaHight = Int(forcastResponse.list[index].main.tempMax.rounded())
                        let tempLow = Int(forcastResponse.list[index].main.tempMin.rounded())
                        let daysDate = Date(timeIntervalSince1970: forcastResponse.list[index].dt)
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: forcastResponse.city.timezone)
                        let daysdaily = dateFormatter.string(from: daysDate)
                        let daysForcast = DaysForcast(daysIcon: daysIcon, daysSummary: daysSummary, daysHigh: tempaHight, daysLow: tempLow, daysdaily: daysdaily)
                        self.daysForcastData.append(daysForcast)
                        print("✅五天預報\(daysdaily), high\(tempaHight), low\(tempLow)")
                    }
                    
                } catch  {
                    print("❌\(error)")
                }
                completed()
            }
        }.resume()
    }
}


