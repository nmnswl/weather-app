//
//  MockWeatherInfoNetworkService.swift
//  WeatherAppTests

import Foundation
@testable import WeatherApp
import WeatherInformation

enum Status {
    case success
    case error
}

class MockWeatherInfoNetworkService: WeatherInfoNetworkServiceProtocol {
    var isFetchWeatherInfo = false
    var status = Status.success
    var completion: WebRequestCompletion?
    var mockErrorResponse: Error?
    
    func fetchWeatherInfo(for city: String, in units: WeatherApp.Units, completion: @escaping WeatherApp.WebRequestCompletion) {
        isFetchWeatherInfo = true
        let mockResponse = generateMockDataResponse()
        switch status {
        case .success:
            completion(.success(mockResponse))
        case .error:
            completion(.failure(APIError.noData))
        }
    }
    
    func generateMockDataResponse() -> WeatherInfo {
        let weather = WeatherModel(id: 1, main: "Cloudy", description: "Cloudy sky", icon: "01d")
        let main = MainModel(temp: 20.01, pressure: 1006, humidity: 32, temp_min: 19.01, temp_max: 22.01)
        let wind = WindModel(speed: 6.15)
        let cityName = "Goa"
        let weatherInfoModel = WeatherInfo(weather: [weather], main: main, wind: wind, visibility: 10000, name: cityName)
        return weatherInfoModel
    }
}
