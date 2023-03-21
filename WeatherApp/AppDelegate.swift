//
//  AppDelegate.swift
//  WeatherApp

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appNavigator: Navigator = AppNavigator()
    static let shared = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApp()
        return true
    }
}

extension AppDelegate {
    func startApp() {
        appNavigator.showAddCityView()
    }
}

