//
//  CityWeatherDetailCoordinator.swift
//  WeatherApp

import Foundation
import UIKit

protocol CityWeatherViewModelToCoordinator: AnyObject {
    func didTapBack()
}

final class CityWeatherDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var cityName = ""
    var parentCoordinator: Poppable?
    var navigationFrom: NavigationFrom = .cityList
    
    init(navigationController: UINavigationController, cityName: String, navigationFrom: NavigationFrom) {
        self.navigationController = navigationController
        self.cityName = cityName
        self.navigationFrom = navigationFrom
    }
    
    func start() {
        let detailViewController = UIStoryboard.main.instantiateViewController(CityWeatherDetailViewController.self)
        let networkService = WeatherInfoNetworkService()
        let viewModel = CityWeatherDetailViewModel(networkService: networkService)
        viewModel.coordinatorDelegate = self
        viewModel.setCityName(as: cityName, navigationFrom: navigationFrom)
        detailViewController.bindViewModel(viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CityWeatherDetailCoordinator: CityWeatherViewModelToCoordinator {
    func didTapBack() {
        parentCoordinator?.didTapBack(coordinator: self, navigationFrom: navigationFrom)
    }
}
