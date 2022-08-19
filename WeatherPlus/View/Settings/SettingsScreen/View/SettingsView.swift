//
//  SettingsView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

class SettingsView: UIView, ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    var settingsSections: [SettingsSection]? = []
    
    // MARK: - Private properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.settingsTableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    required init(colorTheme: ColorThemeProtocol) {
        self.colorThemeComponent = colorTheme
        super.init(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        
        reloadColorTheme()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.backgroundColor
        tableView.reloadData()
    }
    
    // MARK: - Private functions
    
    private func setUpConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections?[section].cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let safeCell = settingsSections?[indexPath.section].cells[indexPath.row] else {
            return UITableViewCell()
        }
        return safeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections?[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = settingsSections?[indexPath.section].cells[indexPath.row] as? SettingsCellTappableProtocol {
            cell.tapCell()
        }
    }
}
