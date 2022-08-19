//
//  AlertViewBuilder.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation
import UIKit

protocol AlertViewBuilderProtocol: AnyObject {
    
    @discardableResult
    func erase() -> Self
    
    @discardableResult
    func build(title: String, message: String, preferredStyle: UIAlertController.Style) -> Self
    
    @discardableResult
    func build(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> (Void))?) -> Self
    
    var content: UIAlertController { get }
}

final class AlertViewBuilder {
    private var _content = UIAlertController()
}

extension AlertViewBuilder: AlertViewBuilderProtocol {
    func erase() -> Self {
        _content = UIAlertController()
        return self
    }
    
    func build(title: String, message: String, preferredStyle: UIAlertController.Style) -> Self {
        _content = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        return self
    }
    
    func build(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> (Void))?) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        _content.addAction(action)
        return self
    }
    
    var content: UIAlertController {
        _content
    }
}
