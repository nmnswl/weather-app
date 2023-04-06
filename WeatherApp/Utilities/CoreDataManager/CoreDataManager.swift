//
//  CoreDataManager.swift
//  WeatherApp

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "WeatherApp")
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            debugPrint(error?.localizedDescription ?? "")
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
            debugPrint(error.localizedDescription)
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
            debugPrint(error.localizedDescription)
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
            debugPrint(error.localizedDescription)
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
            fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", city)
            let recordCount = try managedObjectContext.count(for: fetchRequest)
            return recordCount != 0
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
}

