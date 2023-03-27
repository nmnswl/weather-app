//
//  CoreDataManager.swift
//  WeatherApp

import Foundation
import CoreData

extension CodingUserInfoKey {
    //Property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

final class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "WeatherApp")
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /**
     Method to save data in Core data
     */
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /**
     Method to fetch all saved data
     - returns: Array of data
     */
    func fetchAll() -> [WeatherInfoResponse]? {
        do {
            let fetchRequest = NSFetchRequest<WeatherInfoResponse>(entityName: "WeatherInfoResponse")
            let weatherInfo = try managedObjectContext.fetch(fetchRequest)
            return weatherInfo
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     Method to fetch data for a specific city
     - returns: Data for a specific city
     */
    func fetchWeatherDetails(for city: String) -> WeatherInfoResponse? {
        do {
            let fetchRequest = NSFetchRequest<WeatherInfoResponse>(entityName: "WeatherInfoResponse")
            fetchRequest.predicate = NSPredicate(format: "name == %@", city)
            let weatherInfo = try managedObjectContext.fetch(fetchRequest)
            return weatherInfo.last
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     Method to check if specifc object already exists
     - returns: true if already exists else returns false
     */
    func checkIfAlreadyExists(for city: String) -> Bool {
        do {
            let fetchRequest = NSFetchRequest<WeatherInfoResponse>(entityName: "WeatherInfoResponse")
            fetchRequest.predicate = NSPredicate(format: "name == %@", city)
            let recordCount = try managedObjectContext.count(for: fetchRequest)
            return recordCount != 0
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /**
     Method to delete object
     - parameters: the object to delete
     */
    func deleteCity(with weatherInfo: WeatherInfoResponse) {
        managedObjectContext.delete(weatherInfo)
        save()
    }
}

