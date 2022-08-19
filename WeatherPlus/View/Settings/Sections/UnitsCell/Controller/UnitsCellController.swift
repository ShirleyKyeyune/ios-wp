//
//  UnitsCellController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import Foundation

class UnitsCellController: ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    let cell: UnitsCell
    
    weak var viewControllerOwner: SettingsViewControllerDelegate?
    
    // MARK: - Private properties
    
    let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        cell = UnitsCell(colorThemeComponent: colorThemeComponent)
        cell.delegate = self
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}

extension UnitsCellController: UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int) {
        switch value {
            case 0:
                UserDefaultsManager.UnitData.set(with: WPConstants.UserDefaults.metric)
            case 1:
                UserDefaultsManager.UnitData.set(with: WPConstants.UserDefaults.imperial)
            default:
                break
        }
        
        viewControllerOwner?.refreshMoreOptions()
    }
}
