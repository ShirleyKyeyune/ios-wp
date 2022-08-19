//
//  UIView+Extensions.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation
import UIKit

extension UIView {
    func isVisible() -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: self, inView: self.superview)
    }
}
