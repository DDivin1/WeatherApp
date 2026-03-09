//
//  CityControllerConstants.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum CityControllerConstants {
   
    // MARK: - Layout Constants
    enum Layout {
        static let searchBarTopOffset: CGFloat = 8
        static let searchBarHorizontalOffset: CGFloat = 8
        static let searchBarHeight: CGFloat = 50
        
        static let tableViewTopOffset: CGFloat = 8
        
        static let cellHeight: CGFloat = 40
        
        static let closeButtonSize: CGFloat = 50
    }
    
    // MARK: - Colors
    enum Colors {
        static let background = UIColor.black
        static let searchBarTint = UIColor.white
        static let searchBarText = UIColor.white
        static let tableViewBackground = UIColor.black
        static let tableViewSeparator = UIColor.white
        static let cellText = UIColor.white
        static let navigationBarTint = UIColor.white
        static let navigationBarTitle = UIColor.white
        static let deleteAction = UIColor.systemRed
    }
    
    // MARK: - Strings
    enum Strings {
        static let searchBarPlaceholder = "Enter city name...".localized
        static let title = "Search City".localized
        static let deleteButtonTitle = "Delete".localized
        static let cancelButtonTitle = "Cancel".localized
        static let deleteConfirmationTitle = "Delete city".localized
        static let deleteConfirmationMessage = "Are you sure to delete the city?".localized
        static let closeButtonImageName = "xmark"
        static let deleteImageName = "trash"
    }
}
