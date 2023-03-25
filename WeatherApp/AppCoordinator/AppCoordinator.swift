//
//  AppCoordinator.swift
//  WeatherApp

import Foundation
import UIKit

enum NavigationFrom {
    case cityList, addCity, cityWeatherDetail
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func removeChild(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        //Starts the app
        let cityListCoordinator = CityListCoordinator()
        cityListCoordinator.start()
        self.addChild(cityListCoordinator)
        window?.rootViewController = cityListCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}
