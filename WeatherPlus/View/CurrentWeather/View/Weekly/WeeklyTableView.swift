//
//  WeeklyTableView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

class WeeklyTableView: UIView {

    // MARK: - Properties

    var tableViewContentHeight: CGFloat {
        tableView.contentSize.height
    }

    // MARK: - Private properties
    
    private var dataSource: CurrentWeatherViewType?
    private var colorThemeComponent: ColorThemeProtocol

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(WeeklyCell.self, forCellReuseIdentifier: WPConstants.CellIdentifier.dailyForecastCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Construction

    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)

        tableView.dataSource = self
        tableView.delegate = self

        addSubview(backgroundView)
        backgroundView.addSubview(tableView)

        tableView.reloadData()

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func reloadData(_ newData: CurrentWeatherViewType) {
        dataSource = newData
        tableView.reloadData()
    }

    // MARK: - Private functions

    private func setupConstraints() {
        // BackgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        // TableView
        tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: WPSize.pt4).isActive = true
        tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -WPSize.pt20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: WPSize.pt8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -WPSize.pt8).isActive = true
    }
}

extension WeeklyTableView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.forecast5days.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WPConstants.CellIdentifier.dailyForecastCell) as? WeeklyCell,
              let safeWeatherData = dataSource else {
            return UITableViewCell()
        }
        
        cell.prepareForReuse()
        cell.setupColorTheme(colorThemeComponent)

        let targetWeather = safeWeatherData.forecast5days[indexPath.row]

        let cellViewModel: DailyCellType = DailyCellViewModel(dailyWeather: targetWeather,
                                                              index: indexPath.row)
        cell.weekDayLabel.text = cellViewModel.weekDay
        cell.temperatureLabel.text = cellViewModel.temperature

        if let image = UIImage(named: cellViewModel.conditionImage) {
            cell.conditionImage.image = image
        }
        return cell
    }

}
