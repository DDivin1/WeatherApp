//
//  CityAssembly.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 27.02.26.
//

import UIKit

final class CityAssembly {
    
    static func assemble(mainPresenter: MVPPresenter) -> UIViewController {
        let networkService = NetworkService()
        let citiesStorage = CitiesStorage()
        let presenter = CityPresenter(
            networkService: networkService,
            citiesStorage: citiesStorage,
            mainPresenter: mainPresenter
        )
        let viewController = CityController(presenter: presenter)
        presenter.view = viewController
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        
        return navController
    }
}
