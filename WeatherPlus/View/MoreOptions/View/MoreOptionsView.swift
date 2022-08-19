//
//  MoreOptionsView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

class MoreOptionsView: UIView {
    
    // MARK: - Properties
    
    weak var viewController: MoreOptionsViewController?
    var colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Private properties
    
    private var tableViewHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currentDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt12, weight: .medium)
        label.text = "date label"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt32, weight: .bold)
        label.text = "Favorites"
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.settingsButton
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: WPConstants.SystemImageName.gearshape, withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.mapButton
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: WPConstants.SystemImageName.map, withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.searchButton
        button.addTarget(self, action: #selector(addNewCityButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: WPConstants.SystemImageName.plus, withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mainHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = WPSize.pt4
        return stackView
    }()
    
    private var todayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = WPSize.pt16
        return stackView
    }()
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Public properties
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        // Space before the first cell
        tableView.contentInset.top = WPSize.pt8 // Getting rid of any delays between user touch and cell animation
        tableView.delaysContentTouches = false // Setting up drag and drop delegates
        tableView.dragInteractionEnabled = true
        tableView.register(LoadingCell.self, forCellReuseIdentifier: WPConstants.CellIdentifier.cityLoadingCell)
        tableView.register(MoreOptionsTableViewCell.self, forCellReuseIdentifier: WPConstants.CellIdentifier.cityCell)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol, tableViewDataSourceDelegate: MoreOptionsTableViewDelegate) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        let result = "TODAY, " + dateFormatter.string(from: currentDate).uppercased()
        currentDateLabel.text = result
        
        tableView.dataSource = tableViewDataSourceDelegate
        tableView.delegate = tableViewDataSourceDelegate
        tableView.dragDelegate = tableViewDataSourceDelegate
        tableView.dropDelegate = tableViewDataSourceDelegate
        self.addSubview(tableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        todayStackView.addArrangedSubview(titleLabel)
        todayStackView.addArrangedSubview(mapButton)
        todayStackView.addArrangedSubview(searchButton)
        
        leftStackView.addArrangedSubview(currentDateLabel)
        leftStackView.addArrangedSubview(todayStackView)
        
        mainHeaderStackView.addArrangedSubview(leftStackView)
        mainHeaderStackView.addArrangedSubview(settingsButton)
        
        tableViewHeaderView.addSubview(mainHeaderStackView)
        
        tableView.tableHeaderView = tableViewHeaderView
        
        reloadViews()
        setUpConstraints()
        tableView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadViews() {
        searchButton.tintColor = colorThemeComponent.colorTheme.moreOptions.searchButtonColor
        settingsButton.tintColor = colorThemeComponent.colorTheme.moreOptions.settingsIconColor
        titleLabel.textColor = colorThemeComponent.colorTheme.moreOptions.todayColor
        currentDateLabel.textColor = colorThemeComponent.colorTheme.moreOptions.dateLabelColor
        backgroundColor = colorThemeComponent.colorTheme.moreOptions.backgroundColor
    }
    
    // MARK: - Private Functions
    
    private func setUpConstraints() {
        // TableView
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // TableView header
        tableViewHeaderView.heightAnchor.constraint(equalToConstant: WPSize.pt84).isActive = true
        tableViewHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        
        // Main stackView
        mainHeaderStackView.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor,
                                                     constant: WPSize.pt16).isActive = true
        
        let mainHeaderStackViewConstraint = mainHeaderStackView.trailingAnchor.constraint(equalTo: tableViewHeaderView.trailingAnchor,
                                                                                         constant: -WPSize.pt16)
        mainHeaderStackViewConstraint.priority = UILayoutPriority(999)
        mainHeaderStackViewConstraint.isActive = true
        
        mainHeaderStackView.bottomAnchor.constraint(equalTo: tableViewHeaderView.bottomAnchor,
                                                    constant: -WPSize.pt4).isActive = true
        mainHeaderStackView.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor,
                                                 constant: WPSize.pt4).isActive = true
        
        // Search button
        searchButton.heightAnchor.constraint(equalTo: settingsButton.heightAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: settingsButton.widthAnchor).isActive = true
    }
    
    // MARK: - Actions
    
    @objc func refreshWeatherData(_ sender: AnyObject) {
        viewController?.fetchWeatherData()
        refreshControl.endRefreshing()
    }
    
    @objc func addNewCityButtonPressed() {
        viewController?.showAddCityVC()
    }
    
    @objc func settingsButtonPressed() {
        viewController?.showSettingsViewController()
    }
    
    @objc func mapButtonPressed() {
        viewController?.showMapViewController()
    }
}

