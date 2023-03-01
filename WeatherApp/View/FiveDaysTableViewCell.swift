//
//  FiveDaysTableViewCell.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/21.
//

import UIKit

class FiveDaysTableViewCell: UITableViewCell {

    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var daysLable: UILabel!
    @IBOutlet weak var daysSummaryTextVIew: UITextView!
    @IBOutlet weak var daysHightTempLable: UILabel!
    @IBOutlet weak var daysLowTempLable: UILabel!
    @IBOutlet weak var daysHumidityLable: UILabel!
    
    // 建立屬性觀察性，當有新的值被設定後立即呼叫，並將舊的屬性值作為參數傳入
    var daysForcast: DaysForcast! {
        didSet {
            dayImageView.image = UIImage(named: daysForcast.daysIcon)
            daysLable.text = daysForcast.daysdaily
            daysSummaryTextVIew.text = daysForcast.daysSummary
            daysHightTempLable.text = "\(tempFormate(ºC: daysForcast.daysHigh) )º"
            daysLowTempLable.text = "\(tempFormate(ºC:daysForcast.daysLow) )º"
            daysHumidityLable.text = "💧 \(daysForcast.daysHumidity)%"
        }
    }
    
    // 轉換溫度格式
    func tempFormate(ºC f: Double) -> String {
// ºC = (ºF - 32 ) x 5 / 9
        let c = (f - 32) * 5 / 9
        let tempString = String(format: "%.0f", c) //取小數點後第0位，意即取整數
        return tempString
    }
    
}
