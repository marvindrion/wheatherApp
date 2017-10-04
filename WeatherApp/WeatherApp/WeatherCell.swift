//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Marvin DRION on 29/09/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var descWeatherLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
}
