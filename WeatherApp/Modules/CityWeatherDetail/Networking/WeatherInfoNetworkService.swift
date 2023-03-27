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
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let request = URLRequest(endpoint: endpoint) else { return }
        let decoder = JSONDecoder()
        let coreDataManager = CoreDataManager()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = coreDataManager.managedObjectContext
        APIManager.sharedInstance.makeRequest(request: request, decoder: decoder, completion: completion)
    }
}
