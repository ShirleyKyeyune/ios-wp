//
//  SettingsViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

struct SettingsSection {
    var title: String?
    var cells: [UITableViewCell]
}

protocol SettingsViewControllerDelegate: UIViewController {
    func refreshMoreOptions()
}

class SettingsViewController: UIViewController, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private lazy var colorThemeSettingsCellController: ColorThemeCellController = {
        let controller = ColorThemeCellController(colorThemeComponent: colorThemeComponent)
        controller.viewControllerOwner = self
        controller.reloadingViews.append(mainView)
        return controller
    }()
    private lazy var unitsSettingsCellController: UnitsCellController = {
        let controller = UnitsCellController(colorThemeComponent: colorThemeComponent)
        controller.viewControllerOwner = self
        return controller
    }()
    
    private lazy var settingsCellsControllers: [ReloadColorThemeProtocol] = [colorThemeSettingsCellController,
                                                                             unitsSettingsCellController]
    
    private lazy var mainView = SettingsView(colorTheme: colorThemeComponent)
    
    // MARK: - Public properties
    
    weak var moreOptionsDelegate: MoreOptionsDelegate?
    var colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appSettingsSection = SettingsSection(title: "APP",
                                                 cells: [unitsSettingsCellController.cell,
                                                         colorThemeSettingsCellController.cell])
        
        mainView.settingsSections? = [appSettingsSection]
        
        reloadColorTheme()
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        reloadAppearance()
        
        for reloadView in settingsCellsControllers {
            reloadView.reloadColorTheme()
        }
        
        mainView.reloadColorTheme()
        moreOptionsDelegate?.reloadColorTheme()
    }
    
    // MARK: - Private functions
    
    private func reloadAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = colorThemeComponent.colorTheme.settingsScreen.backgroundColor
        let titleAttribute = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
        appearance.largeTitleTextAttributes = titleAttribute
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func refreshMoreOptions() {
        moreOptionsDelegate?.fetchWeatherData()
    }
}
