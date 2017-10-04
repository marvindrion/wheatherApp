//
//  ButtonChoiceCell.swift
//  WeatherApp
//
//  Created by Marvin DRION on 04/10/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//


import UIKit

class ButtonChoiceCell: UICollectionViewCell {

    @IBOutlet weak var choiceLabel: UILabel!
    var id: String = ""

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choiceLabel.text = "Undefined"
        choiceLabel.textColor = UIColor(hexString: "0404B4")
        choiceLabel.layer.borderWidth = 1.5
        choiceLabel.layer.borderColor = UIColor(hexString: "0404B4").cgColor
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}
