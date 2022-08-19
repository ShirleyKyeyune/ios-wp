//
//  ConditionImageBuilder.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

enum ConditionColorMode {
    case onlyWhite
    case onlyBlack
    case defaultColors
}

protocol ConditionImageBuilderProtocol: AnyObject {
    
    @discardableResult
    func erase(_ customeColorMode: ConditionColorMode?) -> Self
    
    @discardableResult
    func build(systemImageName imageName: String, pointConfiguration: CGFloat) -> Self
    
    @discardableResult
    func buildColor(_ color: UIColor) -> Self
    
    var content: UIImage { get }
    var colorConfigurator: ConditionImageColorConfiguratorProtocol { get set }
}

final class ConditionImageBuilder {
    private var _content = UIImage()
    internal var colorConfigurator: ConditionImageColorConfiguratorProtocol = StandardConditionImageColorConfigurator()
}

extension ConditionImageBuilder: ConditionImageBuilderProtocol {
    
    func erase(_ customeColorMode: ConditionColorMode? = nil) -> Self {
        switch customeColorMode {
        case .onlyWhite:
            colorConfigurator = WhiteConditionImageColorConfigurator()
        case .onlyBlack:
            colorConfigurator = BlackConditionImageColorConfigurator()
        case .defaultColors, .none:
            colorConfigurator = StandardConditionImageColorConfigurator()
        }
        
        _content = UIImage()
        return self
    }
    
    func build(systemImageName imageName: String, pointConfiguration: CGFloat) -> Self {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: pointConfiguration)
        
        if let safeImageName = UIImage(systemName: imageName, withConfiguration: imageConfiguration) {
            _content = safeImageName.withRenderingMode(.alwaysOriginal)
        }
        return self
    }
    
    func buildColor(_ color: UIColor) -> Self {
        _content = _content.withTintColor(color)
        return self
    }
    
    var content: UIImage {
        _content
    }
}
