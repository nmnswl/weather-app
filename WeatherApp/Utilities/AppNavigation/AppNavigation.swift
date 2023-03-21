//
//  AppNavigation.swift
//  WeatherApp

import UIKit

protocol Navigator {
    func showAddCityView()
}

enum Destination {
    case addCity
}

class AppNavigator: Navigator {
    
    func showAddCityView() {
        redirectTo(destination: .addCity)
    }
    
    private func redirectTo(destination: Destination) {
        switch destination {
        case .addCity:
            let addCityViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddCityViewController")
            let navigationController = UINavigationController(rootViewController: addCityViewController)
            navigationController.isNavigationBarHidden = true
            AppDelegate.shared.window?.rootViewController = navigationController
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
    }
}
