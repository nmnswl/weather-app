//
//  StoryboardIdentifier.swift
//  WeatherApp

import Foundation

struct StoryboardIdentifier {
    let name: String
    let bundle: Bundle
    
    init(name: String, bundle: Bundle = Bundle.main) {
        self.name = name
        self.bundle = bundle
    }
}
