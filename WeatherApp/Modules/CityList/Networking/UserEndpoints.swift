//
//  UserEndpoints.swift
//  WeatherApp

import Foundation

//Handling units of measurement
enum Units {
    case metric
    case standard
    case imperial
    
    var value: String {
        switch self {
        case .metric: return "metric"
        case .standard: return "standard"
        case .imperial: return "imperial"
        }
    }
}

//Handling methods
enum HTTPMethod {
    case get
    
    var value: String {
        switch self {
        case .get: return "GET"
        }
    }
}

//Handling endpoints
enum UserEndpoints {
    case fetchWeatherInfoForCity(String, Units)
    
    var url: String {
        switch self {
        case .fetchWeatherInfoForCity(let city, let unit): return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=\(unit.value)&appid=\(APIKeyHandler.apiKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchWeatherInfoForCity: return .get
        }
    }
}

extension URLRequest {
    init?(endpoint: UserEndpoints)  {
        if let url = URL(string: endpoint.url) {
            self.init(url: url)
            self.httpMethod = endpoint.method.value
        } else {
            return nil
        }
    }
}
