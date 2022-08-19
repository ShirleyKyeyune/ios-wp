//
//  Constants.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

struct WPConstants {
    struct CoreData {
        struct City {
            static let entityName = "City"
            static let id = "id"
            static let name = "name"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let orderPosition = "orderPosition"
            static let dateTime = "dateTime"
            static let conditionId = "conditionId"
            static let temperature = "temperature"
            static let temperatureMin = "temperatureMin"
            static let temperatureMax = "temperatureMax"
            static let feelsLike = "feelsLike"
            static let weatherConditionDescription = "weatherConditionDescription"
            static let lastUpdatedDateTime = "weatherConditionDescription"
            static let timezone = "timezone"
        }
        
        struct DailyWeather {
            static let entityName = "DailyWeather"
            static let id = "id"
            static let cityId = "cityId"
            static let conditionId = "conditionId"
            static let dayTemp = "dayTemp"
            static let maxTemp = "maxTemp"
            static let minTemp = "minTemp"
            static let time = "time"
            static let timezone = "timezone"
        }
    }

    struct CellIdentifier {
        static let cityCell = "cityCell"
        static let cityLoadingCell = "cityLoadingCell"
        static let dailyForecastCell = "dailyForecastCell"
        static let hourlyForecastCell = "hourlyForecastCell"
        static let colorThemeCell = "colorThemeCell"
        static let appIconCell = "AppIconCell"
    }
    
    struct AppState {
        static let loading = "Loading..."
    }

    struct WeatherDescription {
        static let sunny = "SUNNY"
        static let cloudy = "CLOUDY"
        static let rainy = "RAINY"
    }
    
    struct WeatherColor {
        static let sunny = "#4B8FE2"
        static let cloudy = "#54717A"
        static let rainy = "#57575D"
    }
    
    struct ImageName {
        static let deleteImage = "DeleteAction"
        
        static let appIcon = "AppIcon"
        static let rainyBackground = "RainyBg.png"
        static let sunnyBackground = "SunnyBg.png"
        static let cloudyBackground = "CloudyBg.png"
        static let clearIcon = "ClearIcon.png"
        static let partlySunnyIcon = "PartlySunnyIcon.png"
        static let rainIcon = "RainIcon.png"
    }
    
    struct SystemImageName {
        static let sunMaxFill = "sun.max.fill"
        static let sunriseFill = "sunrise.fill"
        static let sunsetFill = "sunset.fill"
        static let eyeFill = "eye.fill"
        static let wind = "wind"
        static let cloudFill = "cloud.fill"
        static let drop = "drop.fill"
        static let cloudFogFill = "cloud.fog.fill"
        static let cloudSnowFill = "cloud.snow.fill"
        static let cloudRainFill = "cloud.rain.fill"
        static let cloudDrizzleFill = "cloud.drizzle.fill"
        static let cloudBoltFill = "cloud.bolt.fill"
        static let gearshape = "gearshape.fill"
        static let map = "map"
        static let plus = "plus"
        static let checkmark = "checkmark"
        static let envelope = "envelope"
        static let paperplane = "paperplane"
        static let paintbrush = "paintbrush"
        static let ruler = "ruler"
        
        static let arrowDown = "chevron.compact.down"
        static let arrowUp = "chevron.compact.up"
    }
    
    struct AccessabilityIdentifier {
        static let MoreOptionsTableViewCell = "MoreOptionsTableViewCell"
        
        static let mapButton = "MapButton"
        static let settingsButton = "SettingsButton"
        static let searchButton = "SearchButton"
        
        static let addCityCell = "AddCityCell"
        
        static let colorSettingsTableView = "ColorSettingsTableView"
        
        static let settingsUnitSwitch = "SettingsUnitSwitch"
        
        static let settingsTableView = "SettingsTableView"
    }

    struct UserDefaults {
        static let unit = "Unit"
        static let imperial = "imperial"
        static let metric = "metric"
        
        static let currentColorTheme = "currentColorTheme"
        static let colorThemePositionNumber = "colorThemePositionNumber"
        
        static let appIconNumber = "AppIconNumber"
    }

    struct Network {
        static let currentBaseURL = "https://api.openweathermap.org/data/2.5/weather?"
        static let forecastBaseURL = "https://api.openweathermap.org/data/2.5/forecast?"
        static let apiKey = "a26f4790766821a3e9dbaf5e1e534052"
        static let lat = "lat="
        static let lon = "lon="
        static let appid = "appid="
        static let units = "units="
        static let exclude = "exclude="
        static let minutely = "minutely"
    }
    
    struct Misc {
        static let defaultCityName = "-"
        static let colorThemeLocalFile = "ColorThemes"
    }

    struct Colors {
        struct Gradient {
            static let day = [UIColor(red: 68 / 255, green: 166 / 255, blue: 252 / 255, alpha: 1).cgColor,
                              UIColor(red: 114 / 255, green: 225 / 255, blue: 253 / 255, alpha: 1).cgColor]
            static let night = [UIColor(red: 9 / 255, green: 7 / 255, blue: 40 / 255, alpha: 1).cgColor,
                                UIColor(red: 30 / 255, green: 94 / 255, blue: 156 / 255, alpha: 1).cgColor]
            static let blank = [UIColor.clear.cgColor]
            static let fog = [UIColor.clear.cgColor]
        }
        
        struct WeatherIcons {
            static let defaultColor = UIColor(red: 121 / 255, green: 199 / 255, blue: 248 / 255, alpha: 1)
            static let defaultSunColor = UIColor(red: 244 / 255, green: 189 / 255, blue: 59 / 255, alpha: 1)
        }
        
        struct WeatherBg {
            static let sunnyColor = UIColor("#4B8FE2")
            static let cloudyColor = UIColor("#54717A")
            static let rainyColor = UIColor("#57575D")
        }
    }
}
