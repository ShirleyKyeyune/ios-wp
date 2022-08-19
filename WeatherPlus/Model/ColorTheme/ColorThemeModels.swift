//
//  ColorThemeModels.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

struct ColorThemeColorsModel {
    let colors: [UIColor]
    let iconsColor: UIColor
    let labelsColor: UIColor
}

struct AddCityColorTheme {
    let backgroundColor: UIColor
    let searchFieldBackground: UIColor
    let cancelButtonColor: UIColor
    let placeholderColor: UIColor
    let handleColor: UIColor
    let isShadowVisible: Bool
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
}

struct IconColorsColorThemeModel {
    let mist: UIColor
    let snow: UIColor
    let rain: UIColor
    let showerRain: UIColor
    let thunderstorm: UIColor
    let cloud: UIColor
    let sun: UIColor
    let humidity: UIColor
    let uvIndex: UIColor
    let wind: UIColor
    let cloudiness: UIColor
    let pressure: UIColor
    let visibility: UIColor
}

struct MainMenuColorThemeModel {
    let isStatusBarDark: Bool
    let backgroundColor: UIColor
    let dateLabelColor: UIColor
    let todayColor: UIColor
    let settingsIconColor: UIColor
    let searchButtonColor: UIColor
    let cells: CellsColorThemeModel
}

struct CellsColorThemeModel {
    let isShadowVisible: Bool
    let gradient: GradientColorThemeModel
    let defaultBackground: UIColor
    let defaultLoadingViewsColor: UIColor
    let activityViewColor: UIColor
    let clearSky: ColorThemeColorsModel
    let fewClouds: ColorThemeColorsModel
    let scatteredClouds: ColorThemeColorsModel
    let brokenClouds: ColorThemeColorsModel
    let showerRain: ColorThemeColorsModel
    let rain: ColorThemeColorsModel
    let thunderstorm: ColorThemeColorsModel
    let snow: ColorThemeColorsModel
    let mist: ColorThemeColorsModel
}

struct BackgroundColorColorThemeModel {
    let backgroundColor: UIColor
    let isClearBackground: Bool
    let isShadowVisible: Bool
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
}

struct ContentBackgroundColorTheme {
    let color: UIColor
    let isClearBackground: Bool
}

struct ScreenBackgroundColorThemeModel {
    let colors: [UIColor]
    let gradient: GradientColorThemeModel
    let mainIconColor: UIColor
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
    let ignoreColorInheritance: Bool
}

struct CityDetailsColorThemeModel {
    let isNavBarDark: Bool
    let isStatusBarDark: Bool
    let hourlyForecast: BackgroundColorColorThemeModel
    let weeklyForecast: BackgroundColorColorThemeModel
    let temperatureItem: BackgroundColorColorThemeModel
    let contentBackground: ContentBackgroundColorTheme
    let screenBackground: ScreenBackgroundColorThemeModel
    let iconColors: IconColorsColorThemeModel
}

struct GradientColorThemeModel {
    let startPoint: CGPoint
    let endPoint: CGPoint
}

struct SettingsScreenColorTheme {
    let backgroundColor: UIColor
    let cellsBackgroundColor: UIColor
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
    let appIconSelectBorderColor: UIColor
    let appIconDeselectBorderColor: UIColor
    let temperatureSwitchColor: UIColor
    let colorBoxesColors: [UIColor]
}

// MARK: - Complete ColorThemeModel properties
    
struct ColorThemeModel {
    
    // MARK: - Private properties
    
    private let rawColorThemeDataModel: ColorThemeData
    
    // MARK: - Public properties
    
    var title: String {
        rawColorThemeDataModel.title
    }
    
    var addCityScreen: AddCityColorTheme {
        return AddCityColorTheme(backgroundColor: makeColor(hex: rawColorThemeDataModel.addCity.backgroundColor),
                                 searchFieldBackground: makeColor(hex: rawColorThemeDataModel.addCity.searchFieldBackground),
                                 cancelButtonColor: makeColor(hex: rawColorThemeDataModel.addCity.cancelButtonColor),
                                 placeholderColor: makeColor(hex: rawColorThemeDataModel.addCity.placeholderColor),
                                 handleColor: makeColor(hex: rawColorThemeDataModel.addCity.handleColor),
                                 isShadowVisible: rawColorThemeDataModel.addCity.isShadowVisible,
                                 labelsColor: makeColor(hex: rawColorThemeDataModel.addCity.labelsColor),
                                 labelsSecondaryColor: makeColor(hex: rawColorThemeDataModel.addCity.labelsSecondaryColor))
    }
    
    var settingsScreen: SettingsScreenColorTheme {
        let settingsScreen = rawColorThemeDataModel.settingsScreen
        let colorBoxesColors = makeColors(hexes: settingsScreen.colorBoxesColors)
        let settings = rawColorThemeDataModel.settingsScreen

        return SettingsScreenColorTheme(backgroundColor: makeColor(hex: settings.backgroundColor),
                                        cellsBackgroundColor: makeColor(hex: settings.cellsBackgroundColor),
                                        labelsColor: makeColor(hex: settings.labelsColor),
                                        labelsSecondaryColor: makeColor(hex: settings.labelsSecondaryColor),
                                        appIconSelectBorderColor: makeColor(hex: settings.appIconSelectBorderColor),
                                        appIconDeselectBorderColor: makeColor(hex: settings.appIconDeselectBorderColor),
                                        temperatureSwitchColor: makeColor(hex: settings.temperatureSwitchColor),
                                        colorBoxesColors: colorBoxesColors)
    }
    
    var moreOptions: MainMenuColorThemeModel {
        let mainMenu = rawColorThemeDataModel.mainMenu
        
        let cellsGradient = GradientColorThemeModel(startPoint: CGPoint(x: mainMenu.cells.gradient.startPoint.x, y: mainMenu.cells.gradient.startPoint.y),
                                                    endPoint: CGPoint(x: mainMenu.cells.gradient.endPoint.x, y: mainMenu.cells.gradient.endPoint.y))
        let cellsMenu = CellsColorThemeModel(isShadowVisible: mainMenu.cells.isShadowVisible,
                                             gradient: cellsGradient,
                                             defaultBackground: makeColor(hex: mainMenu.cells.defaultBackground),
                                             defaultLoadingViewsColor: makeColor(hex: mainMenu.cells.defaultLoadingViewsColor),
                                             activityViewColor: makeColor(hex: mainMenu.cells.activityViewColor),
                                             clearSky: convertToColorThemeModel(mainMenu.cells.clear_sky),
                                             fewClouds: convertToColorThemeModel(mainMenu.cells.few_clouds),
                                             scatteredClouds: convertToColorThemeModel(mainMenu.cells.scattered_clouds),
                                             brokenClouds: convertToColorThemeModel(mainMenu.cells.broken_clouds),
                                             showerRain: convertToColorThemeModel(mainMenu.cells.shower_rain),
                                             rain: convertToColorThemeModel(mainMenu.cells.rain),
                                             thunderstorm: convertToColorThemeModel(mainMenu.cells.rain),
                                             snow: convertToColorThemeModel(mainMenu.cells.snow),
                                             mist: convertToColorThemeModel(mainMenu.cells.mist))
        return MainMenuColorThemeModel(isStatusBarDark: rawColorThemeDataModel.mainMenu.isStatusBarDark,
                                       backgroundColor: makeColor(hex: mainMenu.backgroundColor),
                                       dateLabelColor: makeColor(hex: mainMenu.dateLabelColor),
                                       todayColor: makeColor(hex: mainMenu.todayColor),
                                       settingsIconColor: makeColor(hex: mainMenu.settingsIconColor),
                                       searchButtonColor: makeColor(hex: mainMenu.searchButtonColor),
                                       cells: cellsMenu)
    }
    
    var cityDetails: CityDetailsColorThemeModel {
        let cityDetails = rawColorThemeDataModel.cityDetails
        
        let screenBackground = ScreenBackgroundColorThemeModel(colors: makeColors(hexes: cityDetails.screenBackground.colors),
                                                               gradient: convertToGradientColorThemeModel(cityDetails.screenBackground.gradient),
                                                               mainIconColor: makeColor(hex: cityDetails.screenBackground.mainIconColor),
                                                               labelsColor: makeColor(hex: cityDetails.screenBackground.labelsColor),
                                                               labelsSecondaryColor: makeColor(hex: cityDetails.screenBackground.labelsSecondaryColor),
                                                               ignoreColorInheritance: cityDetails.screenBackground.ignoreColorInheritance)
        
        let iconColors = IconColorsColorThemeModel(mist: makeColor(hex: cityDetails.iconColors.mist),
                                                   snow: makeColor(hex: cityDetails.iconColors.snow),
                                                   rain: makeColor(hex: cityDetails.iconColors.rain),
                                                   showerRain: makeColor(hex: cityDetails.iconColors.showerRain),
                                                   thunderstorm: makeColor(hex: cityDetails.iconColors.thunderstorm),
                                                   cloud: makeColor(hex: cityDetails.iconColors.cloud),
                                                   sun: makeColor(hex: cityDetails.iconColors.sun),
                                                   humidity: makeColor(hex: cityDetails.iconColors.humidity),
                                                   uvIndex: makeColor(hex: cityDetails.iconColors.uvIndex),
                                                   wind: makeColor(hex: cityDetails.iconColors.wind),
                                                   cloudiness: makeColor(hex: cityDetails.iconColors.cloudiness),
                                                   pressure: makeColor(hex: cityDetails.iconColors.pressure),
                                                   visibility: makeColor(hex: cityDetails.iconColors.visibility))
        
        return CityDetailsColorThemeModel(isNavBarDark: rawColorThemeDataModel.cityDetails.isNavBarDark,
                                          isStatusBarDark: rawColorThemeDataModel.cityDetails.isStatusBarDark,
                                          hourlyForecast: convertToBackgroundColorColorThemeModel(cityDetails.hourlyForecast),
                                          weeklyForecast: convertToBackgroundColorColorThemeModel(cityDetails.weeklyForecast),
                                          temperatureItem: convertToBackgroundColorColorThemeModel(cityDetails.temperatureItem),
                                          contentBackground: ContentBackgroundColorTheme(color: makeColor(hex: cityDetails.contentBackground.color),
                                                                                         isClearBackground: cityDetails.contentBackground.isClearBackground),
                                          screenBackground: screenBackground,
                                          iconColors: iconColors)
    }
    
    // MARK: - Construction
    
    init() {
        let black = "#000000"
        let white = "#ffffff"
        let defaultColors = Colors(colors: [white],
                                  iconColors: black,
                                  labelsColor: black)
        let defaultGradient = Gradient(startPoint: StartPoint(x: 0.0,
                                                              y: 0.0),
                                       endPoint: EndPoint(x: 0.0,
                                                          y: 0.0))
        let addCity = AddCity(backgroundColor: white,
                              searchFieldBackground: white,
                              cancelButtonColor: black,
                              placeholderColor: black,
                              handleColor: black,
                              isShadowVisible: true,
                              labelsColor: black,
                              labelsSecondaryColor: black)
        
        let settingsScreen = SettingsScreen(backgroundColor: white,
                                            cellsBackgroundColor: white,
                                            labelsColor: black,
                                            labelsSecondaryColor: black,
                                            appIconSelectBorderColor: black,
                                            appIconDeselectBorderColor: white,
                                            temperatureSwitchColor: white,
                                            colorBoxesColors: Array.init(repeating: white, count: 4))
        let defaultCells = Cells(isShadowVisible: true,
                                 gradient: defaultGradient,
                                 defaultBackground: white,
                                 defaultLoadingViewsColor: white,
                                 activityViewColor: black,
                                 clear_sky: defaultColors,
                                 few_clouds: defaultColors,
                                 scattered_clouds: defaultColors,
                                 broken_clouds: defaultColors,
                                 shower_rain: defaultColors,
                                 rain: defaultColors,
                                 thunderstorm: defaultColors,
                                 snow: defaultColors,
                                 mist: defaultColors)
        let defaultMainMenu = MainMenu(isStatusBarDark: true,
                                       backgroundColor: white,
                                       dateLabelColor: black,
                                       todayColor: black,
                                       settingsIconColor: black,
                                       searchButtonColor: black,
                                       cells: defaultCells)
        let defaultBackgroundColor = BackgroundColor(backgroundColor: white,
                                                     isClearBackground: false,
                                                     isShadowVisible: true,
                                                     labelsColor: black,
                                                     labelsSecondaryColor: black)
        let defaultIconColors = IconColors(mist: black,
                                           snow: black,
                                           rain: black,
                                           showerRain: black,
                                           thunderstorm: black,
                                           cloud: black,
                                           sun: black,
                                           humidity: black,
                                           uvIndex: black,
                                           wind: black,
                                           cloudiness: black,
                                           pressure: black,
                                           visibility: black)
        let defaultCityDetails = CityDetails(isNavBarDark: false,
                                             isStatusBarDark: true,
                                             hourlyForecast: defaultBackgroundColor,
                                             weeklyForecast: defaultBackgroundColor,
                                             temperatureItem: defaultBackgroundColor,
                                             contentBackground: ContentBackground(color: white, isClearBackground: false),
                                             screenBackground: ScreenBackground(colors: [white],
                                                                                gradient: defaultGradient,
                                                                                mainIconColor: black,
                                                                                labelsColor: black,
                                                                                labelsSecondaryColor: black,
                                                                                ignoreColorInheritance: true),
                                             iconColors: defaultIconColors)
        rawColorThemeDataModel = ColorThemeData(title: "Default",
                                                settingsScreen: settingsScreen,
                                                mainMenu: defaultMainMenu,
                                                addCity: addCity,
                                                cityDetails: defaultCityDetails)
    }
    
    init(colorThemeData: ColorThemeData) {
        rawColorThemeDataModel = colorThemeData
    }
    
    // MARK: - Functions
    
    func getColorByConditionId(_ conditionId: Int) -> ColorThemeColorsModel {
        switch conditionId {
        case 200...232:
            return moreOptions.cells.thunderstorm
        case 300...321:
            return moreOptions.cells.rain
        case 500...531:
            return moreOptions.cells.showerRain
        case 600...622:
            return moreOptions.cells.snow
        case 701...781:
            return moreOptions.cells.mist
        case 800:
            return moreOptions.cells.clearSky
        case 801...804:
            return moreOptions.cells.scatteredClouds
        default:
            return moreOptions.cells.clearSky
        }
    }
    
    func getDetailReviewIconColorByConditionId(_ conditionId: Int) -> UIColor {
        let iconColors = cityDetails.iconColors
        switch conditionId {
        case 200...232:
            return iconColors.thunderstorm
        case 300...321:
            return iconColors.rain
        case 500...531:
            return iconColors.showerRain
        case 600...622:
            return iconColors.snow
        case 701...781:
            return iconColors.mist
        case 800:
            return iconColors.sun
        case 801...804:
            return iconColors.cloud
        default:
            return iconColors.sun
        }
    }
    
    static func convertUiColorsToCg(_ uiColors: [UIColor]) -> [CGColor] {
        var cgColors: [CGColor] = []
        for uiColor in uiColors {
            cgColors.append(uiColor.cgColor)
        }
        return cgColors
    }
    
    // MARK: - Private functions
                                                               
    private func convertToGradientColorThemeModel(_ gradient: Gradient) -> GradientColorThemeModel {
        return GradientColorThemeModel(startPoint: CGPoint(x: gradient.startPoint.x, y: gradient.startPoint.y),
                                       endPoint: CGPoint(x: gradient.endPoint.x, y: gradient.endPoint.y))
    }
    
    private func convertToBackgroundColorColorThemeModel(_ backgroundColorModel: BackgroundColor) -> BackgroundColorColorThemeModel {
        return BackgroundColorColorThemeModel(backgroundColor: makeColor(hex: backgroundColorModel.backgroundColor),
                                              isClearBackground: backgroundColorModel.isClearBackground,
                                              isShadowVisible: backgroundColorModel.isShadowVisible,
                                              labelsColor: makeColor(hex: backgroundColorModel.labelsColor),
                                              labelsSecondaryColor: makeColor(hex: backgroundColorModel.labelsSecondaryColor))
    }
    
    private func convertToColorThemeModel(_ colorsModel: Colors) -> ColorThemeColorsModel {
        return ColorThemeColorsModel(colors: makeColors(hexes: colorsModel.colors),
                                     iconsColor: makeColor(hex: colorsModel.iconColors),
                                     labelsColor: makeColor(hex: colorsModel.labelsColor))
    }
    
    private func makeColors(hexes: [String]) -> [UIColor] {
        var colors: [UIColor] = []
        for colorHex in hexes {
            colors.append(makeColor(hex: colorHex))
        }
        return colors
    }
    
    private func makeColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
