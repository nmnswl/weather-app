//
//  APIKeyHandler.swift
//  WeatherApp

import Foundation

struct APIKeyHandler {
    static var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
            }
            return value
        }
    }
}
