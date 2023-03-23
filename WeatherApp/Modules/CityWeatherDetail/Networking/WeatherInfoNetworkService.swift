//
//  WeatherInfoNetworkService.swift
//  WeatherApp

import Foundation
import WeatherInformation

typealias WebRequestCompletion = (Result<WeatherInfoResponse, Error>) -> Void

protocol WeatherInfoNetworkServiceProtocol {
    func fetchWeatherInfo(for city: String,
                          in units: Units,
                          completion: @escaping WebRequestCompletion)
}

class WeatherInfoNetworkService: WeatherInfoNetworkServiceProtocol {
    /**
     Method to call API to fetch weather info
     - parameter city: Name of city
     - parameter units: Unit of measurement
     - parameter completion: Completion handler
     */
    func fetchWeatherInfo(for city: String,
                          in units: Units,
                          completion: @escaping WebRequestCompletion) {
        let endpoint = UserEndpoints.fetchWeatherInfoForCity(city, units)
        if let request = URLRequest(endpoint: endpoint) {
            APIManager.sharedInstance.makeRequest(request: request, completion: completion)
        }
    }
}
