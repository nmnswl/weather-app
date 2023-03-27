//
//  AppDelegate.swift
//  WeatherApp

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApp()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        stopMonitoring()
    }
}

extension AppDelegate {
    func startApp() {
        guard let window = window else {
            fatalError("No window available")
        }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        startMonitoring()
    }
    
    private func startMonitoring() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    private func stopMonitoring() {
        NetworkMonitor.shared.stopMonitoring()
    }
}

