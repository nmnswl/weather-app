//
//  CityListCoordinator.swift
//  WeatherApp

import Foundation
import UIKit

protocol CityListViewModelToCoordinator: AnyObject {
    func addCity()
    func showWeatherDetails(for city: String)
}

protocol Poppable: AnyObject {
    func didTapBack(coordinator: Coordinator, navigationFrom: NavigationFrom)
}

final class CityListCoordinator: Coordinator, Poppable {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    func start() {
        let cityListViewController = UIStoryboard.main.instantiateViewController(CityListViewController.self)
        let navigationController = UINavigationController(rootViewController: cityListViewController)
        navigationController.isNavigationBarHidden = true
        let viewModel = CityListViewModel()
        viewModel.coordinatorDelegate = self
        cityListViewController.bindViewModel(viewModel)
        self.navigationController = navigationController
    }
    
    func didTapBack(coordinator: Coordinator, navigationFrom: NavigationFrom) {
        //Handles back navigation from different view controllers
        switch navigationFrom {
        case .addCity:
            navigationController?.popToController(CityListViewController.self)
        default:
            navigationController?.popViewController(animated: true)
        }
        self.removeChild(coordinator)
    }
}

extension CityListCoordinator: CityListViewModelToCoordinator {
    func addCity() {
        guard let navigationController = self.navigationController else { return }
        let addCityCoordinator = AddCityCoordinator(navigationController: navigationController)
        addCityCoordinator.parentCoordinatorDelegate = self
        addCityCoordinator.start()
        self.addChild(addCityCoordinator)
    }
    
    func showWeatherDetails(for city: String) {
        guard let navigationController = navigationController else { return }
        let cityWeatherCoordinator = CityWeatherDetailCoordinator(navigationController: navigationController, cityName: city, navigationFrom: .cityList)
        cityWeatherCoordinator.parentCoordinatorDelegate = self
        cityWeatherCoordinator.start()
        self.addChild(cityWeatherCoordinator)
    }
}
