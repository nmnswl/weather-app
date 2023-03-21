//
//  AppNavigation.swift
//  WeatherApp

import UIKit

protocol Navigator {
    func showCityListView()
}

enum Destination {
    case cityList
}

class AppNavigator: Navigator {
    
    func showCityListView() {
        redirectTo(destination: .cityList)
    }
    
    private func redirectTo(destination: Destination) {
        switch destination {
        case .cityList:
            guard let cityListViewController = UIStoryboard.main.instantiateViewController(identifier: CityListViewController.identifier) as? CityListViewController else { return }
            let navigationController = UINavigationController(rootViewController: cityListViewController)
            navigationController.isNavigationBarHidden = true
            AppDelegate.shared.window?.rootViewController = navigationController
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
    }
}
