//
//  Indicator.swift
//  WeatherApp

import UIKit

final class Indicator: UIView {
    private var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.2)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addSubview(activityIndicator)
        activityIndicator.center = self.center
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        //Start animating indicator
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        //Stop animating indicator
        activityIndicator.stopAnimating()
    }
}
