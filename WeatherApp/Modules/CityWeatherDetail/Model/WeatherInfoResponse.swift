//
//  WeatherInfoResponse.swift
//  WeatherApp

import Foundation
import CoreData

@objc(WeatherInfoResponse)
class WeatherInfoResponse: NSManagedObject, Decodable {
    @NSManaged public var main: Main?
    @NSManaged public var wind: Wind?
    @NSManaged public var visibility: Double
    @NSManaged public var name: String?
    @NSManaged public var weather: Set<Weather>?
    
    enum CodingKeys: String, CodingKey {
        case main = "Main"
        case wind = "wind"
        case visibility = "visibility"
        case name = "name"
        case weather = "weather"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "WeatherInfoResponse", in: managedObjectContext) else {
            fatalError("Unable to decode WeatherInfoResponse")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let main = try container.decodeIfPresent(Main.self, forKey: .main) {
            self.main = main
        }
        if let wind = try container.decodeIfPresent(Wind.self, forKey: .wind) {
            self.wind = wind
        }
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility) ?? Double.greatestFiniteMagnitude
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let weatherArray = try container.decodeIfPresent([Weather].self, forKey: .weather) ?? []
        self.weather = Set(weatherArray)
    }
}

@objc(Main)
class Main: NSManagedObject, Decodable {
    @NSManaged public var temp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var mainOf: WeatherInfoResponse?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case mainOf = "mainOf"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Main", in: managedObjectContext) else {
            fatalError("Unable to decode Main")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? Double.greatestFiniteMagnitude
        self.pressure = try container.decodeIfPresent(Double.self, forKey: .pressure) ?? Double.greatestFiniteMagnitude
        self.humidity = try container.decodeIfPresent(Double.self, forKey: .humidity) ?? Double.greatestFiniteMagnitude
        self.temp_min = try container.decodeIfPresent(Double.self, forKey: .temp_min) ?? Double.greatestFiniteMagnitude
        self.temp_max = try container.decodeIfPresent(Double.self, forKey: .temp_max) ?? Double.greatestFiniteMagnitude
        if let mainOf = try container.decodeIfPresent(WeatherInfoResponse.self, forKey: .mainOf) {
            self.mainOf = mainOf
        }
    }
}

@objc(Wind)
class Wind: NSManagedObject, Decodable {
    @NSManaged public var speed: Double
    @NSManaged public var windOf: WeatherInfoResponse?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case windOf = "windOf"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Wind", in: managedObjectContext) else {
            fatalError("Unable to decode Wind")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decodeIfPresent(Double.self, forKey: .speed) ?? Double.greatestFiniteMagnitude
        if let windOf = try container.decodeIfPresent(WeatherInfoResponse.self, forKey: .windOf) {
            self.windOf = windOf
        }
    }
}

@objc(Weather)
class Weather: NSManagedObject, Decodable {
    @NSManaged public var id: Int16
    @NSManaged public var main: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherOf: WeatherInfoResponse
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
        case weatherOf = "weatherOf"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedObjectContext) else {
            fatalError("Unable to decode Weather")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int16.self, forKey: .id) ?? 0
        self.main = try container.decodeIfPresent(String.self, forKey: .main) ?? ""
        self.weatherDescription = try container.decodeIfPresent(String.self, forKey: .weatherDescription) ?? ""
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""
        if let weatherOf = try container.decodeIfPresent(WeatherInfoResponse.self, forKey: .weatherOf) {
            self.weatherOf = weatherOf
        }
    }
}
