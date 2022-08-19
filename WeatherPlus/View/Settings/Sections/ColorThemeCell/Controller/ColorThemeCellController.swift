//
//  ColorThemeCellController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import Foundation
import UIKit

class ColorThemeCellController: ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    let cell: ColorThemeSettingsCell
    
    weak var viewControllerOwner: (SettingsViewControllerDelegate & ReloadColorThemeProtocol)?
    
    var reloadingViews: [ReloadColorThemeProtocol] = []
    
    // MARK: - Private properties
    
    let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        cell = ColorThemeSettingsCell(colorThemeComponent: colorThemeComponent)
        cell.delegate = self
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        cell.reloadColorTheme()
        cell.refresh()
    }
}

extension ColorThemeCellController: ColorThemeSettingsCellDelegste {
    func presentColorThemes() {
        let colorThemeSettingsViewController = ColorThemeViewController(colorThemeComponent: colorThemeComponent)
        reloadingViews.append(self)
        reloadingViews.append(colorThemeSettingsViewController)
        
        if let strongViewControllerOwner = viewControllerOwner {
            reloadingViews.append(strongViewControllerOwner)
        }
        
        colorThemeSettingsViewController.reloadingViews = reloadingViews
        
        viewControllerOwner?.navigationController?.pushViewController(colorThemeSettingsViewController, animated: true)
    }
}
