//
//  UINavigationController+Extensions.swift
//  WeatherApp

import UIKit

extension UINavigationController {
    /**
     Method used to pop to a particular view controller
     */
    func popToController(_ controller: UIViewController.Type) {
        for viewController in viewControllers {
            if viewController.isKind(of: controller) {
                popToViewController(viewController, animated: true)
                break
            }
        }
    }
}
