//
//  String+extensions.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 6.03.26.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
