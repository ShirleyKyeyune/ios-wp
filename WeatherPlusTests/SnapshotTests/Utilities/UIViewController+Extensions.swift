//
//  UIViewController+Extensions.swift
//  WeatherPlusTests
//
//  Created by Shirley Kyeyune on 23/08/2022.
//

import UIKit

extension UIViewController {
    func loadViewProgrammatically() {
        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()
    }
}
