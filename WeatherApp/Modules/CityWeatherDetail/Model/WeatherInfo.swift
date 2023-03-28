//
//  WeatherInfo.swift
//  WeatherApp

import Foundation
import CoreData

//Model for API response
struct WeatherInfo: Decodable {
    let weather: [WeatherModel]?
    let main: MainModel?
    let wind: WindModel?
    let visibility: Double?
    let name: String?
    
    /**
     Method to convert API response domain model to core data persistence object
     - parameters: a managed object context
     - returns: core data object of type WeatherInfoResponse
     **/
    func convertToManagedObject(in context: NSManagedObjectContext) -> WeatherInfoResponse? {
        guard let weatherInfoResponse = WeatherInfoResponse(context: context) else { return nil }
        let mainManagedObject = main?.convertToManagedObject(in: context)
        let windManagedObject = wind?.convertToManagedObject(in: context)
        weatherInfoResponse.main = mainManagedObject
        weatherInfoResponse.wind = windManagedObject
        weatherInfoResponse.visibility = visibility ?? 0.0
        weatherInfoResponse.name = name
        if let weatherManagedObject = weather?.first?.convertToManagedObject(in: context) {
            var set: Set<Weather> = []
            set.insert(weatherManagedObject)
            weatherInfoResponse.weather = set
        }
        return weatherInfoResponse
    }
}

struct WeatherModel: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    /**
     Method to convert API response domain model to core data persistence object
     - parameters: a managed object context
     - returns: core data object of type Weather
     **/
    func convertToManagedObject(in context: NSManagedObjectContext) -> Weather? {
        guard let weather = Weather(context: context) else { return nil }
        weather.id = Int16(id ?? 0)
        weather.main = main
        weather.weatherDescription = description
        weather.icon = icon
        return weather
    }
}

struct MainModel: Decodable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
    let temp_min: Double?
    let temp_max: Double?
    
    /**
     Method to convert API response domain model to core data persistence object
     - parameters: a managed object context
     - returns: core data object of type Main
     **/
    func convertToManagedObject(in context: NSManagedObjectContext) -> Main? {
        guard let main = Main(context: context) else { return nil }
        main.temp = temp ?? 0.0
        main.pressure = pressure ?? 0.0
        main.humidity = humidity ?? 0.0
        main.temp_min = temp_min ?? 0.0
        main.temp_max = temp_max ?? 0.0
        return main
    }
}

struct WindModel: Decodable {
    let speed: Double?
    
    /**
     Method to convert API response domain model to core data persistence object
     - parameters: a managed object context
     - returns: core data object of type Wind
     **/
    func convertToManagedObject(in context: NSManagedObjectContext) -> Wind? {
        guard let wind = Wind(context: context) else { return nil }
        wind.speed = speed ?? 0.0
        return wind
    }
}
