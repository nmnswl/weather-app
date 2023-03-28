//
//  WeatherInfoResponse.swift
//  WeatherApp

import Foundation
import CoreData

@objc(WeatherInfoResponse)
class WeatherInfoResponse: NSManagedObject {
    @NSManaged public var main: Main?
    @NSManaged public var wind: Wind?
    @NSManaged public var visibility: Double
    @NSManaged public var name: String?
    @NSManaged public var weather: Set<Weather>?
    
    /**
     Method to update core data with API response
     - parameters: an API response object of type WeatherInfo
     */
    func updateDetails(with weatherInfo: WeatherInfo) {
        //Method to update core data with API response
        main?.temp = weatherInfo.main?.temp ?? 0.0
        main?.temp_max = weatherInfo.main?.temp_max ?? 0.0
        main?.temp_min = weatherInfo.main?.temp_min ?? 0.0
        main?.humidity = weatherInfo.main?.humidity ?? 0.0
        main?.pressure = weatherInfo.main?.pressure ?? 0.0
        
        wind?.speed = weatherInfo.wind?.speed ?? 0.0
        
        let weatherModel = weatherInfo.weather?.first
        let weatherManagedObject = weather?.first
        weatherManagedObject?.id = Int16(weatherModel?.id ?? 0)
        weatherManagedObject?.main = weatherModel?.main
        weatherManagedObject?.weatherDescription = weatherModel?.description
        weatherManagedObject?.icon = weatherModel?.icon
        
        visibility = weatherInfo.visibility ?? 0.0
        name = weatherInfo.name
    }
    
    /**
     Method to convert core data persistence object to API response object
     - returns: object of type WeatherInfo
     */
    func convertToModel() -> WeatherInfo? {
        let main = MainModel(temp: main?.temp, pressure: main?.pressure, humidity: main?.humidity, temp_min: main?.temp_min, temp_max: main?.temp_max)
        let wind = WindModel(speed: wind?.speed)
        let weatherManagedObject = weather?.first
        let weather = WeatherModel(id: Int(weatherManagedObject?.id ?? 0), main: weatherManagedObject?.main, description: weatherManagedObject?.weatherDescription, icon: weatherManagedObject?.icon)
        
        let weatherInfo = WeatherInfo(weather: [weather], main: main, wind: wind, visibility: visibility, name: name)
        return weatherInfo
    }
}

@objc(Main)
class Main: NSManagedObject {
    @NSManaged public var temp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var mainOf: WeatherInfoResponse?
}

@objc(Wind)
class Wind: NSManagedObject {
    @NSManaged public var speed: Double
    @NSManaged public var windOf: WeatherInfoResponse?
}

@objc(Weather)
class Weather: NSManagedObject {
    @NSManaged public var id: Int16
    @NSManaged public var main: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherOf: WeatherInfoResponse
}

extension NSManagedObject {
    convenience init?(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
    }
}
