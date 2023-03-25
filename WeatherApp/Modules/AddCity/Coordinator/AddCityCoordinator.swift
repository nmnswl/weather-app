//
//  AddCityCoordinator.swift
//  WeatherApp

import UIKit

protocol AddCityViewModelToCoordinator: AnyObject {
    func showWeatherDetails(for city: String)
    func didTapBack()
}

final class AddCityCoordinator: Coordinator, Poppable {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var parentCoordinator: CityListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let addCityViewController = UIStoryboard.main.instantiateViewController(AddCityViewController.self)
        let viewModel = AddCityViewModel()
        viewModel.coordinatorDelegate = self
        addCityViewController.bindViewModel(viewModel)
        navigationController?.pushViewController(addCityViewController, animated: true)
    }
    
    func didTapBack(coordinator: Coordinator, navigationFrom: NavigationFrom) {
        //Handles back navigation
        self.removeChild(coordinator)
        parentCoordinator?.didTapBack(coordinator: self, navigationFrom: navigationFrom)
    }
}

extension AddCityCoordinator: AddCityViewModelToCoordinator {
    func showWeatherDetails(for city: String) {
        guard let navigationController = self.navigationController else { return }
        let cityWeatherCoordinator = CityWeatherDetailCoordinator(navigationController: navigationController, cityName: city, navigationFrom: .addCity)
        cityWeatherCoordinator.parentCoordinator = self
        cityWeatherCoordinator.start()
        self.addChild(cityWeatherCoordinator)
    }
    
    func didTapBack() {
        parentCoordinator?.didTapBack(coordinator: self, navigationFrom: .addCity)
    }
}
