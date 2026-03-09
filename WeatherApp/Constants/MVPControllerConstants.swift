//
//  MVPControllerConstants.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum MVPControllerConstants {
    
    // MARK: - Layout Constants
    enum Layout {
        static let burgerButtonSize: CGFloat = 50
        static let burgerButtonLeftOffset: CGFloat = 20
        static let burgerButtonTopOffset: CGFloat = 50
        
        static let cityLabelTopOffset: CGFloat = 50
        static let cityLabelHorizontalInset: CGFloat = 20
        
        static let temperatureLabelTopOffset: CGFloat = 30
        
        static let feelsLikeLabelTopOffset: CGFloat = 10
        
        static let descriptionLabelTopOffset: CGFloat = 20
        
        static let windLabelTopOffset: CGFloat = 10
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let cityLabelFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let temperatureLabelFont = UIFont.systemFont(ofSize: 54, weight: .bold)
        static let secondaryLabelFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    // MARK: - Colors
    enum Colors {
        static let background = UIColor.black
        static let text = UIColor.white
        static let burgerButtonTint = UIColor.label
        static let burgerButtonBackground = UIColor.white
    }
    
    // MARK: - Strings
    enum Strings {
        static let defaultCity = "Moscow"
        static let defaultTemperature = "-- °C"
        static let defaultFeelsLike = "fells like -- °C".localized
        static let defaultDescription = "--"
        static let defaultWind = "wind -- m/s, --".localized
        static let burgerButtonImageName = "line.horizontal.3"
    }
}
