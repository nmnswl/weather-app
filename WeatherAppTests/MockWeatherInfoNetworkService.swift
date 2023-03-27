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
    let coreDataManager = CoreDataManager()
    
    init(status: Status) {
        self.status = status
    }
    
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
    
    func generateMockDataResponse() -> WeatherInfoResponse {
        let cityName = "Goa"
        
        let weather = Weather(context: coreDataManager.managedObjectContext)
        weather.id = 1
        weather.main = "Cloudy"
        weather.weatherDescription = "Cloudy sky"
        weather.icon = "01d"
        
        let main = Main(context: coreDataManager.managedObjectContext)
        main.temp = 20.01
        main.pressure = 1006
        main.humidity = 32
        main.temp_min = 19.01
        main.temp_max = 22.01
        
        let wind = Wind(context: coreDataManager.managedObjectContext)
        wind.speed = 6.15
        
        let weatherInfoResponse = WeatherInfoResponse(context: coreDataManager.managedObjectContext)
        weatherInfoResponse.weather = [weather]
        weatherInfoResponse.main = main
        weatherInfoResponse.wind = wind
        weatherInfoResponse.visibility = 10000
        weatherInfoResponse.name = cityName
        
        return weatherInfoResponse
    }
}
