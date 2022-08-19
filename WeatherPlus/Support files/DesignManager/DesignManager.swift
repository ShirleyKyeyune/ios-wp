//
//  DesignManager.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

struct DesignManager {

    // Cell styles
    enum GradientColors {
        case night, day, fog, blank
    }

    // Making proper round corners
    static func setBackgroundStandardShape(layer: CALayer) {
        layer.cornerCurve = CALayerCornerCurve.continuous
        layer.cornerRadius = 20
    }

    // Making shadow
    static func setBackgroundStandardShadow(layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 7
    }

    // Gradient
    static func getStandardGradientColor(withStyle style: GradientColors) -> [CGColor] {
        switch style {
        case .day: return WPConstants.Colors.Gradient.day
        case .fog: return WPConstants.Colors.Gradient.fog
        case .night: return WPConstants.Colors.Gradient.night
        case .blank: return WPConstants.Colors.Gradient.blank
        }
    }
}

