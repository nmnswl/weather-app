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
    
    /**
     Method to add round corners
     - parameter radius: radius for corners
     */
    func roundCornersWithRadius(_ radius: Double) {
        layer.cornerRadius = radius
    }
    
    /**
     Method to add round corners
     - parameter color: colour of border
     - parameter width: width of border
     */
    func applyBorder(color: UIColor, width: Double) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
