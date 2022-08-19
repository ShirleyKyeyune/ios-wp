//
//  ConditionImageConfigurator.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

protocol ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { get }
    var makeColorForDefaultImage: UIColor { get }
    var makeColorForCloudImage: UIColor { get }
}

struct StandardConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { WPConstants.Colors.WeatherIcons.defaultSunColor }
    var makeColorForDefaultImage: UIColor { WPConstants.Colors.WeatherIcons.defaultColor }
    var makeColorForCloudImage: UIColor { WPConstants.Colors.WeatherIcons.defaultColor }
}

struct WhiteConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { .white }
    var makeColorForDefaultImage: UIColor { .white }
    var makeColorForCloudImage: UIColor { .white }
}

struct BlackConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { .black }
    var makeColorForDefaultImage: UIColor { .black }
    var makeColorForCloudImage: UIColor { .black }
}
