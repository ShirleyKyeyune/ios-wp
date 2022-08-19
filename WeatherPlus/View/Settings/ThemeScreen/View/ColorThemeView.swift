//
//  ColorThemeView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

class ColorThemeView: UIView, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.colorSettingsTableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ColorThemeCell.self, forCellReuseIdentifier: WPConstants.CellIdentifier.colorThemeCell)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var chosenColorThemePosition = 0
    private var currentColorTheme: ColorThemeProtocol
    private var colorThemes: [ColorThemeModel]
    
    // MARK: - Public properties
    
    var viewControllerOwner: ColorThemeViewController?
    
    // MARK: - Construction
    
    init(currentColorTheme: ColorThemeProtocol ,colorThemes: [ColorThemeModel]) {
        self.currentColorTheme = currentColorTheme
        self.colorThemes = colorThemes
        
        super.init(frame: .zero)
        
        reloadColorTheme()
        refreshCheckedColorTmeme()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = currentColorTheme.colorTheme.settingsScreen.backgroundColor
        tableView.reloadData()
    }
    
    // MARK: - Private functions
    
    private func setUpConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func refreshCheckedColorTmeme() {
        chosenColorThemePosition = UserDefaultsManager.ColorTheme.getCurrentColorThemeNumber()
    }
}

extension ColorThemeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorThemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WPConstants.CellIdentifier.colorThemeCell) as? ColorThemeCell else {
            return UITableViewCell()
        }
        
        let colorTheme = colorThemes[indexPath.row]
        cell.resetCell()
        if chosenColorThemePosition == indexPath.row {
            cell.checkmarkImage.isHidden = false
        }
        cell.subtitle.text = colorTheme.title
        cell.checkmarkImage.tintColor = currentColorTheme.colorTheme.settingsScreen.labelsColor
        cell.subtitle.textColor = currentColorTheme.colorTheme.settingsScreen.labelsSecondaryColor
        cell.colorBoxesView.setupBlocks(colorTheme.settingsScreen.colorBoxesColors)
        cell.backgroundColor = currentColorTheme.colorTheme.settingsScreen.cellsBackgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaultsManager.ColorTheme.setChosenPositionColorTheme(with: indexPath.row)
        refreshCheckedColorTmeme()
        viewControllerOwner?.refreshCurrentColorThemeSettingsCell(colorThemePosition: indexPath.row)
    }
}
