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
    
    var daysForcast: DaysForcast! {
        didSet {
            dayImageView.image = UIImage(named: daysForcast.daysIcon)
            daysLable.text = daysForcast.daysdaily
            daysSummaryTextVIew.text = daysForcast.daysSummary
            daysHightTempLable.text = "\(daysForcast.daysHigh)º"
            daysLowTempLable.text = "\(daysForcast.daysLow)º"
        }
    }
    
}
