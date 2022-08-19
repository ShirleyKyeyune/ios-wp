//
//  AppComponents.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation

protocol ColorThemeProtocol {
    var colorTheme: ColorThemeModel { get set }
}

class AppComponents: ColorThemeProtocol {
    var colorTheme: ColorThemeModel
    
    init(_ colorTheme: ColorThemeModel) {
        self.colorTheme = colorTheme
    }
}
