//
//  UIViewController+Extensions.swift
//  WeatherApp

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension UIViewController: Identifiable {
    static var identifier: String { return String(describing: self) }
    
    func topMostViewController() -> UIViewController {
        //Returns the top most view controller
        let rootViewController = AppDelegate.shared.window?.rootViewController ?? UIViewController()
        return rootViewController.topViewController()
    }
    
    private func topViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topViewController()
        }
        
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController() ?? navigationController
        }
        
        return self
    }
    
    /**
     Method used to display alert controller
     - parameter title: Title for the alert
     - parameter message: Message shown in the alert
     - parameter completion: Completion handler
     - parameter style: Style of the alert
     - parameter buttons: Buttons shown in the alert
     */
    func showAlertControllerWith(title: String,
                                 message: String,
                                 completion: NullableCompletion = nil,
                                 style: UIAlertController.Style = .alert,
                                 buttons: AlertButton...) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        for button in buttons {
            let action = UIAlertAction(title: button.name,
                                       style: button.style) { _ in
                if let actionToPerform = button.action {
                    actionToPerform()
                }
            }
            alertController.addAction(action)
        }
        present(alertController, animated: true,
                completion: completion)
    }
}
