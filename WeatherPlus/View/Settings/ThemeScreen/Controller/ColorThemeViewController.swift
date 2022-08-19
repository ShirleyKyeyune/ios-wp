//
//  ColorThemeViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

protocol ReloadColorThemeProtocol: AnyObject {
    func reloadColorTheme()
}

class ColorThemeViewController: UIViewController, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private lazy var mainView = ColorThemeView(currentColorTheme: colorThemeComponent,
                                                       colorThemes: ColorThemeManager.getColorThemes())
    
    // MARK: - Public properties
    
    var colorThemeComponent: ColorThemeProtocol
    var reloadingViews: [ReloadColorThemeProtocol] = []
    
    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
        reloadingViews.append(mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.viewControllerOwner = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color theme"
    }
    
    // MARK: - Public properties
    
    func reloadColorTheme() {
        mainView.reloadColorTheme()
    }
    
    func refreshCurrentColorThemeSettingsCell(colorThemePosition: Int) {
        colorThemeComponent.colorTheme = UserDefaultsManager.ColorTheme.getColorTheme(colorThemePosition)
        for reloadingView in reloadingViews {
            reloadingView.reloadColorTheme()
        }
    }
}
