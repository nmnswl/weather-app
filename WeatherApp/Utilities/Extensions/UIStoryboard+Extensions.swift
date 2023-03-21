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
}
