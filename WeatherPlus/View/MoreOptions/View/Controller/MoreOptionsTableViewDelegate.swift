//
//  MoreOptionsTableViewDelegate.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

protocol MoreOptionsTableViewDataSourceDelegate: AnyObject {
    var getSavedItems: [CurrentWeatherType]? { get }
    var displayWeather: [CurrentWeatherType?] { get }
    func deleteItemWithID(_ id: String)
    func deleteItem(at index: Int)
    func insertItem(at index: Int, item: CurrentWeatherType?)
    func removeItem(at index: Int)
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int)
    func didSelectRow()
}

class MoreOptionsTableViewDelegate: NSObject {
    
    // MARK: - Properties
    
    weak var viewController: MoreOptionsTableViewDataSourceDelegate?
    var colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Constructions
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
    }
}

extension MoreOptionsTableViewDelegate: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.displayWeather.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: WPConstants.CellIdentifier.cityLoadingCell) as? LoadingCell else {
            return UITableViewCell()
        }
        
        guard viewController?.displayWeather[indexPath.row] != nil,
              let weatherDataForCell = viewController?.displayWeather[indexPath.row],
              var cell = tableView.dequeueReusableCell(withIdentifier: WPConstants.CellIdentifier.cityCell) as? MoreOptionsTableViewCell else {
            loadingCell.setupColorTheme(colorTheme: colorThemeComponent)
            return loadingCell
        }
        
        let builder = MoreOptionsCellBuilder()
        let cellViewModel = LocationCellViewModel(weather: weatherDataForCell, index: indexPath.row)
        let cityName = cellViewModel.cityName
        let temperature = cellViewModel.temperature
        let conditionId = cellViewModel.conditionId
        let conditionImage = cellViewModel.conditionImage
        let localTimeWithLastUpdateTime = cellViewModel.lastUpateWithLocalTime
        
        cell = builder
            .erase()
            .build(cityLabelByString: cityName)
            .build(degreeLabelByString: temperature)
        
            .build(lastUpdateDateTime: localTimeWithLastUpdateTime)
            .build(imageByString: conditionImage)
            .build(colorThemeModel: colorThemeComponent.colorTheme,
                   conditionId: conditionId,
                   isDay: true)
            .build(colorThemeModel: colorThemeComponent.colorTheme, conditionId: conditionId)
            .content
        
        cell.layoutIfNeeded()
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.didSelectRow()
    }
    
    // Cell editing options: Handle delete city
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            
            //self.viewController?.displayWeather.remove(at: indexPath.row)
            self.viewController?.deleteItem(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
            completionHandler(true)
        }
        
        let imageSize = WPSize.pt60
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(named: WPConstants.ImageName.deleteImage)?.draw(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        }
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    // Cell highlight functions
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MoreOptionsTableViewCell {
            cell.isHighlighted = true
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MoreOptionsTableViewCell {
            cell.isHighlighted = false
        }
    }
}

// MARK: - tableView reorder functionality

extension MoreOptionsTableViewDelegate: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = viewController?.displayWeather[sourceIndexPath.row]
        viewController?.removeItem(at: sourceIndexPath.row)
        viewController?.insertItem(at: destinationIndexPath.row, item: mover)
        
        self.viewController?.rearrangeItems(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = viewController?.displayWeather[indexPath.row]
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    // Setting up cell appearance while dragging and dropping
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator() // Haptic effect
        selectionFeedbackGenerator.selectionChanged()
        
        return getDragAndDropCellAppearance(tableView, forCellAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return getDragAndDropCellAppearance(tableView, forCellAt: indexPath)
    }
    
    func getDragAndDropCellAppearance(_ tableView: UITableView, forCellAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            // Getting rid of system design
            param.shadowPath = UIBezierPath(rect: .zero)
        }
        return param
    }
}
