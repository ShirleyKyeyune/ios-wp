//
//  MoreOptionsCellBuilder.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

protocol MoreOptionsCellBuilderProtocol: AnyObject {
    
    @discardableResult
    func erase() -> Self
    
    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self
    
    @discardableResult
    func build(cityLabelByString: String) -> Self
    
    @discardableResult
    func build(degreeLabelByString: String) -> Self
    
    @discardableResult
    func build(lastUpdateDateTime: String) -> Self
    
    @discardableResult
    func build(imageByString conditionImage: String) -> Self
    
    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool)-> Self
    
    var content: MoreOptionsTableViewCell { get }
}

final class MoreOptionsCellBuilder {
    private var _content = MoreOptionsTableViewCell()
}

extension MoreOptionsCellBuilder: MoreOptionsCellBuilderProtocol {
    
    func erase() -> Self {
        _content = MoreOptionsTableViewCell()
        _content.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.MoreOptionsTableViewCell
        return self
    }
    
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self {
        guard let safeColortheme = colorThemeModel else {
            return self
        }
        
        _content.cityNameLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.degreeLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.timeLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.gradient.startPoint = safeColortheme.moreOptions.cells.gradient.startPoint
        _content.gradient.endPoint = safeColortheme.moreOptions.cells.gradient.endPoint
        
        if safeColortheme.moreOptions.cells.isShadowVisible {
            DesignManager.setBackgroundStandardShadow(layer: _content.weatherBackgroundView.layer)
        }
        
        if let currentImage = _content.conditionImage.image {
            _content.conditionImage.image = currentImage.withTintColor(safeColortheme.getColorByConditionId(conditionId).iconsColor)
        }
        
        return self
    }
    
    func build(cityLabelByString cityNameString: String) -> Self {
        _content.cityNameLabel.text = cityNameString
        return self
    }
    
    func build(degreeLabelByString degreeString: String) -> Self {
        _content.degreeLabel.text = degreeString
        return self
    }
    
    func build(lastUpdateDateTime: String) -> Self {
        _content.timeLabel.text = lastUpdateDateTime
        return self
    }
    
    func build(imageByString conditionImage: String) -> Self {
        let imageBuilder = ConditionImageBuilder()
        let newImage = imageBuilder
            .erase(.defaultColors)
            .build(systemImageName: conditionImage, pointConfiguration: WPSize.pt20)
            .content
        
        _content.conditionImage.image = newImage
        
        return self
    }
    
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool) -> Self {
        guard let backgroundColors = colorThemeModel?.getColorByConditionId(conditionId).colors else {
            return self
        }
        
        var colors = ColorThemeModel.convertUiColorsToCg(backgroundColors)
        
        if let firstColor = colors.first, colors.count < 2 {
            colors.append(firstColor)
        }
        
        _content.gradient.colors = colors
        return self
    }
    
    var content: MoreOptionsTableViewCell {
        _content
    }
}
