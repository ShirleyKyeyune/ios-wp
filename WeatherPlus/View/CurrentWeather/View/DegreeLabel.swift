//
//  DegreeLabel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

class DegreeLabel: UILabel {
    override var text: String? {
        didSet {
            validateText()
        }
    }
    
    func validateText() {
        if let labelText = text, labelText.first != "-" && labelText.first != " " {
            text = " " + labelText
        }
    }
}
