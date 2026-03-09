//
//  MVPAssembly.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 24.02.26.
//

import UIKit

final class MVPAssembly {
    
    
    func assemble() -> UIViewController {
        let networkService = NetworkService()
        let citiesStorage = CitiesStorage()
        
        let presenter = MVPPresenter(
            networkService: networkService,
            citiesStorage: citiesStorage
            )
        
        let controller = MVPController(presenter: presenter)
        
        presenter.view = controller 
        
        return controller
    }
}
