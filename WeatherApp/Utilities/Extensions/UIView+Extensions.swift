//
//  UIView+Extensions.swift
//  WeatherApp

import UIKit

extension UIView {
    /**
     Method to add indicator on a view
     */
    func showIndicator() {
        let indicator = Indicator(frame: frame)
        addSubview(indicator)
    }
    
    /**
     Method to hide the indicator
     */
    func hideIndicator() {
        if let indicator = subviews.first(where: { $0 is Indicator }) as? Indicator {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}
