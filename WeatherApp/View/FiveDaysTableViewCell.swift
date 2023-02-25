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
    
    func tempFormate(ºC f: Double) -> String {
// ºC = (ºF - 32 ) x 5 / 9
        let c = (f - 32) * 5 / 9
        let tempString = String(format: "%.0f", c)
        return tempString
    }
    
}
