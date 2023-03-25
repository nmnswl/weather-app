//
//  UIStoryboard+Extensions.swift
//  WeatherApp

import UIKit

extension UIStoryboard {
    convenience init(identifier: StoryboardIdentifier) {
        self.init(name: identifier.name, bundle: identifier.bundle)
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(identifier: StoryboardIdentifier(name: "Main"))
    
    func instantiateViewController<T: UIViewController>(_ controller: T.Type) -> T {
        //Method to instantiate view controller
        let identifier = (controller as UIViewController.Type).identifier
        return instantiateViewController(withIdentifier: identifier) as? T ?? T()
    }
}
