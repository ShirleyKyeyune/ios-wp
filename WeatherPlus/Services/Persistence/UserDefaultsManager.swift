//
//  UserDefaultsManager.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation

struct UserDefaultsManager {
    struct UnitData {
        static func get() -> String {
            return UserDefaults.standard.string(forKey: WPConstants.UserDefaults.unit) ?? WPConstants.UserDefaults.metric
        }

        static func set(with unit: String) {
            if unit == WPConstants.UserDefaults.imperial || unit == WPConstants.UserDefaults.metric {
                UserDefaults.standard.setValue(unit, forKey: WPConstants.UserDefaults.unit)
            }
        }
    }
    
    struct AppIcon {
        static func get() -> Int {
            return UserDefaults.standard.integer(forKey: WPConstants.UserDefaults.appIconNumber)
        }

        static func set(with num: Int) {
            UserDefaults.standard.setValue(num, forKey: WPConstants.UserDefaults.appIconNumber)
        }
    }
    
    struct ColorTheme {
        static func getCurrentColorThemeNumber() -> Int {
            return UserDefaults.standard.integer(forKey: WPConstants.UserDefaults.colorThemePositionNumber)
        }

        static func setChosenPositionColorTheme(with position: Int) {
            UserDefaults.standard.setValue(position, forKey: WPConstants.UserDefaults.colorThemePositionNumber)
        }
        
        static func getColorTheme(_ num: Int) -> ColorThemeModel {
            let colorThemes = ColorThemeManager.getColorThemes()
            
            if colorThemes.count < num {
                return ColorThemeModel()
            }
            
            return colorThemes[num]
        }
        
        static func getCurrentColorTheme() -> ColorThemeModel {
            let currentColorThemeNumber = self.getCurrentColorThemeNumber()
            
            let colorThemes = ColorThemeManager.getColorThemes()
                
            if currentColorThemeNumber > colorThemes.count {
                return ColorThemeModel()
            }
            
            return colorThemes[currentColorThemeNumber]
        }
    }
}
